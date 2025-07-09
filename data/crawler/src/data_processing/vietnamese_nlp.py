"""
Vietnamese Language Processing for CareCircle Healthcare Data Crawler.

This module provides specialized text processing functions for Vietnamese language,
including diacritics normalization, tokenization, and healthcare terminology extraction.
"""

import re
import logging
from typing import Dict, List, Set, Tuple, Optional

# Import Vietnamese NLP libraries
try:
    import underthesea
    from pyvi import ViTokenizer, ViPosTagger
    VIETNAMESE_LIBS_AVAILABLE = True
except ImportError:
    VIETNAMESE_LIBS_AVAILABLE = False

# Configure logger
logger = logging.getLogger(__name__)


class VietnameseTextProcessor:
    """
    Processor for Vietnamese text with healthcare domain focus.
    
    This class provides methods for processing Vietnamese text, including
    tokenization, normalization, and healthcare-specific processing.
    """
    
    def __init__(self, config: Optional[Dict] = None):
        """
        Initialize the Vietnamese text processor.
        
        Args:
            config: Configuration dictionary
        """
        self.config = config or {}
        
        # Check if Vietnamese libraries are available
        if not VIETNAMESE_LIBS_AVAILABLE:
            logger.warning("Vietnamese NLP libraries not available. Some features will be limited.")
        
        # Load healthcare terminology if available
        self.medical_terms = self._load_medical_terms()
        
        # Initialize stop words
        self.stop_words = self._load_stop_words()
    
    def _load_medical_terms(self) -> Dict[str, str]:
        """
        Load Vietnamese medical terminology.
        
        Returns:
            Dictionary mapping Vietnamese medical terms to categories
        """
        # This would typically load from a file or database
        # For now, we'll include a small sample of common terms
        return {
            "đau đầu": "symptom",
            "sốt": "symptom",
            "ho": "symptom",
            "khó thở": "symptom",
            "tiểu đường": "condition",
            "cao huyết áp": "condition",
            "ung thư": "condition",
            "viêm phổi": "condition",
            "paracetamol": "medication",
            "amoxicillin": "medication",
            "aspirin": "medication",
            "insulin": "medication",
            "bệnh viện": "facility",
            "phòng khám": "facility",
            "bác sĩ": "profession",
            "y tá": "profession",
            "xét nghiệm": "procedure",
            "chụp x-quang": "procedure",
            "siêu âm": "procedure",
            "tiêm chủng": "procedure",
        }
    
    def _load_stop_words(self) -> Set[str]:
        """
        Load Vietnamese stop words.
        
        Returns:
            Set of Vietnamese stop words
        """
        # Common Vietnamese stop words
        basic_stop_words = {
            "và", "hoặc", "của", "là", "trong", "có", "được", "không", "này", "đó",
            "các", "những", "một", "với", "cho", "từ", "đến", "về", "như", "để",
            "theo", "tại", "bởi", "vì", "nếu", "khi", "mà", "thì", "còn", "nhưng",
            "cũng", "nên", "vẫn", "đã", "sẽ", "rằng", "tuy", "vào", "ra", "tới",
            "thế", "nào", "rất", "quá", "cần", "phải", "trên", "dưới", "đang", "sau",
            "trước", "bị", "được", "làm", "thực hiện", "thực", "hiện", "đây", "kia",
        }
        
        return basic_stop_words
    
    def normalize_diacritics(self, text: str) -> str:
        """
        Normalize Vietnamese diacritics to ensure consistency.
        
        Args:
            text: Input Vietnamese text
            
        Returns:
            Normalized text with consistent diacritics
        """
        # Common diacritic normalization patterns
        normalization_patterns = [
            # Normalize different forms of the same character
            (r'òa', 'oà'), (r'óa', 'oá'), (r'ỏa', 'oả'), (r'õa', 'oã'), (r'ọa', 'oạ'),
            (r'òe', 'oè'), (r'óe', 'oé'), (r'ỏe', 'oẻ'), (r'õe', 'oẽ'), (r'ọe', 'oẹ'),
            (r'ùy', 'uỳ'), (r'úy', 'uý'), (r'ủy', 'uỷ'), (r'ũy', 'uỹ'), (r'ụy', 'uỵ'),
            # Normalize common typing errors
            (r'ă', 'ă'), (r'â', 'â'), (r'ê', 'ê'), (r'ô', 'ô'), (r'ơ', 'ơ'), (r'ư', 'ư'),
        ]
        
        normalized_text = text
        for pattern, replacement in normalization_patterns:
            normalized_text = re.sub(pattern, replacement, normalized_text)
        
        return normalized_text
    
    def tokenize(self, text: str) -> List[str]:
        """
        Tokenize Vietnamese text.
        
        Args:
            text: Input Vietnamese text
            
        Returns:
            List of tokens
        """
        if VIETNAMESE_LIBS_AVAILABLE:
            # Use underthesea for better Vietnamese tokenization
            try:
                tokens = underthesea.word_tokenize(text)
                return tokens
            except Exception as e:
                logger.warning(f"Error using underthesea tokenizer: {str(e)}")
                # Fall back to ViTokenizer
                try:
                    tokenized_text = ViTokenizer.tokenize(text)
                    return tokenized_text.split()
                except Exception as e2:
                    logger.warning(f"Error using ViTokenizer: {str(e2)}")
        
        # Fallback to basic whitespace tokenization
        return text.split()
    
    def remove_stop_words(self, tokens: List[str]) -> List[str]:
        """
        Remove Vietnamese stop words from a list of tokens.
        
        Args:
            tokens: List of Vietnamese tokens
            
        Returns:
            List of tokens with stop words removed
        """
        return [token for token in tokens if token.lower() not in self.stop_words]
    
    def extract_medical_terms(self, text: str) -> List[Dict[str, str]]:
        """
        Extract medical terminology from Vietnamese text.
        
        Args:
            text: Input Vietnamese text
            
        Returns:
            List of dictionaries containing medical terms and their categories
        """
        extracted_terms = []
        text_lower = text.lower()
        
        # Look for medical terms in the text
        for term, category in self.medical_terms.items():
            if term in text_lower:
                # Find all occurrences
                for match in re.finditer(r'\b' + re.escape(term) + r'\b', text_lower):
                    start, end = match.span()
                    # Get some context around the term
                    context_start = max(0, start - 50)
                    context_end = min(len(text), end + 50)
                    context = text[context_start:context_end]
                    
                    extracted_terms.append({
                        'term': term,
                        'category': category,
                        'position': start,
                        'context': context
                    })
        
        return extracted_terms
    
    def pos_tag(self, text: str) -> List[Tuple[str, str]]:
        """
        Perform part-of-speech tagging on Vietnamese text.
        
        Args:
            text: Input Vietnamese text
            
        Returns:
            List of (token, pos_tag) tuples
        """
        if not VIETNAMESE_LIBS_AVAILABLE:
            logger.warning("Vietnamese NLP libraries not available for POS tagging")
            return []
        
        try:
            # Use ViPosTagger for POS tagging
            tokenized_text = ViTokenizer.tokenize(text)
            tags = ViPosTagger.postagging(tokenized_text)
            
            # Combine tokens and tags
            return list(zip(tags[0], tags[1]))
        except Exception as e:
            logger.warning(f"Error during POS tagging: {str(e)}")
            return []
    
    def extract_named_entities(self, text: str) -> List[Dict[str, str]]:
        """
        Extract named entities from Vietnamese text.
        
        Args:
            text: Input Vietnamese text
            
        Returns:
            List of dictionaries containing named entities and their types
        """
        if not VIETNAMESE_LIBS_AVAILABLE:
            logger.warning("Vietnamese NLP libraries not available for NER")
            return []
        
        try:
            # Use underthesea for named entity recognition
            entities = underthesea.ner(text)
            
            # Process and format entities
            result = []
            current_entity = {'text': '', 'type': '', 'position': -1}
            
            for i, (token, tag) in enumerate(entities):
                if tag.startswith('B-'):
                    # Beginning of a new entity
                    if current_entity['text']:
                        result.append(current_entity)
                    
                    entity_type = tag[2:]  # Remove B- prefix
                    current_entity = {'text': token, 'type': entity_type, 'position': i}
                
                elif tag.startswith('I-') and current_entity['text']:
                    # Inside an entity
                    current_entity['text'] += ' ' + token
                
                elif current_entity['text']:
                    # End of entity
                    result.append(current_entity)
                    current_entity = {'text': '', 'type': '', 'position': -1}
            
            # Add the last entity if exists
            if current_entity['text']:
                result.append(current_entity)
            
            return result
        
        except Exception as e:
            logger.warning(f"Error during named entity extraction: {str(e)}")
            return []
    
    def clean_text(self, text: str) -> str:
        """
        Clean Vietnamese text by removing unwanted characters and normalizing.
        
        Args:
            text: Input Vietnamese text
            
        Returns:
            Cleaned text
        """
        # Normalize whitespace
        text = re.sub(r'\s+', ' ', text).strip()
        
        # Normalize diacritics
        text = self.normalize_diacritics(text)
        
        # Remove URLs
        text = re.sub(r'https?://\S+|www\.\S+', '', text)
        
        # Remove email addresses
        text = re.sub(r'\S+@\S+', '', text)
        
        # Remove phone numbers
        text = re.sub(r'\b\d{10,11}\b', '', text)
        
        # Remove extra punctuation
        text = re.sub(r'([.!?])\1+', r'\1', text)
        
        # Normalize whitespace again after all replacements
        text = re.sub(r'\s+', ' ', text).strip()
        
        return text
    
    def segment_sentences(self, text: str) -> List[str]:
        """
        Segment Vietnamese text into sentences.
        
        Args:
            text: Input Vietnamese text
            
        Returns:
            List of sentences
        """
        if VIETNAMESE_LIBS_AVAILABLE:
            try:
                # Use underthesea for sentence segmentation
                return underthesea.sent_tokenize(text)
            except Exception as e:
                logger.warning(f"Error using underthesea sentence tokenizer: {str(e)}")
        
        # Fallback to basic sentence splitting
        # Vietnamese uses the same sentence terminators as English
        sentences = re.split(r'(?<=[.!?])\s+', text)
        return [s.strip() for s in sentences if s.strip()]
    
    def process_text(self, text: str) -> Dict[str, any]:
        """
        Process Vietnamese text with all available tools.
        
        Args:
            text: Input Vietnamese text
            
        Returns:
            Dictionary containing processed text data
        """
        # Clean the text
        cleaned_text = self.clean_text(text)
        
        # Segment into sentences
        sentences = self.segment_sentences(cleaned_text)
        
        # Tokenize
        tokens = self.tokenize(cleaned_text)
        
        # Remove stop words
        filtered_tokens = self.remove_stop_words(tokens)
        
        # Extract medical terms
        medical_terms = self.extract_medical_terms(cleaned_text)
        
        # Extract named entities if available
        named_entities = self.extract_named_entities(cleaned_text) if VIETNAMESE_LIBS_AVAILABLE else []
        
        return {
            'cleaned_text': cleaned_text,
            'sentences': sentences,
            'tokens': tokens,
            'filtered_tokens': filtered_tokens,
            'medical_terms': medical_terms,
            'named_entities': named_entities,
            'sentence_count': len(sentences),
            'token_count': len(tokens),
        } 