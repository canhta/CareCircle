"""
API client for uploading content to CareCircle backend.
"""

import time
import json
import gzip
from typing import Dict, List, Any, Optional, Tuple
from datetime import datetime, timezone
import requests
from loguru import logger


class APIClient:
    """
    Client for communicating with CareCircle backend API.
    
    Handles authentication, rate limiting, batch uploads,
    and error handling for content ingestion.
    """
    
    def __init__(self, config: Dict[str, Any]):
        """
        Initialize API client.
        
        Args:
            config: API configuration including endpoints and auth
        """
        self.config = config
        self.base_url = config["backend_url"].rstrip("/")
        self.endpoints = config["api_endpoints"]
        
        # Set up session with authentication
        self.session = requests.Session()
        self._setup_authentication()
        self._setup_headers()
        
        # Rate limiting
        self.last_request_time = 0
        self.request_count = 0
        self.rate_limits = config["rate_limiting"]
        
        # Upload statistics
        self.upload_stats = {
            "total_uploads": 0,
            "successful_uploads": 0,
            "failed_uploads": 0,
            "total_items": 0,
            "successful_items": 0
        }
        
        logger.info(f"Initialized API client for {self.base_url}")
    
    def _setup_authentication(self):
        """Set up authentication headers."""
        auth_config = self.config["authentication"]
        
        if auth_config["type"] == "firebase_jwt":
            import os
            token = os.getenv(auth_config["token_env_var"])
            if not token:
                raise ValueError(f"Missing environment variable: {auth_config['token_env_var']}")
            
            auth_header = f"{auth_config['token_prefix']} {token}"
            self.session.headers[auth_config["token_header"]] = auth_header
            logger.info("Firebase JWT authentication configured")
        else:
            raise ValueError(f"Unsupported authentication type: {auth_config['type']}")
    
    def _setup_headers(self):
        """Set up default headers."""
        headers = self.config.get("headers", {})
        self.session.headers.update(headers)
    
    def _rate_limit(self, endpoint_type: str = "default"):
        """Implement rate limiting for API requests."""
        current_time = time.time()
        
        # Get rate limit for endpoint type
        if endpoint_type == "bulk_upload":
            requests_per_minute = self.rate_limits["batch_requests_per_minute"]
        elif endpoint_type == "status":
            requests_per_minute = self.rate_limits["status_requests_per_minute"]
        elif endpoint_type == "validate":
            requests_per_minute = self.rate_limits["validate_requests_per_minute"]
        else:
            requests_per_minute = self.rate_limits["requests_per_minute"]
        
        min_interval = 60.0 / requests_per_minute
        time_since_last = current_time - self.last_request_time
        
        if time_since_last < min_interval:
            sleep_time = min_interval - time_since_last
            logger.debug(f"Rate limiting: sleeping for {sleep_time:.2f} seconds")
            time.sleep(sleep_time)
        
        self.last_request_time = time.time()
    
    def _make_request(
        self, 
        method: str, 
        endpoint: str, 
        data: Optional[Dict] = None,
        endpoint_type: str = "default"
    ) -> Tuple[bool, Optional[Dict], Optional[str]]:
        """
        Make an API request with error handling and retries.
        
        Args:
            method: HTTP method (GET, POST, etc.)
            endpoint: API endpoint path
            data: Request data
            endpoint_type: Type of endpoint for rate limiting
            
        Returns:
            Tuple of (success, response_data, error_message)
        """
        url = f"{self.base_url}{endpoint}"
        
        # Rate limiting
        self._rate_limit(endpoint_type)
        
        # Request settings
        request_settings = self.config["request_settings"]
        max_retries = request_settings["max_retries"]
        timeout = request_settings["timeout"]
        
        for attempt in range(max_retries + 1):
            try:
                start_time = time.time()
                
                if method.upper() == "GET":
                    response = self.session.get(url, timeout=timeout, params=data)
                else:
                    # Compress payload if enabled and data is large
                    if (data and 
                        self.config["upload_settings"].get("compress_payload", False) and
                        len(json.dumps(data)) > 10000):
                        
                        compressed_data = gzip.compress(json.dumps(data).encode('utf-8'))
                        response = self.session.post(
                            url,
                            data=compressed_data,
                            headers={"Content-Encoding": "gzip"},
                            timeout=timeout
                        )
                    else:
                        response = self.session.post(url, json=data, timeout=timeout)
                
                response_time = time.time() - start_time
                
                # Log request
                logger.debug(f"API {method} {endpoint} -> {response.status_code} ({response_time:.2f}s)")
                
                if response.status_code == 200:
                    return True, response.json(), None
                elif response.status_code == 429:  # Rate limited
                    retry_after = int(response.headers.get("Retry-After", 60))
                    logger.warning(f"Rate limited, waiting {retry_after} seconds")
                    time.sleep(retry_after)
                    continue
                else:
                    error_msg = f"HTTP {response.status_code}: {response.text}"
                    logger.warning(error_msg)
                    
                    if attempt < max_retries:
                        retry_delay = request_settings["retry_delay"] * (request_settings["backoff_factor"] ** attempt)
                        logger.info(f"Retrying in {retry_delay} seconds...")
                        time.sleep(retry_delay)
                    else:
                        return False, None, error_msg
                        
            except requests.exceptions.RequestException as e:
                error_msg = f"Request failed: {str(e)}"
                logger.warning(error_msg)
                
                if attempt < max_retries:
                    retry_delay = request_settings["retry_delay"] * (request_settings["backoff_factor"] ** attempt)
                    logger.info(f"Retrying in {retry_delay} seconds...")
                    time.sleep(retry_delay)
                else:
                    return False, None, error_msg
        
        return False, None, "Max retries exceeded"
    
    def upload_single_content(self, content_item: Dict[str, Any]) -> Tuple[bool, Optional[str]]:
        """
        Upload a single content item.
        
        Args:
            content_item: Content item to upload
            
        Returns:
            Tuple of (success, content_id or error_message)
        """
        endpoint = self.endpoints["content_upload"]
        
        success, response_data, error = self._make_request("POST", endpoint, content_item)
        
        self.upload_stats["total_uploads"] += 1
        self.upload_stats["total_items"] += 1
        
        if success and response_data:
            content_id = response_data.get("content_id")
            logger.info(f"Successfully uploaded content: {content_id}")
            
            self.upload_stats["successful_uploads"] += 1
            self.upload_stats["successful_items"] += 1
            
            return True, content_id
        else:
            logger.error(f"Failed to upload content: {error}")
            self.upload_stats["failed_uploads"] += 1
            return False, error
    
    def upload_batch(self, content_items: List[Dict[str, Any]], batch_id: Optional[str] = None) -> Tuple[bool, Dict[str, Any]]:
        """
        Upload a batch of content items.
        
        Args:
            content_items: List of content items to upload
            batch_id: Optional batch identifier
            
        Returns:
            Tuple of (success, upload_results)
        """
        if not content_items:
            return True, {"message": "No items to upload"}
        
        # Generate batch ID if not provided
        if not batch_id:
            timestamp = datetime.now(timezone.utc).strftime("%Y%m%d_%H%M%S")
            batch_id = f"batch_{timestamp}"
        
        # Split into chunks if necessary
        chunk_size = self.config["upload_settings"]["chunk_size"]
        chunks = [content_items[i:i + chunk_size] for i in range(0, len(content_items), chunk_size)]
        
        logger.info(f"Uploading batch {batch_id}: {len(content_items)} items in {len(chunks)} chunks")
        
        upload_results = {
            "batch_id": batch_id,
            "total_items": len(content_items),
            "successful_items": 0,
            "failed_items": 0,
            "chunks": []
        }
        
        for i, chunk in enumerate(chunks):
            chunk_batch_id = f"{batch_id}_chunk_{i + 1}"
            
            batch_data = {
                "batch_id": chunk_batch_id,
                "source_id": chunk[0]["source_id"] if chunk else "unknown",
                "items": chunk
            }
            
            endpoint = self.endpoints["bulk_upload"]
            success, response_data, error = self._make_request("POST", endpoint, batch_data, "bulk_upload")
            
            self.upload_stats["total_uploads"] += 1
            self.upload_stats["total_items"] += len(chunk)
            
            chunk_result = {
                "chunk_id": chunk_batch_id,
                "items_count": len(chunk),
                "success": success
            }
            
            if success and response_data:
                accepted_items = response_data.get("accepted_items", 0)
                rejected_items = response_data.get("rejected_items", 0)
                
                upload_results["successful_items"] += accepted_items
                upload_results["failed_items"] += rejected_items
                
                chunk_result.update({
                    "accepted_items": accepted_items,
                    "rejected_items": rejected_items,
                    "response": response_data
                })
                
                self.upload_stats["successful_uploads"] += 1
                self.upload_stats["successful_items"] += accepted_items
                
                logger.info(f"Chunk {chunk_batch_id}: {accepted_items} accepted, {rejected_items} rejected")
            else:
                upload_results["failed_items"] += len(chunk)
                chunk_result["error"] = error
                
                self.upload_stats["failed_uploads"] += 1
                
                logger.error(f"Chunk {chunk_batch_id} failed: {error}")
            
            upload_results["chunks"].append(chunk_result)
        
        overall_success = upload_results["failed_items"] == 0
        
        logger.info(
            f"Batch upload completed: {upload_results['successful_items']} successful, "
            f"{upload_results['failed_items']} failed"
        )
        
        return overall_success, upload_results
    
    def check_upload_status(self, batch_id: str) -> Tuple[bool, Optional[Dict[str, Any]]]:
        """
        Check the status of an uploaded batch.
        
        Args:
            batch_id: Batch identifier to check
            
        Returns:
            Tuple of (success, status_data)
        """
        endpoint = self.endpoints["status"]
        params = {"batch_id": batch_id}
        
        success, response_data, error = self._make_request("GET", endpoint, params, "status")
        
        if success:
            logger.info(f"Status check for {batch_id}: {response_data.get('overall_status', 'unknown')}")
            return True, response_data
        else:
            logger.error(f"Status check failed for {batch_id}: {error}")
            return False, None
    
    def validate_source(self, source_config: Dict[str, Any]) -> Tuple[bool, Optional[Dict[str, Any]]]:
        """
        Validate a source configuration with the backend.
        
        Args:
            source_config: Source configuration to validate
            
        Returns:
            Tuple of (success, validation_results)
        """
        endpoint = self.endpoints["source_validate"]
        data = {"source_config": source_config}
        
        success, response_data, error = self._make_request("POST", endpoint, data, "validate")
        
        if success:
            logger.info(f"Source validation successful: {source_config.get('id', 'unknown')}")
            return True, response_data
        else:
            logger.error(f"Source validation failed: {error}")
            return False, None
    
    def get_upload_stats(self) -> Dict[str, Any]:
        """Get upload statistics."""
        stats = self.upload_stats.copy()
        
        if stats["total_uploads"] > 0:
            stats["upload_success_rate"] = stats["successful_uploads"] / stats["total_uploads"]
        else:
            stats["upload_success_rate"] = 0.0
        
        if stats["total_items"] > 0:
            stats["item_success_rate"] = stats["successful_items"] / stats["total_items"]
        else:
            stats["item_success_rate"] = 0.0
        
        return stats
    
    def reset_stats(self):
        """Reset upload statistics."""
        self.upload_stats = {
            "total_uploads": 0,
            "successful_uploads": 0,
            "failed_uploads": 0,
            "total_items": 0,
            "successful_items": 0
        }
        logger.info("Upload statistics reset")
