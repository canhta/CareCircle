#!/usr/bin/env python3
"""
Script to run a specific source crawler.
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


def find_source_config(source_id: str, sources_config: Dict[str, Any]) -> Dict[str, Any]:
    """Find source configuration by ID."""
    for source in sources_config["sources"]:
        if source["id"] == source_id:
            return source
    
    raise ValueError(f"Source '{source_id}' not found in configuration")


def main():
    """Main execution function."""
    parser = argparse.ArgumentParser(description="Run a specific source crawler")
    parser.add_argument("source", help="Source ID to crawl")
    parser.add_argument("--config-dir", default="./config", help="Configuration directory")
    parser.add_argument("--limit", type=int, help="Limit number of pages to crawl")
    parser.add_argument("--no-upload", action="store_true", help="Skip uploading to backend")
    parser.add_argument("--no-process", action="store_true", help="Skip content processing")
    parser.add_argument("--dry-run", action="store_true", help="Run without saving or uploading")
    parser.add_argument("--log-level", default="INFO", help="Logging level")
    parser.add_argument("--output-dir", help="Custom output directory")
    
    args = parser.parse_args()
    
    # Set up logging
    setup_logger(log_level=args.log_level)
    logger = get_logger()
    
    logger.info(f"Starting crawler for source: {args.source}")
    
    # Load configurations
    config_dir = Path(args.config_dir)
    
    try:
        sources_config = load_config(config_dir / "sources.json")
        crawler_settings = load_config(config_dir / "crawler_settings.json")
        api_config = load_config(config_dir / "api_config.json")
    except Exception as e:
        logger.error(f"Configuration loading failed: {e}")
        sys.exit(1)
    
    # Find source configuration
    try:
        source_config = find_source_config(args.source, sources_config)
    except ValueError as e:
        logger.error(str(e))
        logger.info(f"Available sources: {[s['id'] for s in sources_config['sources']]}")
        sys.exit(1)
    
    # Apply limit if specified
    if args.limit:
        source_config = source_config.copy()
        source_config["max_pages"] = args.limit
        logger.info(f"Limited crawling to {args.limit} pages")
    
    # Override output directory if specified
    if args.output_dir:
        crawler_settings = crawler_settings.copy()
        output_dir = Path(args.output_dir)
        crawler_settings["output"]["raw_data_dir"] = str(output_dir / "raw")
        crawler_settings["output"]["processed_data_dir"] = str(output_dir / "processed")
        crawler_settings["output"]["logs_dir"] = str(output_dir / "logs")
        crawler_settings["output"]["uploads_dir"] = str(output_dir / "uploads")
    
    # Initialize file manager
    file_manager = FileManager(crawler_settings)
    
    # Check if source is enabled
    if not source_config.get("enabled", True):
        logger.warning(f"Source '{args.source}' is disabled in configuration")
        if not input("Continue anyway? (y/N): ").lower().startswith('y'):
            sys.exit(0)
    
    # Run crawler
    logger.info(f"Crawling {source_config['name']} ({source_config['type']})")
    
    try:
        # Get appropriate extractor
        extractor_class = get_extractor_class(source_config["id"], source_config["type"])
        crawler = extractor_class(source_config, crawler_settings)
        
        # Run crawling
        start_time = datetime.now(timezone.utc)
        raw_items = crawler.crawl()
        end_time = datetime.now(timezone.utc)
        
        # Get crawling statistics
        stats = crawler.get_stats()
        duration = (end_time - start_time).total_seconds()
        
        logger.info(
            f"Crawling completed: {stats['pages_crawled']} pages, "
            f"{stats['items_extracted']} items, {stats['errors']} errors "
            f"in {duration:.1f}s"
        )
        
        # Save raw content
        if raw_items and not args.dry_run:
            raw_file = file_manager.save_raw_content(args.source, raw_items)
            logger.info(f"Raw content saved to: {raw_file}")
        
        # Process content
        processed_items = []
        if raw_items and not args.no_process:
            logger.info(f"Processing {len(raw_items)} raw items")

            # Use advanced processor if enabled
            if crawler_settings.get("advanced_processing", {}).get("enable_metadata_enrichment", False):
                processor = AdvancedContentProcessor(crawler_settings)
                processed_items = processor.process_batch_advanced(raw_items)
            else:
                processor = ContentProcessor(crawler_settings)
                processed_items = processor.process_batch(raw_items)
            
            processing_stats = processor.get_processing_stats()
            logger.info(
                f"Processing completed: {processing_stats['processed']} processed, "
                f"{processing_stats['rejected']} rejected, "
                f"{processing_stats['duplicates']} duplicates"
            )
            
            # Save processed content
            if processed_items and not args.dry_run:
                processed_file = file_manager.save_processed_content(args.source, processed_items)
                logger.info(f"Processed content saved to: {processed_file}")
        
        # Upload content
        upload_result = {"success": True, "message": "Upload skipped"}
        
        if processed_items and not args.no_upload and not args.dry_run:
            logger.info(f"Uploading {len(processed_items)} processed items")
            
            try:
                api_client = APIClient(api_config)
                
                # Generate batch ID
                timestamp = datetime.now(timezone.utc).strftime("%Y%m%d_%H%M%S")
                batch_id = f"{args.source}_{timestamp}"
                
                # Upload batch
                success, upload_results = api_client.upload_batch(processed_items, batch_id)
                
                upload_stats = api_client.get_upload_stats()
                logger.info(
                    f"Upload completed: {upload_stats['successful_items']} successful, "
                    f"{upload_stats['total_items'] - upload_stats['successful_items']} failed"
                )
                
                # Save upload results
                if upload_results:
                    upload_file = file_manager.save_upload_batch(batch_id, upload_results)
                    logger.info(f"Upload results saved to: {upload_file}")
                
                upload_result = {
                    "success": success,
                    "upload_results": upload_results,
                    "upload_stats": upload_stats
                }
                
            except Exception as e:
                logger.error(f"Upload failed: {e}")
                upload_result = {"success": False, "error": str(e)}
        
        # Print summary
        logger.info("=" * 50)
        logger.info("CRAWLING SUMMARY")
        logger.info("=" * 50)
        logger.info(f"Source: {source_config['name']}")
        logger.info(f"Type: {source_config['type']}")
        logger.info(f"Pages crawled: {stats['pages_crawled']}")
        logger.info(f"Items extracted: {stats['items_extracted']}")
        logger.info(f"Items processed: {len(processed_items)}")
        logger.info(f"Errors: {stats['errors']}")
        logger.info(f"Duration: {duration:.1f}s")
        
        if upload_result["success"] and upload_result.get("upload_stats"):
            upload_stats = upload_result["upload_stats"]
            logger.info(f"Items uploaded: {upload_stats['successful_items']}")
            logger.info(f"Upload success rate: {upload_stats['item_success_rate']:.1%}")
        
        # Show errors if any
        if stats.get("error_details"):
            logger.info("\nErrors encountered:")
            for error in stats["error_details"][:5]:  # Show first 5 errors
                logger.error(f"- {error.get('url', 'Unknown URL')}: {error.get('error', 'Unknown error')}")
            
            if len(stats["error_details"]) > 5:
                logger.info(f"... and {len(stats['error_details']) - 5} more errors")
        
        logger.info("=" * 50)
        
        # Exit with appropriate code
        if stats['errors'] == 0 and upload_result["success"]:
            logger.info("Crawler completed successfully")
            sys.exit(0)
        elif stats['items_extracted'] > 0:
            logger.warning("Crawler completed with some errors")
            sys.exit(0)
        else:
            logger.error("Crawler failed to extract any content")
            sys.exit(1)
            
    except Exception as e:
        logger.error(f"Crawler failed: {e}")
        sys.exit(1)


if __name__ == "__main__":
    main()
