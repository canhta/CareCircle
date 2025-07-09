#!/usr/bin/env python3
"""
Generate Vector Embeddings for Vietnamese Healthcare Data.

This script demonstrates how to use the crawler to extract data,
process it, and generate vector embeddings for storage in Milvus.
"""

import argparse
import json
import logging
import os
import sys
import yaml
from datetime import datetime
from pathlib import Path
from typing import Dict, List, Any

# Set up logging
from loguru import logger

# Import components
from extractors.government.moh_extractor import MohExtractor
from data_processing.vietnamese_nlp import VietnameseTextProcessor
from data_processing.text_chunking import TextChunker
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
    log_file = LOG_DIR / f"embeddings_{datetime.now().strftime('%Y%m%d_%H%M%S')}.log"
    
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


def load_crawled_data(file_path: str) -> List[Dict[str, Any]]:
    """
    Load previously crawled data from JSON file.
    
    Args:
        file_path: Path to the JSON file
        
    Returns:
        List of crawled data items
    """
    try:
        with open(file_path, "r", encoding="utf-8") as f:
            data = json.load(f)
        
        logger.info(f"Loaded {len(data)} items from {file_path}")
        return data
    except Exception as e:
        logger.error(f"Error loading data from {file_path}: {str(e)}")
        return []


def process_and_generate_embeddings(
    crawled_data: List[Dict[str, Any]],
    config: Dict[str, Any],
    domain: str,
    chunk_size: int = 512,
) -> None:
    """
    Process crawled data and generate vector embeddings.
    
    Args:
        crawled_data: List of crawled data items
        config: Configuration dictionary
        domain: Healthcare domain name
        chunk_size: Size of text chunks for embedding
    """
    # Initialize processors
    text_processor = VietnameseTextProcessor(config)
    text_chunker = TextChunker(chunk_size=chunk_size, chunk_overlap=50)
    
    # Initialize vector database manager
    vector_db = create_vector_db_manager(config)
    
    # Process each item
    all_chunks = []
    
    for item in crawled_data:
        logger.info(f"Processing item: {item.get('title', 'Untitled')}")
        
        # Extract content
        if "content" not in item:
            logger.warning(f"Item missing content field: {item.get('title', 'Untitled')}")
            continue
        
        # Process text
        processed = text_processor.process_text(item["content"])
        
        # Create document with processed text
        document = {
            "content": processed["cleaned_text"],
            "title": item.get("title", ""),
            "url": item.get("url", ""),
            "source_id": item.get("source_id", ""),
            "crawl_timestamp": item.get("crawl_timestamp", ""),
            "categories": item.get("categories", []),
            "medical_terms": processed["medical_terms"],
            "named_entities": processed["named_entities"],
        }
        
        # Chunk document
        chunks = text_chunker.chunk_document(document)
        all_chunks.extend(chunks)
        
        logger.info(f"Generated {len(chunks)} chunks for item: {item.get('title', 'Untitled')}")
    
    logger.info(f"Total chunks generated: {len(all_chunks)}")
    
    # Insert chunks into vector database
    if all_chunks:
        try:
            # Prepare data for insertion
            texts = [chunk["text"] for chunk in all_chunks]
            text_ids = [f"{i}" for i in range(len(all_chunks))]
            sources = [chunk.get("source", "") for chunk in all_chunks]
            categories = [",".join(chunk.get("categories", [])) for chunk in all_chunks]
            crawl_dates = [chunk.get("crawl_timestamp", "") for chunk in all_chunks]
            
            # Insert data
            vector_db.insert_data(
                domain=domain,
                texts=texts,
                text_ids=text_ids,
                sources=sources,
                categories=categories,
                crawl_dates=crawl_dates,
            )
            
            logger.info(f"Inserted {len(all_chunks)} chunks into vector database")
            
            # Test search
            if texts:
                logger.info("Testing search functionality...")
                sample_query = texts[0][:100]  # Use first 100 chars of first chunk as query
                results = vector_db.search(domain=domain, query_text=sample_query, limit=5)
                logger.info(f"Search returned {len(results)} results")
                
        except Exception as e:
            logger.error(f"Error inserting data into vector database: {str(e)}")
    else:
        logger.warning("No chunks generated, skipping vector database insertion")


def main() -> None:
    """Main entry point for the script."""
    # Parse command line arguments
    parser = argparse.ArgumentParser(description="Generate Vector Embeddings for Vietnamese Healthcare Data")
    parser.add_argument("--input", type=str, required=True, help="Path to crawled data JSON file")
    parser.add_argument("--domain", type=str, default="healthcare_system", help="Healthcare domain name")
    parser.add_argument("--chunk-size", type=int, default=512, help="Size of text chunks for embedding")
    parser.add_argument("--log-level", type=str, default="INFO", choices=["DEBUG", "INFO", "WARNING", "ERROR", "CRITICAL"], help="Log level")
    args = parser.parse_args()
    
    # Set up logging
    setup_logging(args.log_level)
    
    logger.info("Starting Vector Embedding Generation")
    
    try:
        # Load base configuration
        base_config = load_config()
        
        # Load crawled data
        crawled_data = load_crawled_data(args.input)
        
        if not crawled_data:
            logger.error("No data to process")
            sys.exit(1)
        
        # Process data and generate embeddings
        process_and_generate_embeddings(
            crawled_data=crawled_data,
            config=base_config,
            domain=args.domain,
            chunk_size=args.chunk_size,
        )
        
        logger.info("Vector embedding generation completed successfully")
        
    except Exception as e:
        logger.exception(f"Error during embedding generation: {str(e)}")
        sys.exit(1)


if __name__ == "__main__":
    main() 