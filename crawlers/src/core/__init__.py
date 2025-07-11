"""
Core crawler components for the CareCircle Vietnamese Healthcare Crawler System.

This module contains the base classes and utilities for web crawling,
content processing, and API communication.
"""

from .base_crawler import BaseCrawler
from .content_processor import ContentProcessor
from .api_client import APIClient
from .logger import setup_logger

__all__ = [
    "BaseCrawler",
    "ContentProcessor",
    "APIClient", 
    "setup_logger"
]
