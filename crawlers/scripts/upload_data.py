#!/usr/bin/env python3
"""
Script to upload processed content to CareCircle backend.
"""

import os
import sys
import json
import argparse
from pathlib import Path
from datetime import datetime, timezone
from typing import Dict, List, Any

# Add src to path
sys.path.insert(0, str(Path(__file__).parent.parent / "src"))

from core.logger import setup_logger, get_logger
from core.api_client import APIClient
from utils.file_manager import FileManager

# Load environment variables
from dotenv import load_dotenv
load_dotenv()


def load_config(config_path: str) -> Dict[str, Any]:
    """Load configuration from JSON file."""
    try:
        with open(config_path, 'r', encoding='utf-8') as f:
            return json.load(f)
    except Exception as e:
        print(f"Error loading config {config_path}: {e}")
        sys.exit(1)


def load_processed_data(file_path: str) -> List[Dict[str, Any]]:
    """Load processed data from file."""
    logger = get_logger()
    
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            data = json.load(f)
        
        if isinstance(data, dict) and "items" in data:
            items = data["items"]
        elif isinstance(data, list):
            items = data
        else:
            raise ValueError("Invalid data format")
        
        logger.info(f"Loaded {len(items)} items from {file_path}")
        return items
        
    except Exception as e:
        logger.error(f"Failed to load data from {file_path}: {e}")
        return []


def validate_items(items: List[Dict[str, Any]]) -> List[Dict[str, Any]]:
    """Validate items before upload."""
    logger = get_logger()
    
    valid_items = []
    required_fields = ["source_id", "source_url", "title", "content", "language"]
    
    for i, item in enumerate(items):
        # Check required fields
        missing_fields = [field for field in required_fields if not item.get(field)]
        
        if missing_fields:
            logger.warning(f"Item {i}: Missing fields {missing_fields}")
            continue
        
        # Check content length
        if len(item["content"]) < 50:
            logger.warning(f"Item {i}: Content too short ({len(item['content'])} chars)")
            continue
        
        valid_items.append(item)
    
    logger.info(f"Validated {len(valid_items)}/{len(items)} items")
    return valid_items


def upload_items(items: List[Dict[str, Any]], api_config: Dict[str, Any], batch_id: str = None) -> Dict[str, Any]:
    """Upload items to backend."""
    logger = get_logger()
    
    if not items:
        return {"success": True, "message": "No items to upload"}
    
    try:
        api_client = APIClient(api_config)
        
        # Generate batch ID if not provided
        if not batch_id:
            timestamp = datetime.now(timezone.utc).strftime("%Y%m%d_%H%M%S")
            batch_id = f"upload_{timestamp}"
        
        logger.info(f"Uploading {len(items)} items with batch ID: {batch_id}")
        
        # Upload batch
        success, upload_results = api_client.upload_batch(items, batch_id)
        
        upload_stats = api_client.get_upload_stats()
        
        return {
            "success": success,
            "batch_id": batch_id,
            "upload_results": upload_results,
            "upload_stats": upload_stats
        }
        
    except Exception as e:
        logger.error(f"Upload failed: {e}")
        return {
            "success": False,
            "error": str(e)
        }


def check_upload_status(batch_id: str, api_config: Dict[str, Any]) -> Dict[str, Any]:
    """Check upload status."""
    logger = get_logger()
    
    try:
        api_client = APIClient(api_config)
        success, status_data = api_client.check_upload_status(batch_id)
        
        if success:
            return status_data
        else:
            logger.error(f"Failed to check status for batch {batch_id}")
            return None
            
    except Exception as e:
        logger.error(f"Status check failed: {e}")
        return None


def main():
    """Main execution function."""
    parser = argparse.ArgumentParser(description="Upload processed content to CareCircle backend")
    parser.add_argument("--file", help="Specific file to upload")
    parser.add_argument("--source", help="Upload latest processed data for specific source")
    parser.add_argument("--all", action="store_true", help="Upload all available processed data")
    parser.add_argument("--config-dir", default="./config", help="Configuration directory")
    parser.add_argument("--batch-id", help="Custom batch ID")
    parser.add_argument("--check-status", help="Check status of specific batch ID")
    parser.add_argument("--dry-run", action="store_true", help="Validate data without uploading")
    parser.add_argument("--log-level", default="INFO", help="Logging level")
    
    args = parser.parse_args()
    
    # Set up logging
    setup_logger(log_level=args.log_level)
    logger = get_logger()
    
    # Load configurations
    config_dir = Path(args.config_dir)
    
    try:
        crawler_settings = load_config(config_dir / "crawler_settings.json")
        api_config = load_config(config_dir / "api_config.json")
    except Exception as e:
        logger.error(f"Configuration loading failed: {e}")
        sys.exit(1)
    
    # Initialize file manager
    file_manager = FileManager(crawler_settings)
    
    # Check status mode
    if args.check_status:
        logger.info(f"Checking status for batch: {args.check_status}")
        status_data = check_upload_status(args.check_status, api_config)
        
        if status_data:
            logger.info("Upload Status:")
            logger.info(f"  Batch ID: {status_data.get('batch_id', 'Unknown')}")
            logger.info(f"  Overall Status: {status_data.get('overall_status', 'Unknown')}")
            logger.info(f"  Total Items: {status_data.get('total_items', 0)}")
            logger.info(f"  Completed: {status_data.get('completed', 0)}")
            logger.info(f"  Processing: {status_data.get('processing', 0)}")
            logger.info(f"  Failed: {status_data.get('failed', 0)}")
            
            if status_data.get('items'):
                logger.info("\nItem Details:")
                for item in status_data['items'][:5]:  # Show first 5 items
                    logger.info(f"  - {item.get('content_id', 'Unknown')}: {item.get('status', 'Unknown')}")
        
        sys.exit(0)
    
    # Determine what to upload
    items_to_upload = []
    
    if args.file:
        # Upload specific file
        file_path = Path(args.file)
        if not file_path.exists():
            logger.error(f"File not found: {file_path}")
            sys.exit(1)
        
        items_to_upload = load_processed_data(str(file_path))
        logger.info(f"Loading data from: {file_path}")
        
    elif args.source:
        # Upload latest data for specific source
        latest_file = file_manager.get_latest_file(args.source, "processed")
        if not latest_file:
            logger.error(f"No processed data found for source: {args.source}")
            sys.exit(1)
        
        data = file_manager.load_processed_content(latest_file)
        if data and "items" in data:
            items_to_upload = data["items"]
        
        logger.info(f"Loading latest data for source {args.source}: {latest_file}")
        
    elif args.all:
        # Upload all available processed data
        processed_dir = Path(crawler_settings["output"]["processed_data_dir"])
        
        if not processed_dir.exists():
            logger.error(f"Processed data directory not found: {processed_dir}")
            sys.exit(1)
        
        # Find all processed files
        for source_dir in processed_dir.iterdir():
            if source_dir.is_dir():
                source_files = file_manager.list_source_files(source_dir.name, "processed")
                
                for file_path in source_files:
                    data = file_manager.load_processed_content(file_path)
                    if data and "items" in data:
                        items_to_upload.extend(data["items"])
                        logger.info(f"Added {len(data['items'])} items from {file_path}")
        
        logger.info(f"Loading all processed data: {len(items_to_upload)} total items")
        
    else:
        logger.error("Must specify --file, --source, or --all")
        parser.print_help()
        sys.exit(1)
    
    if not items_to_upload:
        logger.warning("No items to upload")
        sys.exit(0)
    
    # Validate items
    valid_items = validate_items(items_to_upload)
    
    if not valid_items:
        logger.error("No valid items to upload")
        sys.exit(1)
    
    # Dry run mode
    if args.dry_run:
        logger.info("DRY RUN MODE - Data validation completed")
        logger.info(f"Would upload {len(valid_items)} valid items")
        
        # Show sample items
        logger.info("\nSample items:")
        for i, item in enumerate(valid_items[:3]):
            logger.info(f"  {i+1}. {item.get('title', 'No title')[:50]}...")
            logger.info(f"     Source: {item.get('source_id', 'Unknown')}")
            logger.info(f"     Content length: {len(item.get('content', ''))} chars")
        
        if len(valid_items) > 3:
            logger.info(f"     ... and {len(valid_items) - 3} more items")
        
        sys.exit(0)
    
    # Upload items
    logger.info(f"Uploading {len(valid_items)} valid items")
    
    upload_result = upload_items(valid_items, api_config, args.batch_id)
    
    # Save upload results
    if upload_result.get("upload_results"):
        batch_id = upload_result["batch_id"]
        upload_file = file_manager.save_upload_batch(batch_id, upload_result["upload_results"])
        logger.info(f"Upload results saved to: {upload_file}")
    
    # Print summary
    logger.info("=" * 50)
    logger.info("UPLOAD SUMMARY")
    logger.info("=" * 50)
    
    if upload_result["success"]:
        upload_stats = upload_result.get("upload_stats", {})
        upload_results = upload_result.get("upload_results", {})
        
        logger.info(f"Batch ID: {upload_result['batch_id']}")
        logger.info(f"Total items: {upload_stats.get('total_items', 0)}")
        logger.info(f"Successful uploads: {upload_stats.get('successful_items', 0)}")
        logger.info(f"Failed uploads: {upload_stats.get('total_items', 0) - upload_stats.get('successful_items', 0)}")
        logger.info(f"Success rate: {upload_stats.get('item_success_rate', 0):.1%}")
        
        if upload_results.get("chunks"):
            logger.info(f"Upload chunks: {len(upload_results['chunks'])}")
            
            # Show chunk details
            for i, chunk in enumerate(upload_results["chunks"][:3]):
                status = "✓" if chunk["success"] else "✗"
                logger.info(f"  {status} Chunk {i+1}: {chunk['items_count']} items")
        
        logger.info("Upload completed successfully!")
        
    else:
        logger.error(f"Upload failed: {upload_result.get('error', 'Unknown error')}")
        sys.exit(1)
    
    logger.info("=" * 50)


if __name__ == "__main__":
    main()
