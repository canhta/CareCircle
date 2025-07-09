#!/usr/bin/env python3
"""
End-to-End Demo for Vietnamese Healthcare Data Crawler.

This script demonstrates the complete workflow:
1. Crawl data from Vietnamese healthcare websites
2. Process the text with Vietnamese-specific NLP tools
3. Generate embeddings for the processed text
4. Store the embeddings in Milvus vector database
5. Perform semantic search queries
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
    log_file = LOG_DIR / f"end_to_end_{datetime.now().strftime('%Y%m%d_%H%M%S')}.log"
    
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


def crawl_data(source_id: str, config: Dict[str, Any], max_pages: int = 10) -> List[Dict[str, Any]]:
    """
    Crawl data from a Vietnamese healthcare website.
    
    Args:
        source_id: ID of the source to crawl
        config: Configuration dictionary
        max_pages: Maximum number of pages to crawl
        
    Returns:
        List of crawled data items
    """
    logger.info(f"Starting crawl for source: {source_id}")
    
    # Initialize appropriate extractor based on source
    if source_id == "moh":
        extractor = MohExtractor(config)
        logger.info("Initialized Ministry of Health extractor")
    else:
        logger.error(f"Unsupported source: {source_id}")
        return []
    
    # Start crawling
    results = extractor.crawl(max_pages=max_pages)
    
    # Log statistics
    logger.info(f"Crawl completed with statistics: {extractor.stats}")
    
    return results


def process_data(crawled_data: List[Dict[str, Any]], config: Dict[str, Any]) -> List[Dict[str, Any]]:
    """
    Process crawled data with Vietnamese-specific NLP tools.
    
    Args:
        crawled_data: List of crawled data items
        config: Configuration dictionary
        
    Returns:
        List of processed data items
    """
    logger.info(f"Processing {len(crawled_data)} crawled items")
    
    # Initialize text processor
    text_processor = VietnameseTextProcessor(config)
    
    processed_data = []
    
    for item in crawled_data:
        logger.info(f"Processing item: {item.get('title', 'Untitled')}")
        
        # Extract content
        if "content" not in item:
            logger.warning(f"Item missing content field: {item.get('title', 'Untitled')}")
            continue
        
        # Process text
        processed = text_processor.process_text(item["content"])
        
        # Create processed document
        processed_item = {
            **item,
            "content": processed["cleaned_text"],
            "medical_terms": processed["medical_terms"],
            "named_entities": processed["named_entities"],
        }
        
        processed_data.append(processed_item)
    
    logger.info(f"Processed {len(processed_data)} items")
    
    return processed_data


def chunk_data(processed_data: List[Dict[str, Any]], chunk_size: int = 512) -> List[Dict[str, Any]]:
    """
    Chunk processed data for vector database storage.
    
    Args:
        processed_data: List of processed data items
        chunk_size: Size of text chunks for embedding
        
    Returns:
        List of chunked data items
    """
    logger.info(f"Chunking {len(processed_data)} processed items")
    
    # Initialize text chunker
    text_chunker = TextChunker(chunk_size=chunk_size, chunk_overlap=50)
    
    all_chunks = []
    
    for item in processed_data:
        logger.info(f"Chunking item: {item.get('title', 'Untitled')}")
        
        # Create document with processed text
        document = {
            "content": item["content"],
            "title": item.get("title", ""),
            "url": item.get("url", ""),
            "source_id": item.get("source_id", ""),
            "crawl_timestamp": item.get("crawl_timestamp", ""),
            "categories": item.get("categories", []),
            "medical_terms": item.get("medical_terms", []),
            "named_entities": item.get("named_entities", []),
        }
        
        # Chunk document
        chunks = text_chunker.chunk_document(document)
        all_chunks.extend(chunks)
        
        logger.info(f"Generated {len(chunks)} chunks for item: {item.get('title', 'Untitled')}")
    
    logger.info(f"Total chunks generated: {len(all_chunks)}")
    
    return all_chunks


def generate_embeddings_and_store(
    chunks: List[Dict[str, Any]],
    config: Dict[str, Any],
    domain: str,
) -> None:
    """
    Generate embeddings for chunked data and store in vector database.
    
    Args:
        chunks: List of chunked data items
        config: Configuration dictionary
        domain: Healthcare domain name
    """
    logger.info(f"Generating embeddings for {len(chunks)} chunks")
    
    # Initialize vector database manager
    vector_db = create_vector_db_manager(config)
    
    if chunks:
        try:
            # Prepare data for insertion
            texts = [chunk["text"] for chunk in chunks]
            text_ids = [f"{i}" for i in range(len(chunks))]
            sources = [chunk.get("source", "") for chunk in chunks]
            categories = [",".join(chunk.get("categories", [])) for chunk in chunks]
            crawl_dates = [chunk.get("crawl_timestamp", "") for chunk in chunks]
            
            # Insert data
            vector_db.insert_data(
                domain=domain,
                texts=texts,
                text_ids=text_ids,
                sources=sources,
                categories=categories,
                crawl_dates=crawl_dates,
            )
            
            logger.info(f"Successfully inserted {len(chunks)} chunks into vector database")
        except Exception as e:
            logger.error(f"Error inserting data into vector database: {str(e)}")
    else:
        logger.warning("No chunks to insert into vector database")


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
    logger.info(f"Searching for: '{query}' in domain '{domain}'")
    
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


def save_results(
    data: Any,
    file_name: str,
    data_type: str = "results",
) -> None:
    """
    Save data to a JSON file.
    
    Args:
        data: Data to save
        file_name: File name to save to
        data_type: Type of data being saved
    """
    output_path = EXPORT_DIR / file_name
    
    try:
        with open(output_path, "w", encoding="utf-8") as f:
            json.dump(data, f, ensure_ascii=False, indent=2)
        
        logger.info(f"Saved {data_type} to {output_path}")
    except Exception as e:
        logger.error(f"Error saving {data_type} to {output_path}: {str(e)}")


def main() -> None:
    """Main entry point for the script."""
    # Parse command line arguments
    parser = argparse.ArgumentParser(description="End-to-End Demo for Vietnamese Healthcare Data Crawler")
    parser.add_argument("--source", type=str, default="moh", help="Source ID to crawl")
    parser.add_argument("--domain", type=str, default="healthcare_system", help="Healthcare domain name")
    parser.add_argument("--max-pages", type=int, default=5, help="Maximum number of pages to crawl")
    parser.add_argument("--chunk-size", type=int, default=512, help="Size of text chunks for embedding")
    parser.add_argument("--query", type=str, help="Query text to search for (if not provided, only crawl and process)")
    parser.add_argument("--limit", type=int, default=10, help="Maximum number of search results to return")
    parser.add_argument("--skip-crawl", action="store_true", help="Skip crawling and use existing data")
    parser.add_argument("--input-file", type=str, help="Input file with existing crawled data (used with --skip-crawl)")
    parser.add_argument("--log-level", type=str, default="INFO", choices=["DEBUG", "INFO", "WARNING", "ERROR", "CRITICAL"], help="Log level")
    args = parser.parse_args()
    
    # Set up logging
    setup_logging(args.log_level)
    
    logger.info("Starting End-to-End Demo for Vietnamese Healthcare Data Crawler")
    
    try:
        # Load base configuration
        base_config = load_config()
        
        # Load source-specific configuration
        source_config = load_source_config(args.source)
        
        # Merge configurations (source config takes precedence)
        config = {**base_config, **source_config}
        
        # Step 1: Crawl data
        if args.skip_crawl:
            if not args.input_file:
                logger.error("--input-file is required when using --skip-crawl")
                sys.exit(1)
            
            logger.info(f"Skipping crawl, loading data from {args.input_file}")
            crawled_data = []
            try:
                with open(args.input_file, "r", encoding="utf-8") as f:
                    crawled_data = json.load(f)
                logger.info(f"Loaded {len(crawled_data)} items from {args.input_file}")
            except Exception as e:
                logger.error(f"Error loading data from {args.input_file}: {str(e)}")
                sys.exit(1)
        else:
            logger.info(f"Crawling data from {args.source}")
            crawled_data = crawl_data(args.source, config, args.max_pages)
            
            # Save crawled data
            timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
            save_results(
                crawled_data,
                f"{args.source}_crawled_{timestamp}.json",
                "crawled data"
            )
        
        # Step 2: Process data
        processed_data = process_data(crawled_data, config)
        
        # Save processed data
        timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
        save_results(
            processed_data,
            f"{args.source}_processed_{timestamp}.json",
            "processed data"
        )
        
        # Step 3: Chunk data
        chunks = chunk_data(processed_data, args.chunk_size)
        
        # Save chunked data
        timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
        save_results(
            chunks,
            f"{args.source}_chunks_{timestamp}.json",
            "chunked data"
        )
        
        # Step 4: Generate embeddings and store in vector database
        generate_embeddings_and_store(chunks, config, args.domain)
        
        # Step 5: Search vector database (if query provided)
        if args.query:
            logger.info(f"Searching for: '{args.query}'")
            results = search_vector_database(
                query=args.query,
                domain=args.domain,
                config=config,
                limit=args.limit,
            )
            
            # Format and print results
            format_results(results)
            
            # Save search results
            timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
            save_results(
                results,
                f"search_results_{timestamp}.json",
                "search results"
            )
        
        logger.info("End-to-End Demo completed successfully")
        
    except Exception as e:
        logger.exception(f"Error during End-to-End Demo: {str(e)}")
        sys.exit(1)


if __name__ == "__main__":
    main() 