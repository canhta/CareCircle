"""
Content processing for Vietnamese healthcare data.
"""

import hashlib
import json
from typing import Dict, List, Any, Optional
from datetime import datetime, timezone
from loguru import logger

from ..utils.vietnamese_nlp import VietnameseNLP
from ..utils.validation import ContentValidator


class ContentProcessor:
    """
    Process and enhance crawled Vietnamese healthcare content.
    
    Handles text cleaning, entity extraction, quality assessment,
    and preparation for API upload.
    """
    
    def __init__(self, settings: Dict[str, Any]):
        """
        Initialize content processor.
        
        Args:
            settings: Processing configuration settings
        """
        self.settings = settings
        self.nlp = VietnameseNLP(settings.get("vietnamese_nlp", {}))
        self.validator = ContentValidator(settings.get("quality_control", {}))
        
        # Processing statistics
        self.processed_count = 0
        self.rejected_count = 0
        self.duplicate_count = 0
        
        # Content tracking for deduplication
        self.content_hashes = set()
        
        logger.info("Initialized content processor")
    
    def process_item(self, raw_item: Dict[str, Any]) -> Optional[Dict[str, Any]]:
        """
        Process a single crawled content item.
        
        Args:
            raw_item: Raw content item from crawler
            
        Returns:
            Processed content item or None if rejected
        """
        try:
            # Validate basic structure
            if not self.validator.validate_structure(raw_item):
                logger.warning(f"Invalid structure for item from {raw_item.get('source_url', 'unknown')}")
                self.rejected_count += 1
                return None
            
            # Clean and normalize content
            cleaned_content = self._clean_content(raw_item["content"])
            if not cleaned_content:
                logger.warning(f"Content cleaning failed for {raw_item.get('source_url', 'unknown')}")
                self.rejected_count += 1
                return None
            
            # Check for duplicates
            content_hash = self._generate_content_hash(cleaned_content)
            if content_hash in self.content_hashes:
                logger.info(f"Duplicate content detected: {raw_item.get('source_url', 'unknown')}")
                self.duplicate_count += 1
                return None
            
            self.content_hashes.add(content_hash)
            
            # Process with Vietnamese NLP
            nlp_summary = self.nlp.get_content_summary(cleaned_content)
            
            # Assess content quality
            quality_score = self._assess_quality(raw_item, nlp_summary)
            
            # Check quality threshold
            min_quality = self.settings.get("quality_control", {}).get("min_content_quality", 0.5)
            if quality_score < min_quality:
                logger.info(f"Content quality too low ({quality_score:.2f}): {raw_item.get('source_url', 'unknown')}")
                self.rejected_count += 1
                return None
            
            # Check medical relevance
            medical_relevance = nlp_summary["medical_relevance"]
            min_relevance = self.settings.get("quality_control", {}).get("medical_relevance_threshold", 0.6)
            if medical_relevance < min_relevance:
                logger.info(f"Medical relevance too low ({medical_relevance:.2f}): {raw_item.get('source_url', 'unknown')}")
                self.rejected_count += 1
                return None
            
            # Build processed item
            processed_item = self._build_processed_item(raw_item, cleaned_content, nlp_summary, quality_score)
            
            self.processed_count += 1
            logger.info(f"Processed content: {processed_item['title'][:50]}... (Quality: {quality_score:.2f})")
            
            return processed_item
            
        except Exception as e:
            logger.error(f"Content processing failed: {e}")
            self.rejected_count += 1
            return None
    
    def _clean_content(self, content: str) -> Optional[str]:
        """Clean and normalize content text."""
        if not content:
            return None
        
        # Use Vietnamese NLP for cleaning
        cleaned = self.nlp.clean_medical_content(content)
        
        # Additional cleaning
        if self.settings.get("content_processing", {}).get("normalize_whitespace", True):
            import re
            cleaned = re.sub(r'\s+', ' ', cleaned)
            cleaned = cleaned.strip()
        
        # Check length constraints
        min_length = self.settings.get("content_processing", {}).get("min_content_length", 100)
        max_length = self.settings.get("content_processing", {}).get("max_content_length", 1000000)
        
        if len(cleaned) < min_length:
            logger.debug(f"Content too short: {len(cleaned)} characters")
            return None
        
        if len(cleaned) > max_length:
            logger.warning(f"Content too long, truncating: {len(cleaned)} characters")
            cleaned = cleaned[:max_length]
        
        return cleaned
    
    def _generate_content_hash(self, content: str) -> str:
        """Generate hash for content deduplication."""
        # Normalize content for hashing
        normalized = content.lower().strip()
        normalized = ''.join(normalized.split())  # Remove all whitespace
        
        return hashlib.sha256(normalized.encode('utf-8')).hexdigest()
    
    def _assess_quality(self, raw_item: Dict[str, Any], nlp_summary: Dict[str, Any]) -> float:
        """
        Assess overall content quality.
        
        Args:
            raw_item: Original content item
            nlp_summary: NLP processing results
            
        Returns:
            Quality score between 0 and 1
        """
        quality_factors = []
        
        # Content length factor
        content_length = nlp_summary["word_count"]
        if content_length > 50:
            length_score = min(1.0, content_length / 200)  # Optimal around 200 words
        else:
            length_score = content_length / 50  # Penalty for very short content
        quality_factors.append(("length", length_score, 0.2))
        
        # Medical relevance factor
        medical_relevance = nlp_summary["medical_relevance"]
        quality_factors.append(("medical_relevance", medical_relevance, 0.3))
        
        # Entity extraction factor
        entity_count = len(nlp_summary["entities"])
        entity_score = min(1.0, entity_count / 5)  # Optimal around 5 entities
        quality_factors.append(("entities", entity_score, 0.2))
        
        # Source authority factor
        source_type = raw_item.get("metadata", {}).get("source_type", "unknown")
        authority_scores = {
            "government": 1.0,
            "hospital": 0.9,
            "medical_institution": 0.8,
            "news": 0.6,
            "unknown": 0.3
        }
        authority_score = authority_scores.get(source_type, 0.3)
        quality_factors.append(("authority", authority_score, 0.2))
        
        # Title quality factor
        title = raw_item.get("title", "")
        title_score = 0.5  # Default
        if title:
            if len(title) > 10 and len(title) < 200:
                title_score = 0.8
            if any(term in title.lower() for term in ["bệnh", "thuốc", "điều trị", "y tế", "sức khỏe"]):
                title_score += 0.2
        quality_factors.append(("title", min(1.0, title_score), 0.1))
        
        # Calculate weighted average
        total_score = sum(score * weight for _, score, weight in quality_factors)
        
        logger.debug(f"Quality assessment: {quality_factors} -> {total_score:.2f}")
        return total_score
    
    def _build_processed_item(
        self, 
        raw_item: Dict[str, Any], 
        cleaned_content: str, 
        nlp_summary: Dict[str, Any], 
        quality_score: float
    ) -> Dict[str, Any]:
        """Build the final processed content item."""
        
        # Generate unique content ID
        content_id = self._generate_content_id(raw_item["source_url"])
        
        # Build enhanced metadata
        metadata = raw_item.get("metadata", {}).copy()
        metadata.update({
            "content_hash": self._generate_content_hash(cleaned_content),
            "quality_score": quality_score,
            "medical_relevance": nlp_summary["medical_relevance"],
            "word_count": nlp_summary["word_count"],
            "entity_count": len(nlp_summary["entities"]),
            "processed_at": datetime.now(timezone.utc).isoformat(),
            "processor_version": "1.0.0"
        })
        
        # Build processed item
        processed_item = {
            "content_id": content_id,
            "source_id": raw_item["source_id"],
            "source_url": raw_item["source_url"],
            "title": raw_item["title"],
            "content": cleaned_content,
            "content_type": raw_item.get("content_type", "article"),
            "language": raw_item.get("language", "vi"),
            "published_at": raw_item.get("published_at"),
            "crawled_at": raw_item["crawled_at"],
            "metadata": metadata,
            "extracted_entities": nlp_summary["entities"],
            "key_phrases": nlp_summary["key_phrases"]
        }
        
        return processed_item
    
    def _generate_content_id(self, source_url: str) -> str:
        """Generate unique content ID."""
        timestamp = datetime.now(timezone.utc).strftime("%Y%m%d_%H%M%S")
        url_hash = hashlib.md5(source_url.encode('utf-8')).hexdigest()[:8]
        return f"content_{timestamp}_{url_hash}"
    
    def process_batch(self, raw_items: List[Dict[str, Any]]) -> List[Dict[str, Any]]:
        """
        Process a batch of content items.
        
        Args:
            raw_items: List of raw content items
            
        Returns:
            List of processed content items
        """
        logger.info(f"Processing batch of {len(raw_items)} items")
        
        processed_items = []
        for item in raw_items:
            processed = self.process_item(item)
            if processed:
                processed_items.append(processed)
        
        logger.info(
            f"Batch processing completed: {len(processed_items)} processed, "
            f"{self.rejected_count} rejected, {self.duplicate_count} duplicates"
        )
        
        return processed_items
    
    def get_processing_stats(self) -> Dict[str, Any]:
        """Get processing statistics."""
        total_processed = self.processed_count + self.rejected_count + self.duplicate_count
        
        return {
            "total_items": total_processed,
            "processed": self.processed_count,
            "rejected": self.rejected_count,
            "duplicates": self.duplicate_count,
            "success_rate": self.processed_count / total_processed if total_processed > 0 else 0,
            "unique_content_hashes": len(self.content_hashes)
        }
    
    def reset_stats(self):
        """Reset processing statistics."""
        self.processed_count = 0
        self.rejected_count = 0
        self.duplicate_count = 0
        self.content_hashes.clear()
        logger.info("Processing statistics reset")
