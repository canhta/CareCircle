"""
Ministry of Health Vietnam Extractor.

This module implements a site-specific extractor for the Vietnamese Ministry of Health website.
It extracts healthcare information, policies, statistics, and news.
"""

import re
from typing import Any, Dict, List, Optional
from bs4 import BeautifulSoup
import logging

from ..base_extractor import BaseExtractor

# Configure logger
logger = logging.getLogger(__name__)


class MohExtractor(BaseExtractor):
    """
    Extractor for the Vietnamese Ministry of Health website (moh.gov.vn).
    
    This class implements site-specific extraction logic for the Ministry of Health website,
    focusing on healthcare policies, statistics, and public health information.
    """
    
    def extract_content(self, url: str, html_content: str) -> Dict[str, Any]:
        """
        Extract structured content from MOH HTML.
        
        Args:
            url: URL of the page being processed
            html_content: HTML content of the page
            
        Returns:
            Dictionary containing extracted structured data
        """
        soup = BeautifulSoup(html_content, 'html.parser')
        
        # Extract basic metadata
        metadata = self.extract_metadata(soup)
        
        # If we couldn't extract a title, this might not be a content page
        if 'title' not in metadata:
            logger.debug(f"No title found for {url}, skipping extraction")
            return {}
        
        # Extract main content
        content = self.extract_main_content(soup)
        if not content:
            logger.debug(f"No content found for {url}, skipping extraction")
            return {}
        
        # Extract tables if available
        tables = self.extract_tables(soup) if self.config.get('post_processing', {}).get('extract_tables', True) else []
        
        # Extract lists if available
        lists = self.extract_lists(soup) if self.config.get('post_processing', {}).get('extract_lists', True) else []
        
        # Extract health statistics
        statistics = self.extract_statistics(content)
        
        # Categorize content
        categories = self.categorize_content(url, content)
        
        # Build structured data
        result = {
            **metadata,
            'content': content,
            'categories': categories,
            'domain': 'government',
            'language': 'vi'
        }
        
        if tables:
            result['tables'] = tables
        
        if lists:
            result['lists'] = lists
        
        if statistics:
            result['statistics'] = statistics
        
        # Extract health conditions if present
        health_conditions = self.extract_health_conditions(content)
        if health_conditions:
            result['health_conditions'] = health_conditions
        
        # Extract policies if present
        policies = self.extract_policies(url, content)
        if policies:
            result['policies'] = policies
        
        return result
    
    def extract_main_content(self, soup: BeautifulSoup) -> str:
        """
        Extract the main content from the MOH page.
        
        Args:
            soup: BeautifulSoup object of the HTML document
            
        Returns:
            String containing the main content text
        """
        content_selectors = self.extraction_config.get('content_selectors', ['.journal-content-article', '.content'])
        
        for selector in content_selectors:
            content_element = soup.select_one(selector)
            if content_element:
                # Remove nested elements that might contain navigation or unrelated content
                for unwanted in content_element.select('.asset-actions, .taglib-discussion, .comments, .footer'):
                    unwanted.decompose()
                
                return content_element.get_text(separator=' ', strip=True)
        
        return ""
    
    def extract_statistics(self, content: str) -> List[Dict[str, Any]]:
        """
        Extract health statistics from content text.
        
        Args:
            content: Text content to extract statistics from
            
        Returns:
            List of dictionaries containing extracted statistics
        """
        statistics = []
        
        # Extract statistics based on patterns defined in config
        stat_patterns = self.config.get('extraction_patterns', {}).get('statistics', [])
        for pattern_config in stat_patterns:
            pattern = pattern_config.get('pattern')
            name = pattern_config.get('name')
            
            if pattern and name:
                matches = re.finditer(pattern, content, re.IGNORECASE)
                for match in matches:
                    try:
                        value = match.group(1)
                        # Get some context around the statistic (up to 100 chars before and after)
                        start = max(0, match.start() - 100)
                        end = min(len(content), match.end() + 100)
                        context = content[start:end]
                        
                        statistics.append({
                            'type': name,
                            'value': value,
                            'context': context,
                            'position': match.start()
                        })
                    except (IndexError, ValueError) as e:
                        logger.warning(f"Error extracting statistic with pattern {pattern}: {str(e)}")
        
        # Also extract health metrics
        health_metrics = self.config.get('extraction_patterns', {}).get('health_metrics', [])
        for pattern_config in health_metrics:
            pattern = pattern_config.get('pattern')
            name = pattern_config.get('name')
            
            if pattern and name:
                matches = re.finditer(pattern, content, re.IGNORECASE)
                for match in matches:
                    try:
                        value = match.group(1)
                        # Get some context around the metric (up to 100 chars before and after)
                        start = max(0, match.start() - 100)
                        end = min(len(content), match.end() + 100)
                        context = content[start:end]
                        
                        statistics.append({
                            'type': name,
                            'value': value,
                            'context': context,
                            'position': match.start()
                        })
                    except (IndexError, ValueError) as e:
                        logger.warning(f"Error extracting health metric with pattern {pattern}: {str(e)}")
        
        return statistics
    
    def extract_health_conditions(self, content: str) -> List[Dict[str, Any]]:
        """
        Extract information about health conditions from content.
        
        Args:
            content: Text content to extract health conditions from
            
        Returns:
            List of dictionaries containing health condition information
        """
        # Common Vietnamese disease/condition names and their patterns
        condition_patterns = [
            r'bệnh\s+([A-Za-z0-9\s\-]+)',  # "bệnh X"
            r'hội\s+chứng\s+([A-Za-z0-9\s\-]+)',  # "hội chứng X"
            r'rối\s+loạn\s+([A-Za-z0-9\s\-]+)',  # "rối loạn X"
            r'nhiễm\s+([A-Za-z0-9\s\-]+)',  # "nhiễm X"
            r'viêm\s+([A-Za-z0-9\s\-]+)',  # "viêm X"
            r'ung\s+thư\s+([A-Za-z0-9\s\-]+)',  # "ung thư X"
        ]
        
        conditions = []
        
        for pattern in condition_patterns:
            matches = re.finditer(pattern, content, re.IGNORECASE)
            for match in matches:
                try:
                    condition_name = match.group(1).strip()
                    # Skip very short names (likely false positives)
                    if len(condition_name) < 3:
                        continue
                    
                    # Get some context around the condition (up to 200 chars before and after)
                    start = max(0, match.start() - 200)
                    end = min(len(content), match.end() + 200)
                    context = content[start:end]
                    
                    # Check if this condition is already in our list
                    if not any(c['name'].lower() == condition_name.lower() for c in conditions):
                        conditions.append({
                            'name': condition_name,
                            'context': context,
                            'position': match.start()
                        })
                except (IndexError, ValueError) as e:
                    logger.warning(f"Error extracting health condition with pattern {pattern}: {str(e)}")
        
        # Now try to enrich the conditions with prevalence information
        prevalence_patterns = [
            r'tỷ\s+lệ\s+mắc\s+(?:bệnh)?\s*([A-Za-z0-9\s\-]+)\s+là\s+(\d+(?:[\.,]\d+)?)\s*%',
            r'(\d+(?:[\.,]\d+)?)\s*%\s+(?:người|dân|bệnh nhân|ca)\s+mắc\s+(?:bệnh)?\s*([A-Za-z0-9\s\-]+)',
            r'(?:bệnh)?\s*([A-Za-z0-9\s\-]+)\s+chiếm\s+(\d+(?:[\.,]\d+)?)\s*%',
        ]
        
        for pattern in prevalence_patterns:
            matches = re.finditer(pattern, content, re.IGNORECASE)
            for match in matches:
                try:
                    # Different patterns have different group positions
                    if '% người mắc' in pattern:
                        prevalence = match.group(1)
                        condition_name = match.group(2).strip()
                    else:
                        condition_name = match.group(1).strip()
                        prevalence = match.group(2)
                    
                    # Find matching condition in our list
                    for condition in conditions:
                        if condition_name.lower() in condition['name'].lower() or condition['name'].lower() in condition_name.lower():
                            condition['prevalence'] = prevalence + '%'
                            break
                except (IndexError, ValueError) as e:
                    logger.warning(f"Error extracting prevalence with pattern {pattern}: {str(e)}")
        
        return conditions
    
    def extract_policies(self, url: str, content: str) -> List[Dict[str, Any]]:
        """
        Extract healthcare policy information.
        
        Args:
            url: URL of the page
            content: Text content to extract policies from
            
        Returns:
            List of dictionaries containing policy information
        """
        policies = []
        
        # Check if this is likely a policy page based on URL or content
        is_policy_page = (
            'chinh-sach' in url or 
            'quy-dinh' in url or 
            'quyet-dinh' in url or 
            'nghi-dinh' in url or
            'thong-tu' in url or
            re.search(r'(quyết\s+định|nghị\s+định|thông\s+tư)\s+số', content, re.IGNORECASE)
        )
        
        if not is_policy_page:
            return []
        
        # Extract policy numbers
        policy_patterns = [
            r'(?:quyết\s+định|nghị\s+định|thông\s+tư)\s+số\s+(\d+[\/\-](?:\d+)?[\/\-](?:\w+)?)',
            r'(?:số)\s+(\d+[\/\-](?:\d+)?[\/\-](?:\w+)?)\s+(?:\/\w+\-\w+)',
        ]
        
        for pattern in policy_patterns:
            matches = re.finditer(pattern, content, re.IGNORECASE)
            for match in matches:
                try:
                    policy_number = match.group(1).strip()
                    
                    # Get some context around the policy (up to 300 chars before and after)
                    start = max(0, match.start() - 300)
                    end = min(len(content), match.end() + 300)
                    context = content[start:end]
                    
                    # Try to extract date if available
                    date_match = re.search(r'ngày\s+(\d{1,2})[\/\-\s](\d{1,2})[\/\-\s](\d{4})', context)
                    date = None
                    if date_match:
                        day, month, year = date_match.groups()
                        date = f"{day}/{month}/{year}"
                    
                    policies.append({
                        'number': policy_number,
                        'context': context,
                        'date': date,
                        'url': url
                    })
                except (IndexError, ValueError) as e:
                    logger.warning(f"Error extracting policy with pattern {pattern}: {str(e)}")
        
        return policies 