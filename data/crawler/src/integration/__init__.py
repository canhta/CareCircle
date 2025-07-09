"""
Integration module for Vietnamese Healthcare Data Crawler.

This module provides integration points for other components
of the CareCircle platform to access Vietnamese healthcare data.
"""

from .ai_assistant_integration import (
    VietnameseHealthcareKnowledge,
    get_vietnamese_healthcare_context,
)

__all__ = [
    "VietnameseHealthcareKnowledge",
    "get_vietnamese_healthcare_context",
] 