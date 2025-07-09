#!/usr/bin/env python3
"""
AI Assistant Integration for Vietnamese Healthcare Data.

This module provides functions for the AI Assistant to query
the vector database for Vietnamese healthcare information.
"""

import json
import logging
import os
import sys
import yaml
from pathlib import Path
from typing import Dict, List, Any, Optional

# Set up logging
import logging
logger = logging.getLogger(__name__)

# Set up paths
BASE_DIR = Path(__file__).resolve().parent.parent.parent
CONFIG_DIR = BASE_DIR / "config"


def load_config() -> Dict[str, Any]:
    """
    Load configuration from YAML file.
    
    Returns:
        Dictionary containing configuration
    """
    config_path = CONFIG_DIR / "base_config.yaml"
    
    if not config_path.exists():
        logger.error(f"Configuration file not found: {config_path}")
        raise FileNotFoundError(f"Configuration file not found: {config_path}")
    
    with open(config_path, "r", encoding="utf-8") as f:
        config = yaml.safe_load(f)
    
    logger.info(f"Loaded configuration from {config_path}")
    
    return config


class VietnameseHealthcareKnowledge:
    """
    Interface for AI Assistant to query Vietnamese healthcare knowledge.
    
    This class provides methods for the AI Assistant to retrieve
    Vietnamese healthcare information from the vector database.
    """
    
    def __init__(self):
        """Initialize the Vietnamese healthcare knowledge interface."""
        # Import here to avoid circular imports
        from ..storage.vector_db import create_vector_db_manager
        
        # Load configuration
        self.config = load_config()
        
        # Initialize vector database manager
        self.vector_db = create_vector_db_manager(self.config)
        
        # Available domains
        self.domains = [
            "healthcare_system",
            "health_conditions",
            "medications",
            "elderly_care",
            "cultural_context",
            "health_statistics"
        ]
        
        logger.info("Initialized Vietnamese Healthcare Knowledge interface")
    
    def query_healthcare_knowledge(
        self,
        query: str,
        domains: Optional[List[str]] = None,
        limit: int = 5,
    ) -> List[Dict[str, Any]]:
        """
        Query Vietnamese healthcare knowledge.
        
        Args:
            query: Query text in Vietnamese or English
            domains: List of domains to search (defaults to all domains)
            limit: Maximum number of results per domain
            
        Returns:
            List of relevant healthcare information
        """
        if not domains:
            domains = self.domains
        
        all_results = []
        
        for domain in domains:
            try:
                # Search the domain
                results = self.vector_db.search(
                    domain=domain,
                    query_text=query,
                    limit=limit,
                )
                
                # Add domain information to results
                for result in results:
                    result["domain"] = domain
                
                all_results.extend(results)
                
                logger.info(f"Found {len(results)} results in domain '{domain}'")
            except Exception as e:
                logger.error(f"Error searching domain '{domain}': {str(e)}")
        
        # Sort by score
        all_results.sort(key=lambda x: x.get("score", 0), reverse=True)
        
        # Limit total results
        all_results = all_results[:limit * 2]
        
        return all_results
    
    def get_medication_information(
        self,
        medication_name: str,
        limit: int = 3,
    ) -> List[Dict[str, Any]]:
        """
        Get information about a specific medication.
        
        Args:
            medication_name: Name of the medication in Vietnamese or English
            limit: Maximum number of results
            
        Returns:
            List of medication information
        """
        # Search specifically in the medications domain
        results = self.vector_db.search(
            domain="medications",
            query_text=medication_name,
            limit=limit,
        )
        
        logger.info(f"Found {len(results)} results for medication '{medication_name}'")
        
        return results
    
    def get_health_condition_information(
        self,
        condition_name: str,
        limit: int = 3,
    ) -> List[Dict[str, Any]]:
        """
        Get information about a specific health condition.
        
        Args:
            condition_name: Name of the health condition in Vietnamese or English
            limit: Maximum number of results
            
        Returns:
            List of health condition information
        """
        # Search specifically in the health conditions domain
        results = self.vector_db.search(
            domain="health_conditions",
            query_text=condition_name,
            limit=limit,
        )
        
        logger.info(f"Found {len(results)} results for condition '{condition_name}'")
        
        return results
    
    def get_cultural_context(
        self,
        query: str,
        limit: int = 3,
    ) -> List[Dict[str, Any]]:
        """
        Get Vietnamese cultural context related to healthcare.
        
        Args:
            query: Query text in Vietnamese or English
            limit: Maximum number of results
            
        Returns:
            List of cultural context information
        """
        # Search specifically in the cultural context domain
        results = self.vector_db.search(
            domain="cultural_context",
            query_text=query,
            limit=limit,
        )
        
        logger.info(f"Found {len(results)} cultural context results for '{query}'")
        
        return results
    
    def get_elderly_care_information(
        self,
        query: str,
        limit: int = 3,
    ) -> List[Dict[str, Any]]:
        """
        Get information about elderly care in Vietnam.
        
        Args:
            query: Query text in Vietnamese or English
            limit: Maximum number of results
            
        Returns:
            List of elderly care information
        """
        # Search specifically in the elderly care domain
        results = self.vector_db.search(
            domain="elderly_care",
            query_text=query,
            limit=limit,
        )
        
        logger.info(f"Found {len(results)} elderly care results for '{query}'")
        
        return results
    
    def get_health_statistics(
        self,
        query: str,
        limit: int = 3,
    ) -> List[Dict[str, Any]]:
        """
        Get health statistics for Vietnam.
        
        Args:
            query: Query text in Vietnamese or English
            limit: Maximum number of results
            
        Returns:
            List of health statistics information
        """
        # Search specifically in the health statistics domain
        results = self.vector_db.search(
            domain="health_statistics",
            query_text=query,
            limit=limit,
        )
        
        logger.info(f"Found {len(results)} health statistics results for '{query}'")
        
        return results
    
    def format_results_for_ai_assistant(
        self,
        results: List[Dict[str, Any]],
    ) -> str:
        """
        Format search results for AI Assistant consumption.
        
        Args:
            results: List of search results
            
        Returns:
            Formatted string with healthcare information
        """
        if not results:
            return "No relevant Vietnamese healthcare information found."
        
        formatted_output = "## Vietnamese Healthcare Information\n\n"
        
        for i, result in enumerate(results):
            # Add domain information
            domain = result.get("domain", "Unknown")
            formatted_domain = domain.replace("_", " ").title()
            
            formatted_output += f"### {formatted_domain} Information\n\n"
            
            # Add text content
            text = result.get("text", "").strip()
            formatted_output += f"{text}\n\n"
            
            # Add source if available
            source = result.get("source", "")
            if source:
                formatted_output += f"Source: {source}\n\n"
            
            # Add separator between results
            if i < len(results) - 1:
                formatted_output += "---\n\n"
        
        return formatted_output


# Example usage in AI Assistant
def get_vietnamese_healthcare_context(query: str) -> str:
    """
    Get Vietnamese healthcare context for AI Assistant.
    
    This function is called by the AI Assistant to retrieve
    Vietnamese healthcare information for a user query.
    
    Args:
        query: User query text
        
    Returns:
        Formatted healthcare information
    """
    try:
        # Initialize knowledge interface
        knowledge = VietnameseHealthcareKnowledge()
        
        # Query all domains
        results = knowledge.query_healthcare_knowledge(query)
        
        # Format results for AI Assistant
        formatted_results = knowledge.format_results_for_ai_assistant(results)
        
        return formatted_results
    except Exception as e:
        logger.error(f"Error retrieving Vietnamese healthcare context: {str(e)}")
        return "Unable to retrieve Vietnamese healthcare information at this time."


if __name__ == "__main__":
    # Set up logging
    logging.basicConfig(level=logging.INFO)
    
    # Example usage
    query = "điều trị tiểu đường ở người cao tuổi"
    print(f"Query: {query}")
    print(get_vietnamese_healthcare_context(query)) 