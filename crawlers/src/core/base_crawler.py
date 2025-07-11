"""
Base crawler class for Vietnamese healthcare sources.
"""

import time
import hashlib
import requests
from abc import ABC, abstractmethod
from typing import Dict, List, Optional, Any, Generator
from urllib.parse import urljoin, urlparse
from urllib.robotparser import RobotFileParser
from bs4 import BeautifulSoup
from loguru import logger
from datetime import datetime, timezone
import json
import os


class BaseCrawler(ABC):
    """
    Base class for all Vietnamese healthcare crawlers.
    
    Provides common functionality for rate limiting, error handling,
    content extraction, and politeness policies.
    """
    
    def __init__(self, source_config: Dict[str, Any], settings: Dict[str, Any]):
        """
        Initialize the base crawler.
        
        Args:
            source_config: Configuration for the specific source
            settings: Global crawler settings
        """
        self.source_config = source_config
        self.settings = settings
        self.source_id = source_config["id"]
        self.source_name = source_config["name"]
        self.base_url = source_config["base_url"]
        
        # Set up session with proper headers
        self.session = requests.Session()
        self.session.headers.update({
            "User-Agent": settings["general"]["user_agent"],
            "Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8",
            "Accept-Language": "vi-VN,vi;q=0.9,en;q=0.8",
            "Accept-Encoding": "gzip, deflate",
            "Connection": "keep-alive",
            "Upgrade-Insecure-Requests": "1"
        })
        
        # Rate limiting
        self.rate_limit = source_config.get("rate_limit", settings["rate_limiting"]["default_delay"])
        self.last_request_time = 0
        
        # Robots.txt handling
        self.robots_parser = None
        if settings["rate_limiting"]["respect_robots_txt"]:
            self._load_robots_txt()
        
        # Content tracking
        self.crawled_urls = set()
        self.extracted_items = []
        self.errors = []
        
        logger.info(f"Initialized crawler for {self.source_name}")
    
    def _load_robots_txt(self):
        """Load and parse robots.txt for the source."""
        try:
            robots_url = urljoin(self.base_url, "/robots.txt")
            self.robots_parser = RobotFileParser()
            self.robots_parser.set_url(robots_url)
            self.robots_parser.read()
            logger.info(f"Loaded robots.txt from {robots_url}")
        except Exception as e:
            logger.warning(f"Could not load robots.txt: {e}")
            self.robots_parser = None
    
    def _can_fetch(self, url: str) -> bool:
        """Check if URL can be fetched according to robots.txt."""
        if not self.robots_parser:
            return True
        
        user_agent = self.settings["general"]["user_agent"]
        return self.robots_parser.can_fetch(user_agent, url)
    
    def _rate_limit(self):
        """Implement rate limiting between requests."""
        current_time = time.time()
        time_since_last = current_time - self.last_request_time
        
        if time_since_last < self.rate_limit:
            sleep_time = self.rate_limit - time_since_last
            logger.debug(f"Rate limiting: sleeping for {sleep_time:.2f} seconds")
            time.sleep(sleep_time)
        
        self.last_request_time = time.time()
    
    def _make_request(self, url: str, **kwargs) -> Optional[requests.Response]:
        """
        Make a rate-limited HTTP request with error handling.
        
        Args:
            url: URL to request
            **kwargs: Additional arguments for requests
            
        Returns:
            Response object or None if failed
        """
        # Check robots.txt
        if not self._can_fetch(url):
            logger.warning(f"Robots.txt disallows fetching {url}")
            return None
        
        # Rate limiting
        self._rate_limit()
        
        # Make request with retries
        max_retries = self.settings["general"]["max_retries"]
        timeout = self.settings["general"]["timeout"]
        
        for attempt in range(max_retries + 1):
            try:
                logger.debug(f"Requesting {url} (attempt {attempt + 1})")
                
                response = self.session.get(
                    url,
                    timeout=timeout,
                    **kwargs
                )
                
                if response.status_code == 200:
                    logger.debug(f"Successfully fetched {url}")
                    return response
                elif response.status_code == 429:  # Rate limited
                    retry_after = int(response.headers.get("Retry-After", 60))
                    logger.warning(f"Rate limited, waiting {retry_after} seconds")
                    time.sleep(retry_after)
                    continue
                else:
                    logger.warning(f"HTTP {response.status_code} for {url}")
                    
            except requests.exceptions.RequestException as e:
                logger.warning(f"Request failed for {url}: {e}")
                
                if attempt < max_retries:
                    retry_delay = self.settings["general"]["retry_delay"] * (2 ** attempt)
                    logger.info(f"Retrying in {retry_delay} seconds...")
                    time.sleep(retry_delay)
                else:
                    logger.error(f"Max retries exceeded for {url}")
                    self.errors.append({
                        "url": url,
                        "error": str(e),
                        "timestamp": datetime.now(timezone.utc).isoformat()
                    })
        
        return None
    
    def _extract_content(self, response: requests.Response, url: str) -> Optional[Dict[str, Any]]:
        """
        Extract content from a response using configured selectors.
        
        Args:
            response: HTTP response object
            url: Source URL
            
        Returns:
            Extracted content dictionary or None
        """
        try:
            soup = BeautifulSoup(response.content, 'html.parser')
            selectors = self.source_config["selectors"]
            
            # Extract title
            title_elem = soup.select_one(selectors["title"])
            title = title_elem.get_text(strip=True) if title_elem else ""
            
            # Extract main content
            content_elem = soup.select_one(selectors["content"])
            if not content_elem:
                logger.warning(f"No content found for {url}")
                return None
            
            content = content_elem.get_text(strip=True)
            
            # Extract date
            date_elem = soup.select_one(selectors.get("date", ""))
            published_date = None
            if date_elem:
                date_text = date_elem.get_text(strip=True)
                published_date = self._parse_date(date_text)
            
            # Extract author
            author_elem = soup.select_one(selectors.get("author", ""))
            author = author_elem.get_text(strip=True) if author_elem else ""
            
            # Content validation
            if len(content) < self.settings["content_processing"]["min_content_length"]:
                logger.warning(f"Content too short for {url}: {len(content)} characters")
                return None
            
            if len(content) > self.settings["content_processing"]["max_content_length"]:
                logger.warning(f"Content too long for {url}: {len(content)} characters")
                content = content[:self.settings["content_processing"]["max_content_length"]]
            
            # Generate content hash for deduplication
            content_hash = hashlib.sha256(content.encode('utf-8')).hexdigest()
            
            extracted_item = {
                "source_id": self.source_id,
                "source_url": url,
                "title": title,
                "content": content,
                "content_type": self._determine_content_type(url, title, content),
                "language": self.source_config["language"],
                "published_at": published_date,
                "crawled_at": datetime.now(timezone.utc).isoformat(),
                "metadata": {
                    "author": author,
                    "source_name": self.source_name,
                    "source_type": self.source_config["type"],
                    "content_hash": content_hash,
                    "content_length": len(content)
                }
            }
            
            logger.info(f"Extracted content from {url}: '{title[:50]}...'")
            return extracted_item
            
        except Exception as e:
            logger.error(f"Content extraction failed for {url}: {e}")
            self.errors.append({
                "url": url,
                "error": f"Content extraction failed: {str(e)}",
                "timestamp": datetime.now(timezone.utc).isoformat()
            })
            return None
    
    def _parse_date(self, date_text: str) -> Optional[str]:
        """Parse Vietnamese date text to ISO format."""
        # This is a simplified implementation
        # In practice, you'd want more sophisticated Vietnamese date parsing
        try:
            # Common Vietnamese date patterns
            import re
            from dateutil import parser
            
            # Remove Vietnamese day names and common words
            cleaned = re.sub(r'(thứ|chủ nhật|ngày|tháng|năm)', '', date_text, flags=re.IGNORECASE)
            cleaned = re.sub(r'\s+', ' ', cleaned).strip()
            
            # Try to parse with dateutil
            parsed_date = parser.parse(cleaned, fuzzy=True)
            return parsed_date.isoformat()
            
        except Exception:
            logger.debug(f"Could not parse date: {date_text}")
            return None
    
    @abstractmethod
    def _determine_content_type(self, url: str, title: str, content: str) -> str:
        """
        Determine the type of content based on URL, title, and content.
        
        Must be implemented by subclasses.
        """
        pass
    
    @abstractmethod
    def get_urls_to_crawl(self) -> Generator[str, None, None]:
        """
        Generate URLs to crawl for this source.
        
        Must be implemented by subclasses.
        """
        pass
    
    def crawl(self) -> List[Dict[str, Any]]:
        """
        Main crawling method.
        
        Returns:
            List of extracted content items
        """
        logger.info(f"Starting crawl for {self.source_name}")
        start_time = time.time()
        
        try:
            for url in self.get_urls_to_crawl():
                if url in self.crawled_urls:
                    continue
                
                self.crawled_urls.add(url)
                
                response = self._make_request(url)
                if response:
                    item = self._extract_content(response, url)
                    if item:
                        self.extracted_items.append(item)
                
                # Check if we've reached max pages
                max_pages = self.source_config.get("max_pages", 100)
                if len(self.crawled_urls) >= max_pages:
                    logger.info(f"Reached max pages limit ({max_pages})")
                    break
        
        except Exception as e:
            logger.error(f"Crawl failed for {self.source_name}: {e}")
            self.errors.append({
                "error": f"Crawl failed: {str(e)}",
                "timestamp": datetime.now(timezone.utc).isoformat()
            })
        
        end_time = time.time()
        duration = end_time - start_time
        
        logger.info(
            f"Crawl completed for {self.source_name}: "
            f"{len(self.crawled_urls)} pages, {len(self.extracted_items)} items, "
            f"{len(self.errors)} errors in {duration:.2f}s"
        )
        
        return self.extracted_items
    
    def get_stats(self) -> Dict[str, Any]:
        """Get crawling statistics."""
        return {
            "source_id": self.source_id,
            "source_name": self.source_name,
            "pages_crawled": len(self.crawled_urls),
            "items_extracted": len(self.extracted_items),
            "errors": len(self.errors),
            "error_details": self.errors
        }
