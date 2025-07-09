#!/usr/bin/env python3
"""
Search Vector Database for Vietnamese Healthcare Data.

This script demonstrates how to search the vector database
for Vietnamese healthcare information using semantic search.
"""

import argparse
import json
import logging
import os
import sys
import yaml
from datetime import datetime
from pathlib import Path
from typing import Dict, List, Any, Optional

# Set up logging
from loguru import logger

# Import components
from storage.vector_db import create_vector_db_manager

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
    log_file = LOG_DIR / f"search_{datetime.now().strftime('%Y%m%d_%H%M%S')}.log"
    
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


def search_vector_database(
    query: str,
    domain: str,
    config: Dict[str, Any],
    limit: int = 10,
    filter_expr: Optional[str] = None,
) -> List[Dict[str, Any]]:
    """
    Search the vector database for similar content.
    
    Args:
        query: Query text to search for
        domain: Healthcare domain name
        config: Configuration dictionary
        limit: Maximum number of results to return
        filter_expr: Optional filter expression
        
    Returns:
        List of search results
    """
    # Initialize vector database manager
    vector_db = create_vector_db_manager(config)
    
    # List available collections
    collections = vector_db.list_collections()
    logger.info(f"Available collections: {collections}")
    
    # Check if domain collection exists
    collection_name = f"{vector_db.collection_prefix}{domain}"
    if collection_name not in collections:
        logger.warning(f"Collection {collection_name} does not exist")
        return []
    
    # Get collection stats
    stats = vector_db.get_collection_stats(domain)
    logger.info(f"Collection stats: {stats}")
    
    # Search
    results = vector_db.search(
        domain=domain,
        query_text=query,
        limit=limit,
        filter_expr=filter_expr,
    )
    
    logger.info(f"Search returned {len(results)} results")
    
    return results


def format_results(results: List[Dict[str, Any]]) -> None:
    """
    Format and print search results.
    
    Args:
        results: List of search results
    """
    if not results:
        print("No results found.")
        return
    
    print(f"\nFound {len(results)} results:\n")
    
    for i, result in enumerate(results):
        print(f"Result {i+1} (Score: {result['score']:.4f}):")
        print(f"  Source: {result.get('source', 'Unknown')}")
        print(f"  Category: {result.get('category', 'Unknown')}")
        
        # Format text (truncate if too long)
        text = result.get('text', '')
        if len(text) > 200:
            text = text[:197] + "..."
        
        print(f"  Text: {text}")
        print()


def save_results(results: List[Dict[str, Any]], output_file: str) -> None:
    """
    Save search results to a JSON file.
    
    Args:
        results: List of search results
        output_file: Path to save results to
    """
    try:
        with open(output_file, "w", encoding="utf-8") as f:
            json.dump(results, f, ensure_ascii=False, indent=2)
        
        logger.info(f"Saved {len(results)} results to {output_file}")
    except Exception as e:
        logger.error(f"Error saving results to {output_file}: {str(e)}")


def main() -> None:
    """Main entry point for the script."""
    # Parse command line arguments
    parser = argparse.ArgumentParser(description="Search Vector Database for Vietnamese Healthcare Data")
    parser.add_argument("--query", type=str, required=True, help="Query text to search for")
    parser.add_argument("--domain", type=str, default="healthcare_system", help="Healthcare domain name")
    parser.add_argument("--limit", type=int, default=10, help="Maximum number of results to return")
    parser.add_argument("--filter", type=str, help="Optional filter expression")
    parser.add_argument("--output", type=str, help="Path to save results to")
    parser.add_argument("--log-level", type=str, default="INFO", choices=["DEBUG", "INFO", "WARNING", "ERROR", "CRITICAL"], help="Log level")
    args = parser.parse_args()
    
    # Set up logging
    setup_logging(args.log_level)
    
    logger.info("Starting Vector Database Search")
    
    try:
        # Load base configuration
        base_config = load_config()
        
        # Search vector database
        results = search_vector_database(
            query=args.query,
            domain=args.domain,
            config=base_config,
            limit=args.limit,
            filter_expr=args.filter,
        )
        
        # Format and print results
        format_results(results)
        
        # Save results if output file specified
        if args.output:
            save_results(results, args.output)
        
        logger.info("Search completed successfully")
        
    except Exception as e:
        logger.exception(f"Error during search: {str(e)}")
        sys.exit(1)


if __name__ == "__main__":
    main() 