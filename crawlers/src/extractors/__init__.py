"""
Vietnamese healthcare source extractors.

This module contains specialized extractors for different types of
Vietnamese healthcare sources including government sites, hospitals,
and news portals.
"""

from .ministry_health import MinistryHealthExtractor
from .hospital_sites import HospitalSiteExtractor
from .health_news import HealthNewsExtractor
from .vinmec_hospital import VinmecExtractor

__all__ = [
    "MinistryHealthExtractor",
    "HospitalSiteExtractor",
    "HealthNewsExtractor",
    "VinmecExtractor"
]
