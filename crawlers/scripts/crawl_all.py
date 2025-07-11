#!/usr/bin/env python3
"""
Main script to run all configured crawlers.
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
from core.content_processor import ContentProcessor
from core.advanced_processor import AdvancedContentProcessor
from core.api_client import APIClient
from utils.file_manager import FileManager
from extractors.ministry_health import MinistryHealthExtractor
from extractors.health_news import HealthNewsExtractor
from extractors.hospital_sites import HospitalSiteExtractor
from extractors.vinmec_hospital import VinmecExtractor

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


def get_extractor_class(source_id: str, source_type: str):
    """Get the appropriate extractor class for source type."""
    # Specific extractors for known sources
    if source_id == "vinmec-hospital":
        return VinmecExtractor

    # General extractors by type
    extractors = {
        "government": MinistryHealthExtractor,
        "news": HealthNewsExtractor,
        "hospital": HospitalSiteExtractor,
        "medical_institution": HospitalSiteExtractor
    }

    return extractors.get(source_type, HealthNewsExtractor)


def run_crawler(source_config: Dict[str, Any], settings: Dict[str, Any]) -> Dict[str, Any]:
    """
    Run crawler for a single source.
    
    Args:
        source_config: Source configuration
        settings: Global crawler settings
        
    Returns:
        Crawling results
    """
    logger = get_logger()
    source_id = source_config["id"]
    source_name = source_config["name"]
    
    logger.info(f"Starting crawler for {source_name} (ID: {source_id})")
    
    try:
        # Get appropriate extractor
        extractor_class = get_extractor_class(source_config["id"], source_config["type"])
        crawler = extractor_class(source_config, settings)
        
        # Run crawling
        start_time = datetime.now(timezone.utc)
        raw_items = crawler.crawl()
        end_time = datetime.now(timezone.utc)
        
        # Get crawling statistics
        stats = crawler.get_stats()
        stats["start_time"] = start_time.isoformat()
        stats["end_time"] = end_time.isoformat()
        stats["duration_seconds"] = (end_time - start_time).total_seconds()
        
        logger.info(
            f"Crawler completed for {source_name}: "
            f"{stats['pages_crawled']} pages, {stats['items_extracted']} items, "
            f"{stats['errors']} errors in {stats['duration_seconds']:.1f}s"
        )
        
        return {
            "source_id": source_id,
            "source_name": source_name,
            "success": True,
            "raw_items": raw_items,
            "stats": stats
        }
        
    except Exception as e:
        logger.error(f"Crawler failed for {source_name}: {e}")
        return {
            "source_id": source_id,
            "source_name": source_name,
            "success": False,
            "error": str(e),
            "raw_items": [],
            "stats": {"errors": 1}
        }


def process_content(raw_items: List[Dict[str, Any]], settings: Dict[str, Any]) -> List[Dict[str, Any]]:
    """Process raw content items with advanced processing."""
    logger = get_logger()

    if not raw_items:
        return []

    logger.info(f"Processing {len(raw_items)} raw items with advanced processing")

    # Use advanced processor if enabled
    if settings.get("advanced_processing", {}).get("enable_metadata_enrichment", False):
        processor = AdvancedContentProcessor(settings)
        processed_items = processor.process_batch_advanced(raw_items)
    else:
        processor = ContentProcessor(settings)
        processed_items = processor.process_batch(raw_items)
    
    processing_stats = processor.get_processing_stats()
    logger.info(
        f"Content processing completed: {processing_stats['processed']} processed, "
        f"{processing_stats['rejected']} rejected, {processing_stats['duplicates']} duplicates"
    )
    
    return processed_items


def upload_content(processed_items: List[Dict[str, Any]], api_config: Dict[str, Any]) -> Dict[str, Any]:
    """Upload processed content to backend."""
    logger = get_logger()
    
    if not processed_items:
        return {"success": True, "message": "No items to upload"}
    
    logger.info(f"Uploading {len(processed_items)} processed items")
    
    try:
        api_client = APIClient(api_config)
        
        # Generate batch ID
        timestamp = datetime.now(timezone.utc).strftime("%Y%m%d_%H%M%S")
        batch_id = f"crawl_all_{timestamp}"
        
        # Upload batch
        success, upload_results = api_client.upload_batch(processed_items, batch_id)
        
        upload_stats = api_client.get_upload_stats()
        logger.info(
            f"Upload completed: {upload_stats['successful_items']} successful, "
            f"{upload_stats['total_items'] - upload_stats['successful_items']} failed"
        )
        
        return {
            "success": success,
            "upload_results": upload_results,
            "upload_stats": upload_stats
        }
        
    except Exception as e:
        logger.error(f"Upload failed: {e}")
        return {
            "success": False,
            "error": str(e)
        }


def main():
    """Main execution function."""
    parser = argparse.ArgumentParser(description="Run all configured crawlers")
    parser.add_argument("--config-dir", default="./config", help="Configuration directory")
    parser.add_argument("--sources", nargs="+", help="Specific sources to crawl (default: all enabled)")
    parser.add_argument("--no-upload", action="store_true", help="Skip uploading to backend")
    parser.add_argument("--dry-run", action="store_true", help="Run without saving or uploading")
    parser.add_argument("--log-level", default="INFO", help="Logging level")
    
    args = parser.parse_args()
    
    # Set up logging
    setup_logger(log_level=args.log_level)
    logger = get_logger()
    
    logger.info("Starting CareCircle crawler system")
    
    # Load configurations
    config_dir = Path(args.config_dir)
    
    try:
        sources_config = load_config(config_dir / "sources.json")
        crawler_settings = load_config(config_dir / "crawler_settings.json")
        api_config = load_config(config_dir / "api_config.json")
    except Exception as e:
        logger.error(f"Configuration loading failed: {e}")
        sys.exit(1)
    
    # Initialize file manager
    file_manager = FileManager(crawler_settings)
    
    # Filter sources to crawl
    sources_to_crawl = sources_config["sources"]
    
    if args.sources:
        sources_to_crawl = [s for s in sources_to_crawl if s["id"] in args.sources]
    else:
        sources_to_crawl = [s for s in sources_to_crawl if s.get("enabled", True)]
    
    if not sources_to_crawl:
        logger.warning("No sources to crawl")
        sys.exit(0)
    
    logger.info(f"Crawling {len(sources_to_crawl)} sources: {[s['id'] for s in sources_to_crawl]}")
    
    # Run crawlers
    all_results = []
    total_raw_items = []
    
    for source_config in sources_to_crawl:
        result = run_crawler(source_config, crawler_settings)
        all_results.append(result)
        
        if result["success"] and result["raw_items"]:
            total_raw_items.extend(result["raw_items"])
            
            # Save raw content
            if not args.dry_run:
                file_manager.save_raw_content(result["source_id"], result["raw_items"])
    
    # Process content
    logger.info(f"Processing {len(total_raw_items)} total raw items")
    processed_items = process_content(total_raw_items, crawler_settings)
    
    # Save processed content
    if processed_items and not args.dry_run:
        timestamp = datetime.now(timezone.utc).strftime("%Y%m%d_%H%M%S")
        file_manager.save_processed_content(f"all_sources_{timestamp}", processed_items)
    
    # Upload content
    upload_result = {"success": True, "message": "Upload skipped"}
    
    if processed_items and not args.no_upload and not args.dry_run:
        upload_result = upload_content(processed_items, api_config)
        
        # Save upload results
        if upload_result.get("upload_results"):
            batch_id = upload_result["upload_results"]["batch_id"]
            file_manager.save_upload_batch(batch_id, upload_result["upload_results"])
    
    # Generate summary report
    total_pages = sum(r["stats"].get("pages_crawled", 0) for r in all_results if r["success"])
    total_items = sum(r["stats"].get("items_extracted", 0) for r in all_results if r["success"])
    total_errors = sum(r["stats"].get("errors", 0) for r in all_results)
    successful_sources = sum(1 for r in all_results if r["success"])
    
    logger.info("=" * 60)
    logger.info("CRAWLING SUMMARY")
    logger.info("=" * 60)
    logger.info(f"Sources crawled: {successful_sources}/{len(sources_to_crawl)}")
    logger.info(f"Total pages crawled: {total_pages}")
    logger.info(f"Total items extracted: {total_items}")
    logger.info(f"Total items processed: {len(processed_items)}")
    logger.info(f"Total errors: {total_errors}")
    
    if upload_result["success"] and upload_result.get("upload_stats"):
        upload_stats = upload_result["upload_stats"]
        logger.info(f"Items uploaded: {upload_stats['successful_items']}")
        logger.info(f"Upload success rate: {upload_stats['item_success_rate']:.1%}")
    
    logger.info("=" * 60)
    
    # Print individual source results
    for result in all_results:
        status = "✓" if result["success"] else "✗"
        if result["success"]:
            stats = result["stats"]
            logger.info(
                f"{status} {result['source_name']}: "
                f"{stats.get('pages_crawled', 0)} pages, "
                f"{stats.get('items_extracted', 0)} items"
            )
        else:
            logger.error(f"{status} {result['source_name']}: {result.get('error', 'Unknown error')}")
    
    # Exit with appropriate code
    if all(r["success"] for r in all_results) and upload_result["success"]:
        logger.info("All crawlers completed successfully")
        sys.exit(0)
    else:
        logger.error("Some crawlers failed")
        sys.exit(1)


if __name__ == "__main__":
    main()
