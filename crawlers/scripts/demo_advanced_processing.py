#!/usr/bin/env python3
"""
Demo script showcasing advanced processing pipeline and Vinmec integration.
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
from core.advanced_processor import AdvancedContentProcessor
from core.api_client import APIClient
from utils.file_manager import FileManager
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


def demo_vinmec_extraction(source_config: Dict[str, Any], settings: Dict[str, Any]) -> List[Dict[str, Any]]:
    """Demonstrate Vinmec content extraction."""
    logger = get_logger()
    
    logger.info("🏥 Demonstrating Vinmec Hospital content extraction")
    
    # Initialize Vinmec extractor
    vinmec_extractor = VinmecExtractor(source_config, settings)
    
    # Limit pages for demo
    source_config["max_pages"] = 5
    
    # Extract content
    raw_items = vinmec_extractor.crawl()
    
    logger.info(f"✅ Extracted {len(raw_items)} items from Vinmec")
    
    # Show sample extracted content
    if raw_items:
        sample_item = raw_items[0]
        logger.info("📄 Sample extracted content:")
        logger.info(f"   Title: {sample_item.get('title', 'No title')[:80]}...")
        logger.info(f"   Content Type: {sample_item.get('content_type', 'Unknown')}")
        logger.info(f"   Content Length: {len(sample_item.get('content', ''))} characters")
        
        metadata = sample_item.get('metadata', {})
        if metadata.get('vinmec_specialty'):
            logger.info(f"   Vinmec Specialty: {metadata['vinmec_specialty']}")
        if metadata.get('doctor_profile'):
            logger.info(f"   Doctor Profile: {metadata['doctor_profile'].get('name', 'Unknown')}")
        if metadata.get('service_info'):
            logger.info(f"   Service: {metadata['service_info'].get('service_name', 'Unknown')}")
    
    return raw_items


def demo_advanced_processing(raw_items: List[Dict[str, Any]], settings: Dict[str, Any]) -> List[Dict[str, Any]]:
    """Demonstrate advanced content processing pipeline."""
    logger = get_logger()
    
    if not raw_items:
        logger.warning("No raw items to process")
        return []
    
    logger.info("🧠 Demonstrating advanced content processing pipeline")
    
    # Initialize advanced processor
    processor = AdvancedContentProcessor(settings)
    
    # Process items
    processed_items = processor.process_batch_advanced(raw_items)
    
    # Show processing statistics
    stats = processor.get_processing_stats()
    logger.info("📊 Advanced Processing Statistics:")
    logger.info(f"   Total items processed: {stats['total_items']}")
    logger.info(f"   Successfully processed: {stats['processed_items']}")
    logger.info(f"   Rejected items: {stats['rejected_items']}")
    logger.info(f"   Duplicate items: {stats['duplicate_items']}")
    logger.info(f"   Generated chunks: {stats['generated_chunks']}")
    logger.info(f"   Average chunks per item: {stats['average_chunks_per_item']:.1f}")
    logger.info(f"   Success rate: {stats['success_rate']:.1%}")
    
    # Show sample processed content
    if processed_items:
        sample_item = processed_items[0]
        logger.info("🔍 Sample processed content features:")
        logger.info(f"   Content ID: {sample_item.get('content_id')}")
        logger.info(f"   Medical Specialty: {sample_item.get('medical_specialty', 'Unknown')}")
        logger.info(f"   Medical Relevance: {sample_item.get('medical_relevance', 0):.2f}")
        logger.info(f"   Quality Score: {sample_item.get('quality_score', 0):.2f}")
        logger.info(f"   Chunk Count: {sample_item.get('chunk_count', 0)}")
        
        # Show entities
        entities = sample_item.get('entities', [])
        if entities:
            logger.info(f"   Medical Entities ({len(entities)}):")
            for entity in entities[:3]:  # Show first 3
                logger.info(f"     - {entity['text']} ({entity['type']}, confidence: {entity['confidence']:.2f})")
        
        # Show chunks
        chunks = sample_item.get('chunks', [])
        if chunks:
            logger.info(f"   Content Chunks ({len(chunks)}):")
            for i, chunk in enumerate(chunks[:2]):  # Show first 2
                logger.info(f"     Chunk {i+1}: {chunk['word_count']} words, quality: {chunk['quality_score']:.2f}")
        
        # Show search keywords
        keywords = sample_item.get('search_keywords', [])
        if keywords:
            logger.info(f"   Search Keywords: {', '.join(keywords[:5])}...")
        
        # Show semantic tags
        tags = sample_item.get('semantic_tags', [])
        if tags:
            logger.info(f"   Semantic Tags: {', '.join(tags[:5])}...")
    
    return processed_items


def demo_vector_optimization(processed_items: List[Dict[str, Any]]) -> None:
    """Demonstrate vector database optimization features."""
    logger = get_logger()
    
    if not processed_items:
        logger.warning("No processed items for vector optimization demo")
        return
    
    logger.info("🔗 Demonstrating vector database optimization")
    
    total_chunks = 0
    total_entities = 0
    specialties = set()
    content_types = set()
    
    for item in processed_items:
        total_chunks += item.get('chunk_count', 0)
        total_entities += len(item.get('entities', []))
        
        specialty = item.get('medical_specialty')
        if specialty:
            specialties.add(specialty)
        
        content_type = item.get('content_type')
        if content_type:
            content_types.add(content_type)
    
    logger.info("📈 Vector Database Optimization Metrics:")
    logger.info(f"   Total content chunks for embedding: {total_chunks}")
    logger.info(f"   Total medical entities extracted: {total_entities}")
    logger.info(f"   Medical specialties covered: {len(specialties)}")
    logger.info(f"   Content types: {len(content_types)}")
    logger.info(f"   Specialties: {', '.join(sorted(specialties))}")
    logger.info(f"   Content Types: {', '.join(sorted(content_types))}")
    
    # Show chunk distribution
    chunk_sizes = []
    chunk_qualities = []
    
    for item in processed_items:
        for chunk in item.get('chunks', []):
            chunk_sizes.append(chunk.get('word_count', 0))
            chunk_qualities.append(chunk.get('quality_score', 0))
    
    if chunk_sizes:
        avg_chunk_size = sum(chunk_sizes) / len(chunk_sizes)
        avg_chunk_quality = sum(chunk_qualities) / len(chunk_qualities)
        
        logger.info(f"   Average chunk size: {avg_chunk_size:.1f} words")
        logger.info(f"   Average chunk quality: {avg_chunk_quality:.2f}")
        logger.info(f"   Chunk size range: {min(chunk_sizes)} - {max(chunk_sizes)} words")


def demo_api_upload(processed_items: List[Dict[str, Any]], api_config: Dict[str, Any]) -> None:
    """Demonstrate API upload with processed data."""
    logger = get_logger()
    
    if not processed_items:
        logger.warning("No processed items to upload")
        return
    
    logger.info("📤 Demonstrating API upload with enhanced data")
    
    try:
        api_client = APIClient(api_config)
        
        # Generate demo batch ID
        timestamp = datetime.now(timezone.utc).strftime("%Y%m%d_%H%M%S")
        batch_id = f"demo_vinmec_advanced_{timestamp}"
        
        # Upload batch
        success, upload_results = api_client.upload_batch(processed_items, batch_id)
        
        upload_stats = api_client.get_upload_stats()
        
        logger.info("📊 Upload Results:")
        logger.info(f"   Batch ID: {batch_id}")
        logger.info(f"   Upload Success: {'✅' if success else '❌'}")
        logger.info(f"   Items uploaded: {upload_stats['successful_items']}")
        logger.info(f"   Upload success rate: {upload_stats['item_success_rate']:.1%}")
        
        if upload_results.get('chunks'):
            logger.info(f"   Upload chunks: {len(upload_results['chunks'])}")
        
    except Exception as e:
        logger.error(f"Upload demo failed: {e}")


def main():
    """Main demo function."""
    parser = argparse.ArgumentParser(description="Demo advanced processing and Vinmec integration")
    parser.add_argument("--config-dir", default="./config", help="Configuration directory")
    parser.add_argument("--no-upload", action="store_true", help="Skip upload demo")
    parser.add_argument("--limit", type=int, default=3, help="Limit number of pages to crawl")
    parser.add_argument("--log-level", default="INFO", help="Logging level")
    
    args = parser.parse_args()
    
    # Set up logging
    setup_logger(log_level=args.log_level)
    logger = get_logger()
    
    logger.info("🚀 CareCircle Advanced Processing & Vinmec Integration Demo")
    logger.info("=" * 70)
    
    # Load configurations
    config_dir = Path(args.config_dir)
    
    try:
        sources_config = load_config(config_dir / "sources.json")
        crawler_settings = load_config(config_dir / "crawler_settings.json")
        api_config = load_config(config_dir / "api_config.json")
    except Exception as e:
        logger.error(f"Configuration loading failed: {e}")
        sys.exit(1)
    
    # Find Vinmec source configuration
    vinmec_config = None
    for source in sources_config["sources"]:
        if source["id"] == "vinmec-hospital":
            vinmec_config = source.copy()
            break
    
    if not vinmec_config:
        logger.error("Vinmec hospital configuration not found in sources.json")
        sys.exit(1)
    
    # Apply limit
    vinmec_config["max_pages"] = args.limit
    
    # Enable advanced processing
    crawler_settings["advanced_processing"]["enable_metadata_enrichment"] = True
    
    # Initialize file manager
    file_manager = FileManager(crawler_settings)
    
    try:
        # Demo 1: Vinmec content extraction
        raw_items = demo_vinmec_extraction(vinmec_config, crawler_settings)
        
        # Demo 2: Advanced content processing
        processed_items = demo_advanced_processing(raw_items, crawler_settings)
        
        # Demo 3: Vector optimization features
        demo_vector_optimization(processed_items)
        
        # Demo 4: API upload (optional)
        if not args.no_upload and processed_items:
            demo_api_upload(processed_items, api_config)
        
        # Save demo results
        if processed_items:
            timestamp = datetime.now(timezone.utc).strftime("%Y%m%d_%H%M%S")
            demo_file = file_manager.save_processed_content(f"demo_vinmec_{timestamp}", processed_items)
            logger.info(f"💾 Demo results saved to: {demo_file}")
        
        logger.info("=" * 70)
        logger.info("🎉 Demo completed successfully!")
        logger.info("Key features demonstrated:")
        logger.info("  ✅ Vinmec Hospital specialized content extraction")
        logger.info("  ✅ Advanced Vietnamese medical text processing")
        logger.info("  ✅ Semantic chunking for vector embeddings")
        logger.info("  ✅ Medical entity extraction and relationships")
        logger.info("  ✅ Content quality assessment and filtering")
        logger.info("  ✅ Metadata enrichment for better retrieval")
        logger.info("  ✅ Vector database optimization")
        if not args.no_upload:
            logger.info("  ✅ Enhanced API upload integration")
        
    except Exception as e:
        logger.error(f"Demo failed: {e}")
        sys.exit(1)


if __name__ == "__main__":
    main()
