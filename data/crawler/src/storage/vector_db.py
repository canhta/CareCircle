"""
Vector Database Integration for CareCircle Vietnamese Healthcare Data Crawler.

This module handles the integration with Milvus vector database for storing
and retrieving vector embeddings of healthcare content.
"""

import logging
from typing import Any, Dict, List, Optional, Union
import os

from pymilvus import (
    connections,
    utility,
    FieldSchema,
    CollectionSchema,
    DataType,
    Collection,
)
from sentence_transformers import SentenceTransformer

# Configure logger
logger = logging.getLogger(__name__)


class VectorDBManager:
    """
    Manager for vector database operations.
    
    This class handles the connection to Milvus, collection management,
    and vector operations for healthcare data.
    """
    
    def __init__(
        self,
        host: str = "localhost",
        port: str = "19530",
        model_name: str = "sentence-transformers/paraphrase-multilingual-MiniLM-L12-v2",
        collection_prefix: str = "vietnam_healthcare_",
    ):
        """
        Initialize the vector database manager.
        
        Args:
            host: Milvus host address
            port: Milvus port
            model_name: Sentence transformer model name
            collection_prefix: Prefix for Milvus collections
        """
        self.host = host
        self.port = port
        self.model_name = model_name
        self.collection_prefix = collection_prefix
        self.model = None
        self.vector_dim = 384  # Default for MiniLM-L12
        
        # Connect to Milvus
        self._connect()
        
        # Load embedding model
        self._load_model()
    
    def _connect(self) -> None:
        """Connect to Milvus server."""
        try:
            connections.connect(
                alias="default",
                host=self.host,
                port=self.port,
            )
            logger.info(f"Connected to Milvus at {self.host}:{self.port}")
        except Exception as e:
            logger.error(f"Failed to connect to Milvus: {str(e)}")
            raise
    
    def _load_model(self) -> None:
        """Load the sentence transformer model for embeddings."""
        try:
            self.model = SentenceTransformer(self.model_name)
            self.vector_dim = self.model.get_sentence_embedding_dimension()
            logger.info(f"Loaded model {self.model_name} with dimension {self.vector_dim}")
        except Exception as e:
            logger.error(f"Failed to load model {self.model_name}: {str(e)}")
            raise
    
    def create_collection(self, domain: str) -> Collection:
        """
        Create a new collection for a healthcare domain.
        
        Args:
            domain: Healthcare domain name (e.g., 'healthcare_system', 'medications')
            
        Returns:
            Milvus Collection object
        """
        collection_name = f"{self.collection_prefix}{domain}"
        
        # Check if collection already exists
        if utility.has_collection(collection_name):
            logger.info(f"Collection {collection_name} already exists")
            return Collection(collection_name)
        
        # Define collection schema
        fields = [
            FieldSchema(name="id", dtype=DataType.INT64, is_primary=True, auto_id=True),
            FieldSchema(name="text_id", dtype=DataType.VARCHAR, max_length=100),
            FieldSchema(name="text", dtype=DataType.VARCHAR, max_length=65535),
            FieldSchema(name="embedding", dtype=DataType.FLOAT_VECTOR, dim=self.vector_dim),
            FieldSchema(name="source", dtype=DataType.VARCHAR, max_length=500),
            FieldSchema(name="domain", dtype=DataType.VARCHAR, max_length=100),
            FieldSchema(name="category", dtype=DataType.VARCHAR, max_length=100),
            FieldSchema(name="crawl_date", dtype=DataType.VARCHAR, max_length=30),
        ]
        
        schema = CollectionSchema(fields=fields, description=f"Vietnamese healthcare data: {domain}")
        collection = Collection(name=collection_name, schema=schema)
        
        # Create index for vector field
        index_params = {
            "index_type": "IVF_FLAT",
            "metric_type": "COSINE",
            "params": {"nlist": 1024},
        }
        collection.create_index(field_name="embedding", index_params=index_params)
        
        logger.info(f"Created collection {collection_name} with index")
        
        return collection
    
    def generate_embeddings(self, texts: List[str]) -> List[List[float]]:
        """
        Generate embeddings for a list of texts.
        
        Args:
            texts: List of text strings to embed
            
        Returns:
            List of embedding vectors
        """
        if not self.model:
            self._load_model()
        
        embeddings = self.model.encode(texts)
        return embeddings.tolist()
    
    def insert_data(
        self,
        domain: str,
        texts: List[str],
        text_ids: List[str],
        sources: List[str],
        categories: List[str],
        crawl_dates: List[str],
    ) -> List[int]:
        """
        Insert data into a collection.
        
        Args:
            domain: Healthcare domain name
            texts: List of text chunks
            text_ids: List of text IDs (references to original documents)
            sources: List of source URLs
            categories: List of categories
            crawl_dates: List of crawl dates
            
        Returns:
            List of inserted IDs
        """
        if len(texts) != len(text_ids) or len(texts) != len(sources) or len(texts) != len(categories) or len(texts) != len(crawl_dates):
            raise ValueError("All input lists must have the same length")
        
        # Generate embeddings
        embeddings = self.generate_embeddings(texts)
        
        # Get or create collection
        collection = self.create_collection(domain)
        
        # Prepare data
        entities = [
            text_ids,
            texts,
            embeddings,
            sources,
            [domain] * len(texts),
            categories,
            crawl_dates,
        ]
        
        # Insert data
        collection.load()
        try:
            insert_result = collection.insert(entities)
            logger.info(f"Inserted {len(texts)} entities into {collection.name}")
            return insert_result.primary_keys
        finally:
            collection.release()
    
    def search(
        self,
        domain: str,
        query_text: str,
        limit: int = 10,
        filter_expr: Optional[str] = None,
    ) -> List[Dict[str, Any]]:
        """
        Search for similar texts in the vector database.
        
        Args:
            domain: Healthcare domain name
            query_text: Query text to search for
            limit: Maximum number of results to return
            filter_expr: Milvus filter expression
            
        Returns:
            List of search results with metadata
        """
        collection_name = f"{self.collection_prefix}{domain}"
        
        if not utility.has_collection(collection_name):
            logger.warning(f"Collection {collection_name} does not exist")
            return []
        
        collection = Collection(collection_name)
        collection.load()
        
        try:
            # Generate query embedding
            query_embedding = self.generate_embeddings([query_text])[0]
            
            # Define output fields
            output_fields = ["text_id", "text", "source", "category", "crawl_date"]
            
            # Execute search
            search_params = {"metric_type": "COSINE", "params": {"nprobe": 10}}
            results = collection.search(
                data=[query_embedding],
                anns_field="embedding",
                param=search_params,
                limit=limit,
                expr=filter_expr,
                output_fields=output_fields,
            )
            
            # Format results
            formatted_results = []
            for hits in results:
                for hit in hits:
                    result = {
                        "score": hit.score,
                        "text_id": hit.entity.get("text_id"),
                        "text": hit.entity.get("text"),
                        "source": hit.entity.get("source"),
                        "category": hit.entity.get("category"),
                        "crawl_date": hit.entity.get("crawl_date"),
                        "domain": domain,
                    }
                    formatted_results.append(result)
            
            return formatted_results
        finally:
            collection.release()
    
    def list_collections(self) -> List[str]:
        """
        List all healthcare collections in the vector database.
        
        Returns:
            List of collection names
        """
        all_collections = utility.list_collections()
        healthcare_collections = [
            coll for coll in all_collections if coll.startswith(self.collection_prefix)
        ]
        return healthcare_collections
    
    def get_collection_stats(self, domain: str) -> Dict[str, Any]:
        """
        Get statistics for a collection.
        
        Args:
            domain: Healthcare domain name
            
        Returns:
            Dictionary of collection statistics
        """
        collection_name = f"{self.collection_prefix}{domain}"
        
        if not utility.has_collection(collection_name):
            logger.warning(f"Collection {collection_name} does not exist")
            return {}
        
        collection = Collection(collection_name)
        
        stats = {
            "name": collection_name,
            "entity_count": collection.num_entities,
            "description": collection.description,
            "schema": collection.schema,
        }
        
        return stats
    
    def close(self) -> None:
        """Close the connection to Milvus."""
        connections.disconnect("default")
        logger.info("Disconnected from Milvus")


# Factory function to create a VectorDBManager from configuration
def create_vector_db_manager(config: Dict[str, Any]) -> VectorDBManager:
    """
    Create a VectorDBManager from configuration.
    
    Args:
        config: Configuration dictionary
        
    Returns:
        VectorDBManager instance
    """
    vector_config = config.get("storage", {}).get("vector_database", {})
    
    host = os.environ.get("MILVUS_HOST", vector_config.get("host", "localhost"))
    port = os.environ.get("MILVUS_PORT", vector_config.get("port", "19530"))
    model_name = vector_config.get("model_name", "sentence-transformers/paraphrase-multilingual-MiniLM-L12-v2")
    collection_prefix = vector_config.get("collection_prefix", "vietnam_healthcare_")
    
    return VectorDBManager(
        host=host,
        port=port,
        model_name=model_name,
        collection_prefix=collection_prefix,
    ) 