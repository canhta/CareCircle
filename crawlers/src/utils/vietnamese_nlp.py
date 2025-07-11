"""
Vietnamese NLP processing utilities for healthcare content.
"""

import re
import unicodedata
from typing import List, Dict, Any, Optional, Tuple
from loguru import logger

try:
    import underthesea
    UNDERTHESEA_AVAILABLE = True
except ImportError:
    UNDERTHESEA_AVAILABLE = False
    logger.warning("underthesea not available, some NLP features will be disabled")

try:
    import pyvi
    PYVI_AVAILABLE = True
except ImportError:
    PYVI_AVAILABLE = False
    logger.warning("pyvi not available, some NLP features will be disabled")


class VietnameseNLP:
    """Vietnamese NLP processing for healthcare content."""
    
    def __init__(self, settings: Dict[str, Any]):
        """
        Initialize Vietnamese NLP processor.
        
        Args:
            settings: NLP configuration settings
        """
        self.settings = settings
        self.medical_terms = self._load_medical_terms()
        self.stop_words = self._load_stop_words()
        
        logger.info("Initialized Vietnamese NLP processor")
    
    def _load_medical_terms(self) -> Dict[str, List[str]]:
        """Load Vietnamese medical terminology dictionary."""
        return {
            "diseases": [
                "tiểu đường", "huyết áp", "tim mạch", "ung thư", "gan", "thận",
                "phổi", "dạ dày", "ruột", "xương khớp", "da liễu", "mắt",
                "tai mũi họng", "thần kinh", "tâm thần", "nội tiết", "sản phụ khoa",
                "nhi khoa", "lão khoa", "cấp cứu", "gây mê", "phẫu thuật",
                "covid-19", "cúm", "sốt xuất huyết", "sốt rét", "lao", "viêm gan",
                "đột quỵ", "nhồi máu cơ tim", "suy tim", "hen suyễn", "copd"
            ],
            "symptoms": [
                "đau đầu", "sốt", "ho", "khó thở", "buồn nôn", "nôn", "tiêu chảy",
                "táo bón", "đau bụng", "đau ngực", "mệt mỏi", "chóng mặt",
                "mất ngủ", "lo âu", "trầm cảm", "đau cơ", "đau khớp",
                "phát ban", "ngứa", "sưng", "viêm", "nhiễm trùng"
            ],
            "medications": [
                "paracetamol", "aspirin", "ibuprofen", "amoxicillin", "metformin",
                "amlodipine", "losartan", "atorvastatin", "omeprazole", "insulin",
                "thuốc kháng sinh", "thuốc giảm đau", "thuốc hạ sốt", "thuốc ho",
                "thuốc dị ứng", "thuốc tim mạch", "thuốc tiểu đường", "vitamin"
            ],
            "procedures": [
                "xét nghiệm", "chụp x-quang", "siêu âm", "ct scan", "mri",
                "nội soi", "sinh thiết", "phẫu thuật", "tiêm", "truyền dịch",
                "thở máy", "lọc máu", "ghép tạng", "hóa trị", "xạ trị"
            ]
        }
    
    def _load_stop_words(self) -> List[str]:
        """Load Vietnamese stop words."""
        return [
            "và", "của", "có", "là", "được", "trong", "với", "để", "cho", "từ",
            "về", "theo", "như", "khi", "nếu", "mà", "hay", "hoặc", "nhưng",
            "vì", "do", "bởi", "tại", "trên", "dưới", "giữa", "sau", "trước",
            "này", "đó", "những", "các", "một", "hai", "ba", "nhiều", "ít"
        ]
    
    def normalize_text(self, text: str) -> str:
        """
        Normalize Vietnamese text.
        
        Args:
            text: Input text
            
        Returns:
            Normalized text
        """
        if not text:
            return ""
        
        # Unicode normalization
        text = unicodedata.normalize('NFC', text)
        
        # Remove extra whitespace
        text = re.sub(r'\s+', ' ', text)
        
        # Remove special characters but keep Vietnamese diacritics
        text = re.sub(r'[^\w\s\u00C0-\u1EF9]', ' ', text)
        
        # Remove extra spaces
        text = re.sub(r'\s+', ' ', text).strip()
        
        return text
    
    def tokenize(self, text: str) -> List[str]:
        """
        Tokenize Vietnamese text.
        
        Args:
            text: Input text
            
        Returns:
            List of tokens
        """
        if not UNDERTHESEA_AVAILABLE:
            # Fallback to simple word splitting
            return self.normalize_text(text).lower().split()
        
        try:
            tokens = underthesea.word_tokenize(text)
            return [token.lower() for token in tokens if token.strip()]
        except Exception as e:
            logger.warning(f"Tokenization failed: {e}")
            return self.normalize_text(text).lower().split()
    
    def extract_medical_entities(self, text: str) -> List[Dict[str, Any]]:
        """
        Extract medical entities from Vietnamese text.
        
        Args:
            text: Input text
            
        Returns:
            List of extracted entities with types and confidence scores
        """
        entities = []
        text_lower = text.lower()
        
        # Extract entities by category
        for category, terms in self.medical_terms.items():
            for term in terms:
                if term in text_lower:
                    # Find all occurrences
                    start = 0
                    while True:
                        pos = text_lower.find(term, start)
                        if pos == -1:
                            break
                        
                        entities.append({
                            "text": term,
                            "type": category.rstrip('s'),  # Remove plural 's'
                            "start": pos,
                            "end": pos + len(term),
                            "confidence": self._calculate_confidence(term, text, pos)
                        })
                        
                        start = pos + 1
        
        # Remove duplicates and sort by position
        entities = self._deduplicate_entities(entities)
        entities.sort(key=lambda x: x["start"])
        
        return entities
    
    def _calculate_confidence(self, term: str, text: str, position: int) -> float:
        """Calculate confidence score for entity extraction."""
        # Simple confidence calculation based on context
        confidence = 0.7  # Base confidence
        
        # Check if term is surrounded by word boundaries
        if position > 0 and text[position - 1].isalnum():
            confidence -= 0.1
        if position + len(term) < len(text) and text[position + len(term)].isalnum():
            confidence -= 0.1
        
        # Boost confidence for longer terms
        if len(term) > 10:
            confidence += 0.1
        
        # Boost confidence for medical context
        context_window = 50
        start = max(0, position - context_window)
        end = min(len(text), position + len(term) + context_window)
        context = text[start:end].lower()
        
        medical_context_words = ["bệnh", "thuốc", "điều trị", "khám", "chữa", "y tế", "sức khỏe"]
        for word in medical_context_words:
            if word in context:
                confidence += 0.05
        
        return min(1.0, max(0.0, confidence))
    
    def _deduplicate_entities(self, entities: List[Dict[str, Any]]) -> List[Dict[str, Any]]:
        """Remove duplicate entities."""
        seen = set()
        unique_entities = []
        
        for entity in entities:
            key = (entity["text"], entity["start"], entity["end"])
            if key not in seen:
                seen.add(key)
                unique_entities.append(entity)
        
        return unique_entities
    
    def assess_medical_relevance(self, text: str) -> float:
        """
        Assess how relevant the text is to medical/healthcare content.
        
        Args:
            text: Input text
            
        Returns:
            Relevance score between 0 and 1
        """
        if not text:
            return 0.0
        
        text_lower = text.lower()
        total_words = len(self.tokenize(text))
        
        if total_words == 0:
            return 0.0
        
        # Count medical terms
        medical_word_count = 0
        for category, terms in self.medical_terms.items():
            for term in terms:
                medical_word_count += text_lower.count(term)
        
        # Calculate relevance score
        relevance = medical_word_count / total_words
        
        # Boost score for medical keywords
        medical_keywords = [
            "y tế", "sức khỏe", "bệnh viện", "phòng khám", "bác sĩ", "điều dưỡng",
            "chẩn đoán", "điều trị", "phòng bệnh", "vaccine", "tiêm chủng"
        ]
        
        keyword_count = sum(1 for keyword in medical_keywords if keyword in text_lower)
        relevance += keyword_count * 0.1
        
        return min(1.0, relevance)
    
    def clean_medical_content(self, text: str) -> str:
        """
        Clean and prepare medical content for processing.
        
        Args:
            text: Raw medical content
            
        Returns:
            Cleaned content
        """
        if not text:
            return ""
        
        # Normalize text
        text = self.normalize_text(text)
        
        # Remove common non-medical content patterns
        patterns_to_remove = [
            r'quảng cáo.*?(?=\n|$)',  # Advertisement text
            r'liên hệ.*?(?=\n|$)',   # Contact information
            r'bản quyền.*?(?=\n|$)', # Copyright text
            r'cookie.*?(?=\n|$)',    # Cookie notices
            r'đăng ký.*?(?=\n|$)',   # Registration prompts
        ]
        
        for pattern in patterns_to_remove:
            text = re.sub(pattern, '', text, flags=re.IGNORECASE)
        
        # Remove extra whitespace
        text = re.sub(r'\n\s*\n', '\n\n', text)
        text = re.sub(r' +', ' ', text)
        
        return text.strip()
    
    def extract_key_phrases(self, text: str, max_phrases: int = 10) -> List[str]:
        """
        Extract key medical phrases from text.
        
        Args:
            text: Input text
            max_phrases: Maximum number of phrases to extract
            
        Returns:
            List of key phrases
        """
        if not text:
            return []
        
        # Simple phrase extraction based on medical terms
        phrases = []
        text_lower = text.lower()
        
        # Extract phrases containing medical terms
        sentences = re.split(r'[.!?]+', text)
        
        for sentence in sentences:
            sentence = sentence.strip()
            if len(sentence) < 10:  # Skip very short sentences
                continue
            
            # Check if sentence contains medical terms
            medical_term_count = 0
            for category, terms in self.medical_terms.items():
                for term in terms:
                    if term in sentence.lower():
                        medical_term_count += 1
            
            if medical_term_count > 0:
                # Extract meaningful phrases (noun phrases, etc.)
                phrase = sentence[:100] + "..." if len(sentence) > 100 else sentence
                phrases.append(phrase)
        
        # Sort by medical relevance and return top phrases
        phrases.sort(key=lambda p: self.assess_medical_relevance(p), reverse=True)
        return phrases[:max_phrases]
    
    def get_content_summary(self, text: str) -> Dict[str, Any]:
        """
        Generate a comprehensive summary of the content.
        
        Args:
            text: Input text
            
        Returns:
            Content summary with various metrics
        """
        if not text:
            return {
                "word_count": 0,
                "medical_relevance": 0.0,
                "entities": [],
                "key_phrases": [],
                "language": "vi"
            }
        
        return {
            "word_count": len(self.tokenize(text)),
            "medical_relevance": self.assess_medical_relevance(text),
            "entities": self.extract_medical_entities(text),
            "key_phrases": self.extract_key_phrases(text),
            "language": "vi",
            "cleaned_content": self.clean_medical_content(text)
        }
