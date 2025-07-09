#!/usr/bin/env python3
"""
CareCircle Vietnamese Healthcare Data Crawler - Main Entry Point

This script serves as the main entry point for the crawler module.
It loads configuration, sets up logging, initializes extractors,
and manages the crawling process.
"""

import argparse
import logging
import os
import sys
import yaml
from datetime import datetime
from pathlib import Path
from typing import Dict, List, Any

# Set up logging
from loguru import logger

# Import extractors
from extractors.government.moh_extractor import MohExtractor

# Set up paths
BASE_DIR = Path(__file__).resolve().parent.parent
CONFIG_DIR = BASE_DIR / "config"
EXPORT_DIR = BASE_DIR / "exports"
LOG_DIR = BASE_DIR / "logs"

# Ensure directories exist
EXPORT_DIR.mkdir(exist_ok=True)
LOG_DIR.mkdir(exist_ok=True)


def setup_logging(log_level: str = "INFO") -> None:
    """
    Set up logging configuration.
    
    Args:
        log_level: Log level (DEBUG, INFO, WARNING, ERROR, CRITICAL)
    """
    log_file = LOG_DIR / f"crawler_{datetime.now().strftime('%Y%m%d_%H%M%S')}.log"
    
    # Remove default logger
    logger.remove()
    
    # Add console logger
    logger.add(sys.stderr, level=log_level)
    
    # Add file logger
    logger.add(log_file, level=log_level, rotation="100 MB", retention="1 week")
    
    logger.info(f"Logging initialized at level {log_level}")
    logger.info(f"Log file: {log_file}")


def load_config(config_name: str = "base_config.yaml") -> Dict[str, Any]:
    """
    Load configuration from YAML file.
    
    Args:
        config_name: Name of the configuration file
        
    Returns:
        Dictionary containing configuration
    """
    config_path = CONFIG_DIR / config_name
    
    if not config_path.exists():
        logger.error(f"Configuration file not found: {config_path}")
        sys.exit(1)
    
    with open(config_path, "r", encoding="utf-8") as f:
        config = yaml.safe_load(f)
    
    logger.info(f"Loaded configuration from {config_path}")
    
    return config


def load_source_config(source_id: str) -> Dict[str, Any]:
    """
    Load source-specific configuration.
    
    Args:
        source_id: ID of the source to load configuration for
        
    Returns:
        Dictionary containing source configuration
    """
    source_config_path = CONFIG_DIR / "sources" / f"{source_id}.yaml"
    
    if not source_config_path.exists():
        logger.error(f"Source configuration file not found: {source_config_path}")
        sys.exit(1)
    
    with open(source_config_path, "r", encoding="utf-8") as f:
        source_config = yaml.safe_load(f)
    
    logger.info(f"Loaded source configuration from {source_config_path}")
    
    return source_config


def save_results(results: List[Dict[str, Any]], source_id: str) -> None:
    """
    Save crawl results to file.
    
    Args:
        results: List of extracted data items
        source_id: ID of the source
    """
    import json
    
    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    output_file = EXPORT_DIR / f"{source_id}_{timestamp}.json"
    
    with open(output_file, "w", encoding="utf-8") as f:
        json.dump(results, f, ensure_ascii=False, indent=2)
    
    logger.info(f"Saved {len(results)} items to {output_file}")


def main() -> None:
    """Main entry point for the crawler."""
    # Parse command line arguments
    parser = argparse.ArgumentParser(description="CareCircle Vietnamese Healthcare Data Crawler")
    parser.add_argument("--source", type=str, default="moh", help="Source ID to crawl")
    parser.add_argument("--max-pages", type=int, help="Maximum number of pages to crawl")
    parser.add_argument("--log-level", type=str, default="INFO", choices=["DEBUG", "INFO", "WARNING", "ERROR", "CRITICAL"], help="Log level")
    args = parser.parse_args()
    
    # Set up logging
    setup_logging(args.log_level)
    
    logger.info("Starting CareCircle Vietnamese Healthcare Data Crawler")
    
    try:
        # Load base configuration
        base_config = load_config()
        
        # Load source-specific configuration
        source_config = load_source_config(args.source)
        
        # Merge configurations (source config takes precedence)
        config = {**base_config, **source_config}
        
        # Initialize appropriate extractor based on source
        if args.source == "moh":
            extractor = MohExtractor(config)
            logger.info("Initialized Ministry of Health extractor")
        else:
            logger.error(f"Unsupported source: {args.source}")
            sys.exit(1)
        
        # Start crawling
        logger.info(f"Starting crawl for source: {args.source}")
        results = extractor.crawl(max_pages=args.max_pages)
        
        # Save results
        save_results(results, args.source)
        
        # Log statistics
        logger.info(f"Crawl completed with statistics: {extractor.stats}")
        
    except Exception as e:
        logger.exception(f"Error during crawl: {str(e)}")
        sys.exit(1)


if __name__ == "__main__":
    main() 