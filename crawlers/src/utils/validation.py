"""
Content validation utilities for Vietnamese healthcare data.
"""

import re
from typing import Dict, List, Any, Optional, Tuple
from urllib.parse import urlparse
from datetime import datetime
from loguru import logger


class ContentValidator:
    """Validate content structure, quality, and medical relevance."""
    
    def __init__(self, settings: Dict[str, Any]):
        """
        Initialize content validator.
        
        Args:
            settings: Validation configuration settings
        """
        self.settings = settings
        self.required_fields = [
            "source_id", "source_url", "title", "content", 
            "language", "crawled_at"
        ]
        
    def validate_structure(self, item: Dict[str, Any]) -> bool:
        """
        Validate basic content item structure.
        
        Args:
            item: Content item to validate
            
        Returns:
            True if structure is valid
        """
        # Check required fields
        for field in self.required_fields:
            if field not in item or not item[field]:
                logger.debug(f"Missing required field: {field}")
                return False
        
        # Validate URL format
        if not self._is_valid_url(item["source_url"]):
            logger.debug(f"Invalid URL: {item['source_url']}")
            return False
        
        # Validate language
        if item["language"] not in ["vi", "en"]:
            logger.debug(f"Invalid language: {item['language']}")
            return False
        
        # Validate content length
        content_length = len(item["content"])
        min_length = self.settings.get("min_content_length", 100)
        max_length = self.settings.get("max_content_length", 1000000)
        
        if content_length < min_length or content_length > max_length:
            logger.debug(f"Invalid content length: {content_length}")
            return False
        
        return True
    
    def _is_valid_url(self, url: str) -> bool:
        """Check if URL is valid."""
        try:
            result = urlparse(url)
            return all([result.scheme, result.netloc])
        except Exception:
            return False
    
    def validate_medical_content(self, content: str) -> Tuple[bool, float]:
        """
        Validate if content is medical/healthcare related.
        
        Args:
            content: Content text to validate
            
        Returns:
            Tuple of (is_valid, relevance_score)
        """
        if not content:
            return False, 0.0
        
        content_lower = content.lower()
        
        # Medical keywords for Vietnamese content
        medical_keywords = [
            # General medical terms
            "y tế", "sức khỏe", "bệnh", "thuốc", "điều trị", "chữa bệnh",
            "khám bệnh", "bác sĩ", "bệnh viện", "phòng khám", "chẩn đoán",
            
            # Body parts and systems
            "tim", "phổi", "gan", "thận", "dạ dày", "ruột", "não", "máu",
            "xương", "khớp", "da", "mắt", "tai", "mũi", "họng",
            
            # Common conditions
            "tiểu đường", "huyết áp", "ung thư", "viêm", "nhiễm trùng",
            "đau đầu", "sốt", "ho", "khó thở", "mệt mỏi",
            
            # Medical procedures
            "xét nghiệm", "chụp x-quang", "siêu âm", "phẫu thuật", "tiêm",
            "vaccine", "thuốc", "liều lượng", "tác dụng phụ",
            
            # Healthcare system
            "bảo hiểm y tế", "bộ y tế", "dịch vụ y tế", "cấp cứu",
            "điều dưỡng", "dược sĩ", "chuyên khoa"
        ]
        
        # Count medical keyword occurrences
        keyword_count = 0
        total_words = len(content.split())
        
        for keyword in medical_keywords:
            keyword_count += content_lower.count(keyword)
        
        # Calculate relevance score
        relevance_score = min(1.0, keyword_count / max(1, total_words / 10))
        
        # Check minimum threshold
        min_relevance = self.settings.get("medical_relevance_threshold", 0.1)
        is_valid = relevance_score >= min_relevance
        
        return is_valid, relevance_score
    
    def validate_content_quality(self, item: Dict[str, Any]) -> Tuple[bool, float, List[str]]:
        """
        Validate overall content quality.
        
        Args:
            item: Content item to validate
            
        Returns:
            Tuple of (is_valid, quality_score, issues)
        """
        issues = []
        quality_factors = []
        
        # Title quality
        title = item.get("title", "")
        if not title:
            issues.append("Missing title")
            title_score = 0.0
        elif len(title) < 10:
            issues.append("Title too short")
            title_score = 0.3
        elif len(title) > 200:
            issues.append("Title too long")
            title_score = 0.7
        else:
            title_score = 1.0
        
        quality_factors.append(title_score * 0.2)
        
        # Content quality
        content = item.get("content", "")
        content_score = self._assess_content_quality(content)
        quality_factors.append(content_score * 0.4)
        
        if content_score < 0.3:
            issues.append("Poor content quality")
        
        # Medical relevance
        is_medical, relevance_score = self.validate_medical_content(content)
        quality_factors.append(relevance_score * 0.3)
        
        if not is_medical:
            issues.append("Low medical relevance")
        
        # Source quality
        source_score = self._assess_source_quality(item)
        quality_factors.append(source_score * 0.1)
        
        # Calculate overall quality
        overall_quality = sum(quality_factors)
        min_quality = self.settings.get("min_content_quality", 0.5)
        is_valid = overall_quality >= min_quality and len(issues) == 0
        
        return is_valid, overall_quality, issues
    
    def _assess_content_quality(self, content: str) -> float:
        """Assess content quality based on various factors."""
        if not content:
            return 0.0
        
        quality_score = 0.5  # Base score
        
        # Length factor
        length = len(content)
        if 200 <= length <= 5000:  # Optimal length range
            quality_score += 0.2
        elif length < 100:
            quality_score -= 0.3
        
        # Sentence structure
        sentences = re.split(r'[.!?]+', content)
        avg_sentence_length = sum(len(s.split()) for s in sentences) / max(1, len(sentences))
        
        if 10 <= avg_sentence_length <= 30:  # Good sentence length
            quality_score += 0.1
        
        # Repetition check
        words = content.lower().split()
        unique_words = set(words)
        repetition_ratio = len(unique_words) / max(1, len(words))
        
        if repetition_ratio > 0.5:  # Good vocabulary diversity
            quality_score += 0.1
        
        # Special characters and formatting
        if re.search(r'[^\w\s\u00C0-\u1EF9.,!?;:()\-"]', content):
            quality_score -= 0.1  # Penalty for excessive special chars
        
        return max(0.0, min(1.0, quality_score))
    
    def _assess_source_quality(self, item: Dict[str, Any]) -> float:
        """Assess source quality and authority."""
        source_url = item.get("source_url", "")
        metadata = item.get("metadata", {})
        source_type = metadata.get("source_type", "unknown")
        
        # Base scores by source type
        type_scores = {
            "government": 1.0,
            "hospital": 0.9,
            "medical_institution": 0.8,
            "university": 0.8,
            "news": 0.6,
            "blog": 0.4,
            "unknown": 0.3
        }
        
        base_score = type_scores.get(source_type, 0.3)
        
        # Domain authority indicators
        domain_indicators = {
            ".gov.vn": 0.2,
            ".edu.vn": 0.15,
            ".org.vn": 0.1,
            "moh.gov.vn": 0.2,
            "benhvien": 0.1,
            "hospital": 0.1
        }
        
        domain_bonus = 0.0
        for indicator, bonus in domain_indicators.items():
            if indicator in source_url.lower():
                domain_bonus += bonus
                break
        
        return min(1.0, base_score + domain_bonus)
    
    def validate_batch(self, items: List[Dict[str, Any]]) -> Dict[str, Any]:
        """
        Validate a batch of content items.
        
        Args:
            items: List of content items to validate
            
        Returns:
            Validation summary
        """
        results = {
            "total_items": len(items),
            "valid_items": 0,
            "invalid_items": 0,
            "issues": [],
            "quality_scores": []
        }
        
        for i, item in enumerate(items):
            # Structure validation
            if not self.validate_structure(item):
                results["invalid_items"] += 1
                results["issues"].append(f"Item {i}: Invalid structure")
                continue
            
            # Quality validation
            is_valid, quality_score, issues = self.validate_content_quality(item)
            results["quality_scores"].append(quality_score)
            
            if is_valid:
                results["valid_items"] += 1
            else:
                results["invalid_items"] += 1
                results["issues"].extend([f"Item {i}: {issue}" for issue in issues])
        
        # Calculate average quality
        if results["quality_scores"]:
            results["average_quality"] = sum(results["quality_scores"]) / len(results["quality_scores"])
        else:
            results["average_quality"] = 0.0
        
        return results
    
    def get_validation_report(self, items: List[Dict[str, Any]]) -> str:
        """Generate a human-readable validation report."""
        results = self.validate_batch(items)
        
        report = f"""
Content Validation Report
========================

Total Items: {results['total_items']}
Valid Items: {results['valid_items']}
Invalid Items: {results['invalid_items']}
Success Rate: {results['valid_items'] / max(1, results['total_items']) * 100:.1f}%
Average Quality Score: {results['average_quality']:.2f}

Issues Found:
"""
        
        if results['issues']:
            for issue in results['issues'][:10]:  # Show first 10 issues
                report += f"- {issue}\n"
            
            if len(results['issues']) > 10:
                report += f"... and {len(results['issues']) - 10} more issues\n"
        else:
            report += "No issues found.\n"
        
        return report
