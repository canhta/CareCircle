#!/usr/bin/env python3
"""
Vietnamese NLP Service for CareCircle Healthcare Platform
Provides Vietnamese medical text processing, entity extraction, and terminology analysis
"""

import os
import json
import logging
from datetime import datetime
from flask import Flask, request, jsonify
from flask_cors import CORS
import redis
import underthesea
from pyvi import ViTokenizer
import structlog

# Configure structured logging
structlog.configure(
    processors=[
        structlog.stdlib.filter_by_level,
        structlog.stdlib.add_logger_name,
        structlog.stdlib.add_log_level,
        structlog.stdlib.PositionalArgumentsFormatter(),
        structlog.processors.TimeStamper(fmt="iso"),
        structlog.processors.StackInfoRenderer(),
        structlog.processors.format_exc_info,
        structlog.processors.UnicodeDecoder(),
        structlog.processors.JSONRenderer()
    ],
    context_class=dict,
    logger_factory=structlog.stdlib.LoggerFactory(),
    wrapper_class=structlog.stdlib.BoundLogger,
    cache_logger_on_first_use=True,
)

logger = structlog.get_logger()

# Initialize Flask app
app = Flask(__name__)
CORS(app)

# Initialize Redis connection
redis_client = None
try:
    redis_url = os.getenv('REDIS_URL', 'redis://localhost:6379/6')
    redis_client = redis.from_url(redis_url, decode_responses=True)
    redis_client.ping()
    logger.info("Redis connection established", redis_url=redis_url)
except Exception as e:
    logger.warning("Redis connection failed, caching disabled", error=str(e))

class VietnameseNLPProcessor:
    """Vietnamese NLP processing for medical text"""
    
    def __init__(self):
        self.medical_terms = self._load_medical_terms()
        self.traditional_medicine_terms = self._load_traditional_medicine_terms()
        
    def _load_medical_terms(self):
        """Load Vietnamese medical terminology"""
        return {
            'symptoms': [
                'đau đầu', 'sốt', 'ho', 'khó thở', 'mệt mỏi', 'chóng mặt',
                'buồn nôn', 'tiêu chảy', 'táo bón', 'đau bụng', 'đau lưng',
                'đau ngực', 'tim đập nhanh', 'huyết áp cao', 'huyết áp thấp'
            ],
            'diseases': [
                'cảm cúm', 'viêm phổi', 'tiểu đường', 'cao huyết áp',
                'bệnh tim', 'đột quỵ', 'ung thư', 'viêm gan', 'suy thận'
            ],
            'medications': [
                'paracetamol', 'aspirin', 'ibuprofen', 'amoxicillin',
                'metformin', 'insulin', 'thuốc hạ áp', 'thuốc kháng sinh'
            ],
            'body_parts': [
                'đầu', 'mắt', 'tai', 'mũi', 'miệng', 'cổ', 'vai', 'tay',
                'ngực', 'bụng', 'lưng', 'chân', 'tim', 'phổi', 'gan', 'thận'
            ]
        }
    
    def _load_traditional_medicine_terms(self):
        """Load Vietnamese traditional medicine terminology"""
        return {
            'herbs': [
                'gừng', 'nghệ', 'tỏi', 'hành', 'lá lốt', 'rau má',
                'trà xanh', 'cam thảo', 'đông quai', 'nhân sâm'
            ],
            'treatments': [
                'châm cứu', 'bấm huyệt', 'xoa bóp', 'giác hơi',
                'thuốc nam', 'đông y', 'thảo dược'
            ],
            'concepts': [
                'âm dương', 'ngũ hành', 'khí huyết', 'kinh lạc',
                'tạng phủ', 'phong hàn thấp'
            ]
        }
    
    def tokenize_text(self, text):
        """Tokenize Vietnamese text"""
        try:
            # Use underthesea for word segmentation
            tokens = underthesea.word_tokenize(text)
            return {
                'tokens': tokens,
                'token_count': len(tokens),
                'method': 'underthesea'
            }
        except Exception as e:
            logger.error("Tokenization failed", error=str(e))
            # Fallback to pyvi
            try:
                tokens = ViTokenizer.tokenize(text).split()
                return {
                    'tokens': tokens,
                    'token_count': len(tokens),
                    'method': 'pyvi_fallback'
                }
            except Exception as e2:
                logger.error("Fallback tokenization failed", error=str(e2))
                return {
                    'tokens': text.split(),
                    'token_count': len(text.split()),
                    'method': 'simple_split'
                }
    
    def extract_medical_entities(self, text):
        """Extract medical entities from Vietnamese text"""
        entities = []
        text_lower = text.lower()
        
        # Extract symptoms
        for symptom in self.medical_terms['symptoms']:
            if symptom in text_lower:
                entities.append({
                    'text': symptom,
                    'type': 'symptom',
                    'confidence': 0.9,
                    'start_pos': text_lower.find(symptom),
                    'end_pos': text_lower.find(symptom) + len(symptom)
                })
        
        # Extract diseases
        for disease in self.medical_terms['diseases']:
            if disease in text_lower:
                entities.append({
                    'text': disease,
                    'type': 'disease',
                    'confidence': 0.9,
                    'start_pos': text_lower.find(disease),
                    'end_pos': text_lower.find(disease) + len(disease)
                })
        
        # Extract medications
        for medication in self.medical_terms['medications']:
            if medication in text_lower:
                entities.append({
                    'text': medication,
                    'type': 'medication',
                    'confidence': 0.85,
                    'start_pos': text_lower.find(medication),
                    'end_pos': text_lower.find(medication) + len(medication)
                })
        
        # Extract traditional medicine terms
        for herb in self.traditional_medicine_terms['herbs']:
            if herb in text_lower:
                entities.append({
                    'text': herb,
                    'type': 'traditional_herb',
                    'confidence': 0.8,
                    'start_pos': text_lower.find(herb),
                    'end_pos': text_lower.find(herb) + len(herb)
                })
        
        for treatment in self.traditional_medicine_terms['treatments']:
            if treatment in text_lower:
                entities.append({
                    'text': treatment,
                    'type': 'traditional_treatment',
                    'confidence': 0.8,
                    'start_pos': text_lower.find(treatment),
                    'end_pos': text_lower.find(treatment) + len(treatment)
                })
        
        return entities
    
    def analyze_sentiment(self, text):
        """Analyze sentiment of Vietnamese medical text"""
        try:
            # Use underthesea sentiment analysis
            sentiment = underthesea.sentiment(text)
            return {
                'sentiment': sentiment,
                'confidence': 0.7,  # Basic confidence score
                'method': 'underthesea'
            }
        except Exception as e:
            logger.error("Sentiment analysis failed", error=str(e))
            return {
                'sentiment': 'neutral',
                'confidence': 0.5,
                'method': 'fallback'
            }
    
    def detect_urgency(self, text):
        """Detect urgency indicators in Vietnamese medical text"""
        urgency_keywords = [
            'cấp cứu', 'khẩn cấp', 'nguy hiểm', 'nghiêm trọng',
            'đau dữ dội', 'khó thở nặng', 'mất ý thức', 'co giật',
            'xuất huyết', 'đau tim', 'đột quỵ', 'ngộ độc'
        ]
        
        text_lower = text.lower()
        detected_keywords = []
        urgency_score = 0.0
        
        for keyword in urgency_keywords:
            if keyword in text_lower:
                detected_keywords.append(keyword)
                urgency_score += 0.2
        
        urgency_level = min(urgency_score, 1.0)
        
        return {
            'urgency_level': urgency_level,
            'urgency_keywords': detected_keywords,
            'is_emergency': urgency_level >= 0.8
        }

# Initialize NLP processor
nlp_processor = VietnameseNLPProcessor()

@app.route('/health', methods=['GET'])
def health_check():
    """Health check endpoint"""
    return jsonify({
        'status': 'healthy',
        'service': 'vietnamese-nlp',
        'timestamp': datetime.utcnow().isoformat(),
        'redis_connected': redis_client is not None
    })

@app.route('/tokenize', methods=['POST'])
def tokenize():
    """Tokenize Vietnamese text"""
    try:
        data = request.get_json()
        text = data.get('text', '')
        
        if not text:
            return jsonify({'error': 'Text is required'}), 400
        
        # Check cache
        cache_key = f"tokenize:{hash(text)}"
        if redis_client:
            cached_result = redis_client.get(cache_key)
            if cached_result:
                return jsonify(json.loads(cached_result))
        
        result = nlp_processor.tokenize_text(text)
        
        # Cache result
        if redis_client:
            redis_client.setex(cache_key, 3600, json.dumps(result))
        
        return jsonify(result)
    
    except Exception as e:
        logger.error("Tokenization endpoint error", error=str(e))
        return jsonify({'error': 'Tokenization failed'}), 500

@app.route('/extract-entities', methods=['POST'])
def extract_entities():
    """Extract medical entities from Vietnamese text"""
    try:
        data = request.get_json()
        text = data.get('text', '')
        
        if not text:
            return jsonify({'error': 'Text is required'}), 400
        
        # Check cache
        cache_key = f"entities:{hash(text)}"
        if redis_client:
            cached_result = redis_client.get(cache_key)
            if cached_result:
                return jsonify(json.loads(cached_result))
        
        entities = nlp_processor.extract_medical_entities(text)
        urgency = nlp_processor.detect_urgency(text)
        
        result = {
            'entities': entities,
            'entity_count': len(entities),
            'urgency_analysis': urgency,
            'processed_at': datetime.utcnow().isoformat()
        }
        
        # Cache result
        if redis_client:
            redis_client.setex(cache_key, 1800, json.dumps(result))
        
        return jsonify(result)
    
    except Exception as e:
        logger.error("Entity extraction endpoint error", error=str(e))
        return jsonify({'error': 'Entity extraction failed'}), 500

@app.route('/analyze', methods=['POST'])
def analyze_text():
    """Comprehensive Vietnamese medical text analysis"""
    try:
        data = request.get_json()
        text = data.get('text', '')
        
        if not text:
            return jsonify({'error': 'Text is required'}), 400
        
        # Check cache
        cache_key = f"analyze:{hash(text)}"
        if redis_client:
            cached_result = redis_client.get(cache_key)
            if cached_result:
                return jsonify(json.loads(cached_result))
        
        # Perform comprehensive analysis
        tokens = nlp_processor.tokenize_text(text)
        entities = nlp_processor.extract_medical_entities(text)
        sentiment = nlp_processor.analyze_sentiment(text)
        urgency = nlp_processor.detect_urgency(text)
        
        result = {
            'tokenization': tokens,
            'entities': entities,
            'sentiment': sentiment,
            'urgency_analysis': urgency,
            'summary': {
                'token_count': tokens['token_count'],
                'entity_count': len(entities),
                'has_medical_terms': len(entities) > 0,
                'is_emergency': urgency['is_emergency'],
                'sentiment_score': sentiment['sentiment']
            },
            'processed_at': datetime.utcnow().isoformat()
        }
        
        # Cache result
        if redis_client:
            redis_client.setex(cache_key, 1800, json.dumps(result))
        
        return jsonify(result)
    
    except Exception as e:
        logger.error("Text analysis endpoint error", error=str(e))
        return jsonify({'error': 'Text analysis failed'}), 500

if __name__ == '__main__':
    port = int(os.getenv('PORT', 8080))
    debug = os.getenv('FLASK_ENV') == 'development'
    
    logger.info("Starting Vietnamese NLP service", port=port, debug=debug)
    app.run(host='0.0.0.0', port=port, debug=debug)
