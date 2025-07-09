"""
Storage modules for CareCircle Vietnamese Healthcare Data Crawler.

This package provides modules for storing and retrieving Vietnamese healthcare data,
including MongoDB storage and Milvus vector database integration.
"""

from .vector_db import VectorDBManager, create_vector_db_manager

__all__ = ["VectorDBManager", "create_vector_db_manager"] 