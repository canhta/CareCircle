"""
Advanced data processing pipeline for Vietnamese healthcare content.
"""

import re
import hashlib
import json
from typing import Dict, List, Any, Optional, Tuple
from datetime import datetime, timezone
from loguru import logger

from ..utils.vietnamese_nlp import VietnameseNLP
from ..utils.validation import ContentValidator


class AdvancedContentProcessor:
    """
    Advanced content processor with enhanced Vietnamese medical text processing,
    semantic chunking, and metadata enrichment for vector database optimization.
    """
    
    def __init__(self, settings: Dict[str, Any]):
        """Initialize advanced content processor."""
        self.settings = settings
        self.nlp = VietnameseNLP(settings.get("vietnamese_nlp", {}))
        self.validator = ContentValidator(settings.get("quality_control", {}))
        
        # Enhanced processing settings
        self.chunk_settings = settings.get("chunking", {
            "max_chunk_size": 1000,
            "overlap_size": 200,
            "min_chunk_size": 100,
            "semantic_chunking": True
        })
        
        # Medical terminology standardization
        self.medical_standardization = self._load_medical_standardization()
        
        # Processing statistics
        self.stats = {
            "processed_items": 0,
            "generated_chunks": 0,
            "rejected_items": 0,
            "duplicate_items": 0,
            "enhanced_metadata": 0
        }
        
        # Content tracking for advanced deduplication
        self.content_fingerprints = set()
        self.semantic_hashes = set()
        
        logger.info("Initialized advanced content processor")
    
    def _load_medical_standardization(self) -> Dict[str, Dict[str, str]]:
        """Load medical terminology standardization mappings."""
        return {
            "abbreviations": {
                "HA": "huyết áp",
                "ĐTĐ": "đái tháo đường",
                "COPD": "bệnh phổi tắc nghẽn mạn tính",
                "HIV": "virus gây suy giảm miễn dịch",
                "AIDS": "hội chứng suy giảm miễn dịch mắc phải",
                "TB": "lao phổi",
                "CVD": "bệnh tim mạch",
                "BMI": "chỉ số khối cơ thể",
                "WHO": "Tổ chức Y tế Thế giới",
                "FDA": "Cục Quản lý Thực phẩm và Dược phẩm",
                "ICU": "khoa hồi sức tích cực",
                "ER": "khoa cấp cứu",
                "CT": "chụp cắt lớp vi tính",
                "MRI": "chụp cộng hưởng từ",
                "ECG": "điện tim",
                "EEG": "điện não đồ"
            },
            "synonyms": {
                "bệnh tiểu đường": "đái tháo đường",
                "cao huyết áp": "tăng huyết áp",
                "ung thư": "ung bướu",
                "viêm phổi": "viêm phế quản",
                "đau tim": "nhồi máu cơ tim",
                "tai biến": "đột quỵ",
                "suy thận": "bệnh thận mạn",
                "viêm gan": "bệnh gan",
                "loãng xương": "osteoporosis",
                "trầm cảm": "rối loạn trầm cảm"
            },
            "medical_units": {
                "mg/dl": "milligram trên deciliter",
                "mmHg": "milimét thủy ngân",
                "bpm": "nhịp mỗi phút",
                "°C": "độ Celsius",
                "ml": "mililít",
                "kg": "kilogram",
                "cm": "centimet",
                "m²": "mét vuông"
            }
        }
    
    def process_content_advanced(self, raw_item: Dict[str, Any]) -> Optional[Dict[str, Any]]:
        """
        Process content with advanced Vietnamese medical text processing.
        
        Args:
            raw_item: Raw content item from crawler
            
        Returns:
            Processed content with enhanced metadata and chunking
        """
        try:
            # Basic validation
            if not self.validator.validate_structure(raw_item):
                logger.warning(f"Invalid structure: {raw_item.get('source_url', 'unknown')}")
                self.stats["rejected_items"] += 1
                return None
            
            # Advanced text cleaning and normalization
            cleaned_content = self._advanced_text_cleaning(raw_item["content"])
            if not cleaned_content:
                logger.warning(f"Content cleaning failed: {raw_item.get('source_url', 'unknown')}")
                self.stats["rejected_items"] += 1
                return None
            
            # Medical terminology standardization
            standardized_content = self._standardize_medical_terminology(cleaned_content)
            
            # Advanced deduplication
            if self._is_duplicate_content(standardized_content, raw_item):
                logger.info(f"Duplicate content detected: {raw_item.get('source_url', 'unknown')}")
                self.stats["duplicate_items"] += 1
                return None
            
            # Enhanced NLP processing
            nlp_analysis = self._enhanced_nlp_analysis(standardized_content, raw_item)
            
            # Quality assessment with medical focus
            quality_score = self._assess_medical_quality(raw_item, nlp_analysis)
            
            # Check quality threshold
            min_quality = self.settings.get("quality_control", {}).get("min_content_quality", 0.5)
            if quality_score < min_quality:
                logger.info(f"Quality too low ({quality_score:.2f}): {raw_item.get('source_url', 'unknown')}")
                self.stats["rejected_items"] += 1
                return None
            
            # Generate semantic chunks
            chunks = self._generate_semantic_chunks(standardized_content, raw_item, nlp_analysis)
            
            # Enhanced metadata enrichment
            enhanced_metadata = self._enrich_metadata(raw_item, nlp_analysis, quality_score)
            
            # Build processed item with chunks
            processed_item = self._build_processed_item_with_chunks(
                raw_item, standardized_content, chunks, enhanced_metadata, nlp_analysis
            )
            
            self.stats["processed_items"] += 1
            self.stats["generated_chunks"] += len(chunks)
            self.stats["enhanced_metadata"] += 1
            
            logger.info(
                f"Advanced processing completed: {processed_item['title'][:50]}... "
                f"(Quality: {quality_score:.2f}, Chunks: {len(chunks)})"
            )
            
            return processed_item
            
        except Exception as e:
            logger.error(f"Advanced processing failed: {e}")
            self.stats["rejected_items"] += 1
            return None
    
    def _advanced_text_cleaning(self, content: str) -> Optional[str]:
        """Advanced text cleaning for Vietnamese medical content."""
        if not content:
            return None
        
        # Use base Vietnamese NLP cleaning
        cleaned = self.nlp.clean_medical_content(content)
        
        # Additional medical-specific cleaning
        
        # Remove common non-medical patterns
        patterns_to_remove = [
            r'(?i)cookie.*?chính sách',
            r'(?i)bản quyền.*?\d{4}',
            r'(?i)liên hệ.*?hotline.*?\d+',
            r'(?i)đăng ký.*?nhận tin',
            r'(?i)chia sẻ.*?facebook.*?twitter',
            r'(?i)xem thêm.*?tại đây',
            r'(?i)nguồn.*?theo.*?vnexpress',
            r'(?i)theo.*?báo.*?điện tử'
        ]
        
        for pattern in patterns_to_remove:
            cleaned = re.sub(pattern, '', cleaned)
        
        # Normalize Vietnamese medical punctuation
        cleaned = re.sub(r'["""]', '"', cleaned)
        cleaned = re.sub(r'[''']', "'", cleaned)
        cleaned = re.sub(r'[–—]', '-', cleaned)
        
        # Fix common Vietnamese medical text issues
        cleaned = re.sub(r'(\d+)\s*-\s*(\d+)', r'\1-\2', cleaned)  # Fix number ranges
        cleaned = re.sub(r'(\d+)\s*%', r'\1%', cleaned)  # Fix percentages
        cleaned = re.sub(r'(\d+)\s*(mg|ml|kg|cm)', r'\1\2', cleaned)  # Fix units
        
        # Remove excessive whitespace
        cleaned = re.sub(r'\n\s*\n\s*\n', '\n\n', cleaned)
        cleaned = re.sub(r' +', ' ', cleaned)
        
        return cleaned.strip()
    
    def _standardize_medical_terminology(self, content: str) -> str:
        """Standardize Vietnamese medical terminology."""
        standardized = content
        
        # Expand abbreviations
        for abbrev, expansion in self.medical_standardization["abbreviations"].items():
            pattern = r'\b' + re.escape(abbrev) + r'\b'
            standardized = re.sub(pattern, f"{abbrev} ({expansion})", standardized, flags=re.IGNORECASE)
        
        # Standardize synonyms (replace with preferred terms)
        for synonym, preferred in self.medical_standardization["synonyms"].items():
            pattern = r'\b' + re.escape(synonym) + r'\b'
            standardized = re.sub(pattern, preferred, standardized, flags=re.IGNORECASE)
        
        # Standardize medical units
        for unit, description in self.medical_standardization["medical_units"].items():
            pattern = r'\b' + re.escape(unit) + r'\b'
            standardized = re.sub(pattern, f"{unit} ({description})", standardized)
        
        return standardized
    
    def _is_duplicate_content(self, content: str, raw_item: Dict[str, Any]) -> bool:
        """Advanced duplicate detection using multiple strategies."""
        
        # 1. Exact content fingerprint
        content_fingerprint = hashlib.sha256(content.encode('utf-8')).hexdigest()
        if content_fingerprint in self.content_fingerprints:
            return True
        self.content_fingerprints.add(content_fingerprint)
        
        # 2. Semantic hash (based on medical entities and key phrases)
        entities = self.nlp.extract_medical_entities(content)
        entity_texts = [e["text"] for e in entities]
        semantic_content = " ".join(sorted(entity_texts))
        semantic_hash = hashlib.md5(semantic_content.encode('utf-8')).hexdigest()
        
        if semantic_hash in self.semantic_hashes:
            return True
        self.semantic_hashes.add(semantic_hash)
        
        # 3. Title similarity check
        title = raw_item.get("title", "")
        if title:
            title_hash = hashlib.md5(title.lower().encode('utf-8')).hexdigest()
            # This is a simplified check - in practice you'd want more sophisticated similarity
            
        return False
    
    def _enhanced_nlp_analysis(self, content: str, raw_item: Dict[str, Any]) -> Dict[str, Any]:
        """Enhanced NLP analysis with medical focus."""
        base_analysis = self.nlp.get_content_summary(content)
        
        # Enhanced medical entity extraction
        enhanced_entities = self._extract_enhanced_entities(content)
        
        # Medical specialty classification
        medical_specialty = self._classify_medical_specialty(content, raw_item)
        
        # Content type classification
        content_type = self._classify_content_type(content, raw_item)
        
        # Temporal information extraction
        temporal_info = self._extract_temporal_information(content)
        
        # Medical severity assessment
        severity_indicators = self._assess_medical_severity(content)
        
        return {
            **base_analysis,
            "enhanced_entities": enhanced_entities,
            "medical_specialty": medical_specialty,
            "content_type": content_type,
            "temporal_info": temporal_info,
            "severity_indicators": severity_indicators
        }
    
    def _extract_enhanced_entities(self, content: str) -> List[Dict[str, Any]]:
        """Extract enhanced medical entities with relationships."""
        base_entities = self.nlp.extract_medical_entities(content)
        
        enhanced_entities = []
        for entity in base_entities:
            enhanced_entity = entity.copy()
            
            # Add context information
            start, end = entity["start"], entity["end"]
            context_start = max(0, start - 50)
            context_end = min(len(content), end + 50)
            enhanced_entity["context"] = content[context_start:context_end]
            
            # Add entity relationships (simplified)
            enhanced_entity["relationships"] = self._find_entity_relationships(entity, base_entities)
            
            # Add standardized form
            enhanced_entity["standardized_text"] = self._standardize_entity_text(entity["text"])
            
            enhanced_entities.append(enhanced_entity)
        
        return enhanced_entities
    
    def _find_entity_relationships(self, entity: Dict[str, Any], all_entities: List[Dict[str, Any]]) -> List[str]:
        """Find relationships between medical entities."""
        relationships = []
        
        # Simple proximity-based relationships
        entity_start, entity_end = entity["start"], entity["end"]
        
        for other_entity in all_entities:
            if other_entity == entity:
                continue
            
            other_start, other_end = other_entity["start"], other_entity["end"]
            distance = min(abs(entity_start - other_end), abs(other_start - entity_end))
            
            # If entities are close (within 100 characters), consider them related
            if distance < 100:
                relationship_type = self._determine_relationship_type(entity, other_entity)
                if relationship_type:
                    relationships.append(f"{relationship_type}:{other_entity['text']}")
        
        return relationships[:3]  # Limit to 3 relationships
    
    def _determine_relationship_type(self, entity1: Dict[str, Any], entity2: Dict[str, Any]) -> Optional[str]:
        """Determine the type of relationship between two entities."""
        type1, type2 = entity1["type"], entity2["type"]
        
        relationship_patterns = {
            ("disease", "symptom"): "has_symptom",
            ("disease", "medication"): "treated_with",
            ("symptom", "medication"): "relieved_by",
            ("procedure", "disease"): "diagnoses",
            ("medication", "disease"): "treats"
        }
        
        return relationship_patterns.get((type1, type2)) or relationship_patterns.get((type2, type1))
    
    def _standardize_entity_text(self, entity_text: str) -> str:
        """Standardize entity text using medical terminology mappings."""
        standardized = entity_text.lower()
        
        # Apply synonym standardization
        for synonym, preferred in self.medical_standardization["synonyms"].items():
            if synonym.lower() == standardized:
                return preferred
        
        return entity_text
    
    def _classify_medical_specialty(self, content: str, raw_item: Dict[str, Any]) -> str:
        """Classify content by medical specialty."""
        content_lower = content.lower()
        title_lower = raw_item.get("title", "").lower()
        
        specialty_keywords = {
            "cardiology": ["tim", "mạch", "huyết áp", "nhồi máu", "đột quỵ", "tim mạch"],
            "neurology": ["thần kinh", "não", "đột quỵ", "parkinson", "alzheimer", "động kinh"],
            "oncology": ["ung thư", "ung bướu", "khối u", "hóa trị", "xạ trị", "ác tính"],
            "pediatrics": ["trẻ em", "nhi", "em bé", "trẻ nhỏ", "vaccine trẻ em"],
            "obstetrics": ["thai", "sinh", "sản", "phụ khoa", "mang thai", "sinh đẻ"],
            "orthopedics": ["xương", "khớp", "gãy", "chấn thương", "cột sống"],
            "gastroenterology": ["dạ dày", "ruột", "gan", "tiêu hóa", "đại tràng"],
            "respiratory": ["phổi", "hô hấp", "hen", "copd", "viêm phổi", "ho"],
            "endocrinology": ["tiểu đường", "tuyến giáp", "nội tiết", "hormone"],
            "dermatology": ["da", "nấm", "viêm da", "dị ứng da", "da liễu"],
            "psychiatry": ["tâm thần", "trầm cảm", "lo âu", "stress", "tâm lý"]
        }
        
        specialty_scores = {}
        text_to_analyze = title_lower + " " + content_lower
        
        for specialty, keywords in specialty_keywords.items():
            score = sum(text_to_analyze.count(keyword) for keyword in keywords)
            if score > 0:
                specialty_scores[specialty] = score
        
        if specialty_scores:
            return max(specialty_scores, key=specialty_scores.get)
        
        return "general"
    
    def _classify_content_type(self, content: str, raw_item: Dict[str, Any]) -> str:
        """Classify content type for better retrieval."""
        title = raw_item.get("title", "").lower()
        content_lower = content.lower()
        url = raw_item.get("source_url", "").lower()
        
        # Check for specific content types
        if any(keyword in title for keyword in ["hướng dẫn", "cách", "làm thế nào"]):
            return "guide"
        elif any(keyword in title for keyword in ["nghiên cứu", "báo cáo", "phát hiện"]):
            return "research"
        elif any(keyword in title for keyword in ["triệu chứng", "dấu hiệu", "biểu hiện"]):
            return "symptoms"
        elif any(keyword in title for keyword in ["điều trị", "chữa", "phương pháp"]):
            return "treatment"
        elif any(keyword in title for keyword in ["phòng ngừa", "dự phòng", "tránh"]):
            return "prevention"
        elif any(keyword in url for keyword in ["dich-vu", "service"]):
            return "service"
        elif any(keyword in url for keyword in ["bac-si", "doctor"]):
            return "doctor_profile"
        
        return "article"

    def _extract_temporal_information(self, content: str) -> Dict[str, Any]:
        """Extract temporal information from medical content."""
        temporal_info = {
            "treatment_duration": None,
            "onset_time": None,
            "follow_up_period": None,
            "age_groups": []
        }

        # Treatment duration patterns
        duration_patterns = [
            r"(\d+)\s*(ngày|tuần|tháng|năm)\s*điều trị",
            r"điều trị\s*(\d+)\s*(ngày|tuần|tháng|năm)",
            r"trong\s*(\d+)\s*(ngày|tuần|tháng|năm)"
        ]

        for pattern in duration_patterns:
            match = re.search(pattern, content, re.IGNORECASE)
            if match:
                temporal_info["treatment_duration"] = f"{match.group(1)} {match.group(2)}"
                break

        # Age group extraction
        age_patterns = [
            r"trẻ em\s*(\d+)\s*-\s*(\d+)\s*tuổi",
            r"người lớn\s*trên\s*(\d+)\s*tuổi",
            r"từ\s*(\d+)\s*đến\s*(\d+)\s*tuổi"
        ]

        for pattern in age_patterns:
            matches = re.finditer(pattern, content, re.IGNORECASE)
            for match in matches:
                temporal_info["age_groups"].append(match.group())

        return temporal_info

    def _assess_medical_severity(self, content: str) -> Dict[str, Any]:
        """Assess medical severity indicators in content."""
        severity_indicators = {
            "emergency_keywords": 0,
            "chronic_keywords": 0,
            "severity_level": "low"
        }

        emergency_keywords = [
            "cấp cứu", "khẩn cấp", "nguy hiểm", "tử vong", "hôn mê",
            "sốc", "ngừng tim", "ngừng thở", "chảy máu", "đột ngột"
        ]

        chronic_keywords = [
            "mạn tính", "lâu dài", "suốt đời", "không khỏi",
            "kiểm soát", "theo dõi", "định kỳ"
        ]

        content_lower = content.lower()

        for keyword in emergency_keywords:
            severity_indicators["emergency_keywords"] += content_lower.count(keyword)

        for keyword in chronic_keywords:
            severity_indicators["chronic_keywords"] += content_lower.count(keyword)

        # Determine severity level
        if severity_indicators["emergency_keywords"] > 2:
            severity_indicators["severity_level"] = "high"
        elif severity_indicators["chronic_keywords"] > 2:
            severity_indicators["severity_level"] = "medium"

        return severity_indicators

    def _assess_medical_quality(self, raw_item: Dict[str, Any], nlp_analysis: Dict[str, Any]) -> float:
        """Enhanced medical quality assessment."""
        quality_factors = []

        # Base quality from validator
        is_valid, base_quality, issues = self.validator.validate_content_quality(raw_item)
        quality_factors.append(("base_quality", base_quality, 0.3))

        # Medical relevance (enhanced)
        medical_relevance = nlp_analysis["medical_relevance"]
        quality_factors.append(("medical_relevance", medical_relevance, 0.25))

        # Entity richness
        entity_count = len(nlp_analysis.get("enhanced_entities", []))
        entity_score = min(1.0, entity_count / 8)  # Optimal around 8 entities
        quality_factors.append(("entity_richness", entity_score, 0.2))

        # Content structure quality
        structure_score = self._assess_content_structure(raw_item["content"])
        quality_factors.append(("structure", structure_score, 0.15))

        # Medical specialty specificity
        specialty = nlp_analysis.get("medical_specialty", "general")
        specialty_score = 0.8 if specialty != "general" else 0.4
        quality_factors.append(("specialty_specificity", specialty_score, 0.1))

        # Calculate weighted average
        total_score = sum(score * weight for _, score, weight in quality_factors)

        return min(1.0, max(0.0, total_score))

    def _assess_content_structure(self, content: str) -> float:
        """Assess content structure quality."""
        structure_score = 0.5  # Base score

        # Check for proper paragraphs
        paragraphs = content.split('\n\n')
        if len(paragraphs) > 2:
            structure_score += 0.2

        # Check for lists or bullet points
        if re.search(r'^\s*[-•]\s+', content, re.MULTILINE):
            structure_score += 0.1

        # Check for numbered lists
        if re.search(r'^\s*\d+\.\s+', content, re.MULTILINE):
            structure_score += 0.1

        # Check for headers (simplified)
        if re.search(r'^[A-ZÀÁẠẢÃÂẦẤẬẨẪĂẰẮẶẲẴÈÉẸẺẼÊỀẾỆỂỄÌÍỊỈĨÒÓỌỎÕÔỒỐỘỔỖƠỜỚỢỞỠÙÚỤỦŨƯỪỨỰỬỮỲÝỴỶỸĐ][^.!?]*:?\s*$', content, re.MULTILINE):
            structure_score += 0.1

        return min(1.0, structure_score)

    def _generate_semantic_chunks(
        self,
        content: str,
        raw_item: Dict[str, Any],
        nlp_analysis: Dict[str, Any]
    ) -> List[Dict[str, Any]]:
        """Generate semantic chunks optimized for vector embeddings."""

        if not self.chunk_settings.get("semantic_chunking", True):
            return self._generate_simple_chunks(content)

        chunks = []

        # Split content into sentences
        sentences = self._split_into_sentences(content)

        if len(sentences) <= 3:
            # Short content - create single chunk
            return [{
                "chunk_id": 0,
                "content": content,
                "start_position": 0,
                "end_position": len(content),
                "sentence_count": len(sentences),
                "chunk_type": "complete"
            }]

        # Group sentences into semantic chunks
        current_chunk = []
        current_length = 0
        chunk_id = 0

        max_chunk_size = self.chunk_settings["max_chunk_size"]
        overlap_size = self.chunk_settings["overlap_size"]
        min_chunk_size = self.chunk_settings["min_chunk_size"]

        for i, sentence in enumerate(sentences):
            sentence_length = len(sentence)

            # Check if adding this sentence would exceed max chunk size
            if current_length + sentence_length > max_chunk_size and current_chunk:
                # Create chunk from current sentences
                chunk_content = " ".join(current_chunk)

                if len(chunk_content) >= min_chunk_size:
                    chunk = self._create_chunk(
                        chunk_content, chunk_id, content, nlp_analysis
                    )
                    chunks.append(chunk)
                    chunk_id += 1

                # Start new chunk with overlap
                overlap_sentences = self._get_overlap_sentences(current_chunk, overlap_size)
                current_chunk = overlap_sentences + [sentence]
                current_length = sum(len(s) for s in current_chunk)
            else:
                current_chunk.append(sentence)
                current_length += sentence_length

        # Add final chunk
        if current_chunk:
            chunk_content = " ".join(current_chunk)
            if len(chunk_content) >= min_chunk_size:
                chunk = self._create_chunk(
                    chunk_content, chunk_id, content, nlp_analysis
                )
                chunks.append(chunk)

        return chunks

    def _split_into_sentences(self, content: str) -> List[str]:
        """Split content into sentences with Vietnamese-specific handling."""
        # Vietnamese sentence endings
        sentence_endings = r'[.!?]+(?:\s|$)'

        # Split by sentence endings
        sentences = re.split(sentence_endings, content)

        # Clean and filter sentences
        cleaned_sentences = []
        for sentence in sentences:
            sentence = sentence.strip()
            if len(sentence) > 10:  # Minimum sentence length
                cleaned_sentences.append(sentence)

        return cleaned_sentences

    def _get_overlap_sentences(self, sentences: List[str], overlap_size: int) -> List[str]:
        """Get overlap sentences for chunk continuity."""
        if not sentences:
            return []

        # Calculate how many sentences to include in overlap
        total_length = sum(len(s) for s in sentences)
        overlap_ratio = min(0.3, overlap_size / total_length)
        overlap_count = max(1, int(len(sentences) * overlap_ratio))

        return sentences[-overlap_count:]

    def _create_chunk(
        self,
        chunk_content: str,
        chunk_id: int,
        full_content: str,
        nlp_analysis: Dict[str, Any]
    ) -> Dict[str, Any]:
        """Create a chunk with metadata."""

        # Find chunk position in full content
        start_pos = full_content.find(chunk_content[:50])  # Use first 50 chars to find position
        end_pos = start_pos + len(chunk_content) if start_pos != -1 else len(chunk_content)

        # Extract entities specific to this chunk
        chunk_entities = self._extract_chunk_entities(chunk_content, nlp_analysis)

        # Assess chunk quality
        chunk_quality = self._assess_chunk_quality(chunk_content, chunk_entities)

        return {
            "chunk_id": chunk_id,
            "content": chunk_content,
            "start_position": max(0, start_pos),
            "end_position": end_pos,
            "word_count": len(chunk_content.split()),
            "character_count": len(chunk_content),
            "sentence_count": len(self._split_into_sentences(chunk_content)),
            "chunk_type": "semantic",
            "entities": chunk_entities,
            "quality_score": chunk_quality,
            "medical_relevance": self.nlp.assess_medical_relevance(chunk_content)
        }

    def _extract_chunk_entities(self, chunk_content: str, nlp_analysis: Dict[str, Any]) -> List[Dict[str, Any]]:
        """Extract entities specific to a chunk."""
        chunk_entities = []

        # Get entities from full analysis that fall within this chunk
        all_entities = nlp_analysis.get("enhanced_entities", [])

        for entity in all_entities:
            # Check if entity text appears in this chunk
            if entity["text"].lower() in chunk_content.lower():
                chunk_entities.append({
                    "text": entity["text"],
                    "type": entity["type"],
                    "confidence": entity["confidence"],
                    "standardized_text": entity.get("standardized_text", entity["text"])
                })

        return chunk_entities

    def _assess_chunk_quality(self, chunk_content: str, chunk_entities: List[Dict[str, Any]]) -> float:
        """Assess the quality of a chunk for vector embedding."""
        quality_score = 0.5  # Base score

        # Entity density
        entity_count = len(chunk_entities)
        word_count = len(chunk_content.split())
        entity_density = entity_count / max(1, word_count / 10)  # Entities per 10 words

        if entity_density > 0.5:
            quality_score += 0.2
        elif entity_density > 0.2:
            quality_score += 0.1

        # Content completeness (has complete sentences)
        if chunk_content.strip().endswith(('.', '!', '?')):
            quality_score += 0.1

        # Medical relevance
        medical_relevance = self.nlp.assess_medical_relevance(chunk_content)
        quality_score += medical_relevance * 0.2

        return min(1.0, quality_score)

    def _generate_simple_chunks(self, content: str) -> List[Dict[str, Any]]:
        """Generate simple fixed-size chunks as fallback."""
        chunks = []
        max_chunk_size = self.chunk_settings["max_chunk_size"]
        overlap_size = self.chunk_settings["overlap_size"]

        words = content.split()
        chunk_id = 0

        for i in range(0, len(words), max_chunk_size - overlap_size):
            chunk_words = words[i:i + max_chunk_size]
            chunk_content = " ".join(chunk_words)

            chunks.append({
                "chunk_id": chunk_id,
                "content": chunk_content,
                "start_position": i,
                "end_position": i + len(chunk_words),
                "word_count": len(chunk_words),
                "character_count": len(chunk_content),
                "chunk_type": "fixed",
                "entities": [],
                "quality_score": 0.5,
                "medical_relevance": self.nlp.assess_medical_relevance(chunk_content)
            })

            chunk_id += 1

        return chunks

    def _enrich_metadata(
        self,
        raw_item: Dict[str, Any],
        nlp_analysis: Dict[str, Any],
        quality_score: float
    ) -> Dict[str, Any]:
        """Enrich metadata for better vector retrieval."""

        base_metadata = raw_item.get("metadata", {}).copy()

        # Enhanced metadata
        enhanced_metadata = {
            **base_metadata,

            # Processing metadata
            "processing_version": "2.0.0",
            "processed_at": datetime.now(timezone.utc).isoformat(),
            "quality_score": quality_score,

            # Medical classification
            "medical_specialty": nlp_analysis.get("medical_specialty", "general"),
            "content_type": nlp_analysis.get("content_type", "article"),
            "medical_relevance": nlp_analysis["medical_relevance"],

            # Entity information
            "entity_count": len(nlp_analysis.get("enhanced_entities", [])),
            "entity_types": list(set(e["type"] for e in nlp_analysis.get("enhanced_entities", []))),
            "key_entities": [e["standardized_text"] for e in nlp_analysis.get("enhanced_entities", [])[:5]],

            # Content characteristics
            "word_count": nlp_analysis["word_count"],
            "has_temporal_info": bool(nlp_analysis.get("temporal_info", {}).get("treatment_duration")),
            "severity_level": nlp_analysis.get("severity_indicators", {}).get("severity_level", "low"),

            # Source authority
            "source_authority": self._calculate_source_authority(raw_item),

            # Retrieval optimization
            "search_keywords": self._generate_search_keywords(nlp_analysis),
            "semantic_tags": self._generate_semantic_tags(nlp_analysis)
        }

        return enhanced_metadata

    def _calculate_source_authority(self, raw_item: Dict[str, Any]) -> float:
        """Calculate source authority score."""
        source_type = raw_item.get("metadata", {}).get("source_type", "unknown")
        source_url = raw_item.get("source_url", "")

        authority_scores = {
            "government": 0.95,
            "hospital": 0.90,
            "medical_institution": 0.85,
            "university": 0.80,
            "news": 0.60,
            "blog": 0.40,
            "unknown": 0.30
        }

        base_authority = authority_scores.get(source_type, 0.30)

        # Boost for specific high-authority domains
        authority_domains = {
            "moh.gov.vn": 0.05,
            "vinmec.com": 0.05,
            "bachmai.edu.vn": 0.05,
            "choray.vn": 0.05
        }

        domain_boost = 0.0
        for domain, boost in authority_domains.items():
            if domain in source_url.lower():
                domain_boost = boost
                break

        return min(1.0, base_authority + domain_boost)

    def _generate_search_keywords(self, nlp_analysis: Dict[str, Any]) -> List[str]:
        """Generate search keywords for better retrieval."""
        keywords = set()

        # Add entity texts
        for entity in nlp_analysis.get("enhanced_entities", []):
            keywords.add(entity["standardized_text"].lower())
            keywords.add(entity["text"].lower())

        # Add key phrases
        for phrase in nlp_analysis.get("key_phrases", []):
            # Extract important words from phrases
            phrase_words = [w for w in phrase.lower().split() if len(w) > 3]
            keywords.update(phrase_words)

        # Add medical specialty
        specialty = nlp_analysis.get("medical_specialty")
        if specialty and specialty != "general":
            keywords.add(specialty)

        # Limit and clean keywords
        cleaned_keywords = []
        for keyword in keywords:
            if len(keyword) > 2 and keyword.isalpha():
                cleaned_keywords.append(keyword)

        return sorted(list(set(cleaned_keywords)))[:20]  # Limit to 20 keywords

    def _generate_semantic_tags(self, nlp_analysis: Dict[str, Any]) -> List[str]:
        """Generate semantic tags for content categorization."""
        tags = []

        # Medical specialty tag
        specialty = nlp_analysis.get("medical_specialty")
        if specialty and specialty != "general":
            tags.append(f"specialty:{specialty}")

        # Content type tag
        content_type = nlp_analysis.get("content_type", "article")
        tags.append(f"type:{content_type}")

        # Severity tag
        severity = nlp_analysis.get("severity_indicators", {}).get("severity_level", "low")
        tags.append(f"severity:{severity}")

        # Entity type tags
        entity_types = set(e["type"] for e in nlp_analysis.get("enhanced_entities", []))
        for entity_type in entity_types:
            tags.append(f"entity:{entity_type}")

        # Temporal tags
        temporal_info = nlp_analysis.get("temporal_info", {})
        if temporal_info.get("treatment_duration"):
            tags.append("has:treatment_duration")
        if temporal_info.get("age_groups"):
            tags.append("has:age_groups")

        return tags

    def _build_processed_item_with_chunks(
        self,
        raw_item: Dict[str, Any],
        standardized_content: str,
        chunks: List[Dict[str, Any]],
        enhanced_metadata: Dict[str, Any],
        nlp_analysis: Dict[str, Any]
    ) -> Dict[str, Any]:
        """Build the final processed item with chunks."""

        # Generate unique content ID
        content_id = self._generate_content_id(raw_item["source_url"])

        return {
            "content_id": content_id,
            "source_id": raw_item["source_id"],
            "source_url": raw_item["source_url"],
            "title": raw_item["title"],
            "content": standardized_content,
            "content_type": nlp_analysis.get("content_type", "article"),
            "language": raw_item.get("language", "vi"),
            "published_at": raw_item.get("published_at"),
            "crawled_at": raw_item["crawled_at"],
            "processed_at": datetime.now(timezone.utc).isoformat(),

            # Enhanced metadata
            "metadata": enhanced_metadata,

            # NLP analysis results
            "medical_specialty": nlp_analysis.get("medical_specialty", "general"),
            "medical_relevance": nlp_analysis["medical_relevance"],
            "quality_score": enhanced_metadata["quality_score"],

            # Entities and relationships
            "entities": nlp_analysis.get("enhanced_entities", []),
            "key_phrases": nlp_analysis.get("key_phrases", []),

            # Chunking for vector embeddings
            "chunks": chunks,
            "chunk_count": len(chunks),

            # Retrieval optimization
            "search_keywords": enhanced_metadata["search_keywords"],
            "semantic_tags": enhanced_metadata["semantic_tags"]
        }

    def _generate_content_id(self, source_url: str) -> str:
        """Generate unique content ID."""
        timestamp = datetime.now(timezone.utc).strftime("%Y%m%d_%H%M%S")
        url_hash = hashlib.md5(source_url.encode('utf-8')).hexdigest()[:8]
        return f"content_{timestamp}_{url_hash}"

    def process_batch_advanced(self, raw_items: List[Dict[str, Any]]) -> List[Dict[str, Any]]:
        """Process a batch of items with advanced processing."""
        logger.info(f"Advanced processing batch of {len(raw_items)} items")

        processed_items = []
        for item in raw_items:
            processed = self.process_content_advanced(item)
            if processed:
                processed_items.append(processed)

        logger.info(
            f"Advanced batch processing completed: {len(processed_items)} processed, "
            f"{self.stats['rejected_items']} rejected, {self.stats['duplicate_items']} duplicates, "
            f"{self.stats['generated_chunks']} total chunks"
        )

        return processed_items

    def get_processing_stats(self) -> Dict[str, Any]:
        """Get advanced processing statistics."""
        total_processed = (self.stats["processed_items"] +
                          self.stats["rejected_items"] +
                          self.stats["duplicate_items"])

        return {
            **self.stats,
            "total_items": total_processed,
            "success_rate": self.stats["processed_items"] / max(1, total_processed),
            "average_chunks_per_item": (self.stats["generated_chunks"] /
                                       max(1, self.stats["processed_items"])),
            "unique_content_fingerprints": len(self.content_fingerprints),
            "unique_semantic_hashes": len(self.semantic_hashes)
        }

    def reset_stats(self):
        """Reset processing statistics."""
        self.stats = {
            "processed_items": 0,
            "generated_chunks": 0,
            "rejected_items": 0,
            "duplicate_items": 0,
            "enhanced_metadata": 0
        }
        self.content_fingerprints.clear()
        self.semantic_hashes.clear()
        logger.info("Advanced processing statistics reset")
