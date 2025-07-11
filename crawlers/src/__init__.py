"""
CareCircle Vietnamese Healthcare Crawler System

A local Python crawler system for extracting Vietnamese healthcare content
and uploading it to the CareCircle backend via API endpoints.
"""

__version__ = "1.0.0"
__author__ = "CareCircle Team"
__email__ = "dev@carecircle.com"

from .core.base_crawler import BaseCrawler
from .core.content_processor import ContentProcessor
from .core.api_client import APIClient

__all__ = [
    "BaseCrawler",
    "ContentProcessor", 
    "APIClient"
]
