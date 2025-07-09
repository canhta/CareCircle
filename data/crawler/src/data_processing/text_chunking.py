"""
Text Chunking for Vector Database Preparation.

This module provides functions for chunking text into appropriate sizes
for embedding and storage in a vector database.
"""

import logging
import re
from typing import Dict, List, Any, Optional, Tuple

# Configure logger
logger = logging.getLogger(__name__)


class TextChunker:
    """
    Chunker for preparing text for vector database storage.
    
    This class provides methods for chunking text into appropriate sizes
    for embedding generation and vector database storage, with a focus
    on maintaining semantic coherence.
    """
    
    def __init__(
        self,
        chunk_size: int = 512,
        chunk_overlap: int = 50,
        min_chunk_size: int = 100,
        respect_sentences: bool = True,
        respect_paragraphs: bool = True,
    ):
        """
        Initialize the text chunker.
        
        Args:
            chunk_size: Target size of each chunk in characters
            chunk_overlap: Number of characters to overlap between chunks
            min_chunk_size: Minimum size for a valid chunk
            respect_sentences: Whether to avoid breaking sentences across chunks
            respect_paragraphs: Whether to prefer paragraph boundaries for chunking
        """
        self.chunk_size = chunk_size
        self.chunk_overlap = chunk_overlap
        self.min_chunk_size = min_chunk_size
        self.respect_sentences = respect_sentences
        self.respect_paragraphs = respect_paragraphs
    
    def chunk_text(self, text: str, metadata: Optional[Dict[str, Any]] = None) -> List[Dict[str, Any]]:
        """
        Split text into chunks suitable for vector database storage.
        
        Args:
            text: Text to chunk
            metadata: Optional metadata to include with each chunk
            
        Returns:
            List of dictionaries containing chunks and their metadata
        """
        if not text or not text.strip():
            return []
        
        chunks = []
        
        # First split by paragraphs if enabled
        if self.respect_paragraphs:
            paragraphs = self._split_paragraphs(text)
            
            # Process each paragraph
            current_chunk = ""
            current_chunk_metadata = {
                "start_char": 0,
                "end_char": 0,
            }
            
            char_position = 0
            
            for paragraph in paragraphs:
                # If adding this paragraph would exceed chunk size
                if len(current_chunk) + len(paragraph) > self.chunk_size and len(current_chunk) >= self.min_chunk_size:
                    # Save current chunk
                    current_chunk_metadata["end_char"] = char_position - 1
                    chunks.append(self._create_chunk_dict(current_chunk, current_chunk_metadata, metadata))
                    
                    # Start new chunk with overlap
                    if self.chunk_overlap > 0 and len(current_chunk) > self.chunk_overlap:
                        overlap_start = len(current_chunk) - self.chunk_overlap
                        current_chunk = current_chunk[overlap_start:]
                        current_chunk_metadata = {
                            "start_char": char_position - len(current_chunk),
                            "end_char": 0,
                        }
                    else:
                        current_chunk = ""
                        current_chunk_metadata = {
                            "start_char": char_position,
                            "end_char": 0,
                        }
                
                # Add paragraph to current chunk
                current_chunk += paragraph
                char_position += len(paragraph)
            
            # Add the last chunk if it's not empty
            if current_chunk and len(current_chunk) >= self.min_chunk_size:
                current_chunk_metadata["end_char"] = char_position - 1
                chunks.append(self._create_chunk_dict(current_chunk, current_chunk_metadata, metadata))
        
        # If no paragraphs or paragraph chunking is disabled
        if not chunks:
            if self.respect_sentences:
                chunks = self._chunk_by_sentences(text, metadata)
            else:
                chunks = self._chunk_by_size(text, metadata)
        
        return chunks
    
    def _split_paragraphs(self, text: str) -> List[str]:
        """
        Split text into paragraphs.
        
        Args:
            text: Text to split
            
        Returns:
            List of paragraphs
        """
        # Split on double newlines (common paragraph separator)
        paragraphs = re.split(r'\n\s*\n', text)
        
        # Filter out empty paragraphs and add newlines back
        return [p.strip() + "\n\n" for p in paragraphs if p.strip()]
    
    def _split_sentences(self, text: str) -> List[str]:
        """
        Split text into sentences.
        
        Args:
            text: Text to split
            
        Returns:
            List of sentences
        """
        # Simple sentence splitting - this could be improved with language-specific models
        # Vietnamese uses similar sentence terminators to English
        sentences = re.split(r'(?<=[.!?])\s+', text)
        return [s.strip() + " " for s in sentences if s.strip()]
    
    def _chunk_by_sentences(self, text: str, metadata: Optional[Dict[str, Any]] = None) -> List[Dict[str, Any]]:
        """
        Split text into chunks respecting sentence boundaries.
        
        Args:
            text: Text to chunk
            metadata: Optional metadata to include with each chunk
            
        Returns:
            List of dictionaries containing chunks and their metadata
        """
        sentences = self._split_sentences(text)
        chunks = []
        
        current_chunk = ""
        current_chunk_metadata = {
            "start_char": 0,
            "end_char": 0,
        }
        
        char_position = 0
        
        for sentence in sentences:
            # If adding this sentence would exceed chunk size
            if len(current_chunk) + len(sentence) > self.chunk_size and len(current_chunk) >= self.min_chunk_size:
                # Save current chunk
                current_chunk_metadata["end_char"] = char_position - 1
                chunks.append(self._create_chunk_dict(current_chunk, current_chunk_metadata, metadata))
                
                # Start new chunk with overlap
                if self.chunk_overlap > 0 and len(current_chunk) > self.chunk_overlap:
                    # Find a sentence boundary within the overlap region if possible
                    overlap_sentences = self._split_sentences(current_chunk[-self.chunk_overlap:])
                    if len(overlap_sentences) > 1:
                        # Use all but the first sentence from the overlap
                        current_chunk = "".join(overlap_sentences[1:])
                    else:
                        current_chunk = current_chunk[-self.chunk_overlap:]
                    
                    current_chunk_metadata = {
                        "start_char": char_position - len(current_chunk),
                        "end_char": 0,
                    }
                else:
                    current_chunk = ""
                    current_chunk_metadata = {
                        "start_char": char_position,
                        "end_char": 0,
                    }
            
            # Add sentence to current chunk
            current_chunk += sentence
            char_position += len(sentence)
        
        # Add the last chunk if it's not empty
        if current_chunk and len(current_chunk) >= self.min_chunk_size:
            current_chunk_metadata["end_char"] = char_position - 1
            chunks.append(self._create_chunk_dict(current_chunk, current_chunk_metadata, metadata))
        
        return chunks
    
    def _chunk_by_size(self, text: str, metadata: Optional[Dict[str, Any]] = None) -> List[Dict[str, Any]]:
        """
        Split text into chunks of specified size without respecting boundaries.
        
        Args:
            text: Text to chunk
            metadata: Optional metadata to include with each chunk
            
        Returns:
            List of dictionaries containing chunks and their metadata
        """
        chunks = []
        text_length = len(text)
        
        start = 0
        while start < text_length:
            end = min(start + self.chunk_size, text_length)
            
            chunk_text = text[start:end]
            chunk_metadata = {
                "start_char": start,
                "end_char": end - 1,
            }
            
            chunks.append(self._create_chunk_dict(chunk_text, chunk_metadata, metadata))
            
            # Move to next chunk with overlap
            start = end - self.chunk_overlap if self.chunk_overlap > 0 else end
        
        return chunks
    
    def _create_chunk_dict(
        self,
        chunk_text: str,
        chunk_metadata: Dict[str, Any],
        source_metadata: Optional[Dict[str, Any]] = None,
    ) -> Dict[str, Any]:
        """
        Create a dictionary for a text chunk with metadata.
        
        Args:
            chunk_text: The chunk text
            chunk_metadata: Metadata specific to this chunk
            source_metadata: Optional metadata from the source document
            
        Returns:
            Dictionary containing chunk and metadata
        """
        result = {
            "text": chunk_text,
            "char_length": len(chunk_text),
            **chunk_metadata,
        }
        
        # Add source metadata if provided
        if source_metadata:
            # Avoid overwriting chunk-specific metadata
            for key, value in source_metadata.items():
                if key not in result:
                    result[key] = value
        
        return result
    
    def chunk_document(self, document: Dict[str, Any]) -> List[Dict[str, Any]]:
        """
        Process a document dictionary into chunks.
        
        Args:
            document: Dictionary containing document text and metadata
            
        Returns:
            List of chunk dictionaries
        """
        if "content" not in document:
            logger.warning("Document missing 'content' field")
            return []
        
        text = document["content"]
        
        # Create metadata dictionary from document
        metadata = {k: v for k, v in document.items() if k != "content"}
        
        # Add document ID if available
        if "id" in document:
            metadata["document_id"] = document["id"]
        
        # Add title if available
        if "title" in document:
            metadata["title"] = document["title"]
        
        # Add source if available
        if "url" in document:
            metadata["source"] = document["url"]
        
        chunks = self.chunk_text(text, metadata)
        
        # Add chunk index
        for i, chunk in enumerate(chunks):
            chunk["chunk_index"] = i
            chunk["chunk_count"] = len(chunks)
        
        return chunks 