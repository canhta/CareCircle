"""
Base Extractor for CareCircle Vietnamese Healthcare Data Crawler.

This module defines the BaseExtractor abstract class that all site-specific
extractors must implement. It provides common functionality and defines
the interface for content extraction from different healthcare websites.
"""

import abc
import logging
from datetime import datetime
from typing import Any, Dict, List, Optional, Set, Tuple, Union

import requests
from bs4 import BeautifulSoup
from urllib.parse import urljoin, urlparse

# Configure logger
logger = logging.getLogger(__name__)


class BaseExtractor(abc.ABC):
    """
    Abstract base class for all site-specific extractors.
    
    This class defines the common interface and functionality for extracting
    healthcare data from Vietnamese websites. Each website should have its own
    implementation that inherits from this base class.
    """
    
    def __init__(self, config: Dict[str, Any]):
        """
        Initialize the extractor with configuration.
        
        Args:
            config: Dictionary containing extractor configuration
        """
        self.config = config
        self.source_id = config.get('source', {}).get('id', 'unknown')
        self.base_url = config.get('source', {}).get('base_url', '')
        self.start_urls = config.get('crawl', {}).get('start_urls', [])
        self.allowed_domains = config.get('crawl', {}).get('allowed_domains', [])
        self.visited_urls: Set[str] = set()
        self.max_pages = config.get('crawl', {}).get('max_pages', 1000)
        self.request_headers = config.get('request', {}).get('headers', {})
        
        # Content extraction selectors
        self.extraction_config = config.get('extraction', {})
        
        # Initialize statistics
        self.stats = {
            'pages_crawled': 0,
            'successful_extractions': 0,
            'failed_extractions': 0,
            'start_time': datetime.now(),
            'errors': []
        }
    
    @abc.abstractmethod
    def extract_content(self, url: str, html_content: str) -> Dict[str, Any]:
        """
        Extract structured content from HTML.
        
        Args:
            url: URL of the page being processed
            html_content: HTML content of the page
            
        Returns:
            Dictionary containing extracted structured data
        """
        pass
    
    def is_allowed_url(self, url: str) -> bool:
        """
        Check if URL is allowed for crawling based on configuration.
        
        Args:
            url: URL to check
            
        Returns:
            Boolean indicating if URL should be crawled
        """
        if not url or not url.startswith('http'):
            return False
        
        # Check if URL is in allowed domains
        parsed_url = urlparse(url)
        domain = parsed_url.netloc
        
        return any(domain.endswith(allowed_domain) for allowed_domain in self.allowed_domains)
    
    def fetch_page(self, url: str) -> Tuple[Optional[str], Dict[str, Any]]:
        """
        Fetch a page with proper error handling and retry logic.
        
        Args:
            url: URL to fetch
            
        Returns:
            Tuple of (HTML content or None if failed, metadata dictionary)
        """
        metadata = {
            'url': url,
            'timestamp': datetime.now(),
            'success': False,
            'status_code': None,
            'error': None
        }
        
        try:
            response = requests.get(
                url, 
                headers=self.request_headers, 
                timeout=self.config.get('request', {}).get('timeout', 30)
            )
            response.raise_for_status()
            
            metadata['success'] = True
            metadata['status_code'] = response.status_code
            metadata['content_type'] = response.headers.get('Content-Type', '')
            
            return response.text, metadata
            
        except requests.RequestException as e:
            metadata['error'] = str(e)
            metadata['status_code'] = getattr(e.response, 'status_code', None) if hasattr(e, 'response') else None
            logger.error(f"Error fetching {url}: {str(e)}")
            self.stats['errors'].append({
                'url': url,
                'error': str(e),
                'timestamp': datetime.now()
            })
            return None, metadata
    
    def extract_links(self, url: str, html_content: str) -> List[str]:
        """
        Extract links from HTML content for further crawling.
        
        Args:
            url: URL of the page being processed
            html_content: HTML content of the page
            
        Returns:
            List of URLs found in the page
        """
        soup = BeautifulSoup(html_content, 'html.parser')
        links = []
        
        for a_tag in soup.find_all('a', href=True):
            href = a_tag['href']
            absolute_url = urljoin(url, href)
            
            # Filter out non-HTTP URLs, already visited URLs, and URLs not in allowed domains
            if (absolute_url.startswith('http') and 
                absolute_url not in self.visited_urls and 
                self.is_allowed_url(absolute_url)):
                links.append(absolute_url)
        
        return links
    
    def extract_metadata(self, soup: BeautifulSoup) -> Dict[str, Any]:
        """
        Extract metadata from the HTML document.
        
        Args:
            soup: BeautifulSoup object of the HTML document
            
        Returns:
            Dictionary containing metadata (title, publication date, etc.)
        """
        metadata = {}
        
        # Extract title
        title_selectors = self.extraction_config.get('title_selectors', [])
        for selector in title_selectors:
            title_element = soup.select_one(selector)
            if title_element and title_element.text.strip():
                metadata['title'] = title_element.text.strip()
                break
        
        # Extract publication date
        date_selectors = self.extraction_config.get('date_selectors', [])
        for selector in date_selectors:
            date_element = soup.select_one(selector)
            if date_element and date_element.text.strip():
                metadata['publication_date'] = date_element.text.strip()
                break
        
        # Extract author
        author_selectors = self.extraction_config.get('author_selectors', ['meta[name="author"]'])
        for selector in author_selectors:
            if selector.startswith('meta'):
                # Handle meta tags differently
                meta_parts = selector.split('[')
                if len(meta_parts) > 1:
                    attr_name = meta_parts[1].split('=')[0].strip(']"\'')
                    attr_value = meta_parts[1].split('=')[1].strip(']"\'')
                    meta_tag = soup.find('meta', {attr_name: attr_value})
                    if meta_tag and meta_tag.get('content'):
                        metadata['author'] = meta_tag.get('content')
                        break
            else:
                author_element = soup.select_one(selector)
                if author_element and author_element.text.strip():
                    metadata['author'] = author_element.text.strip()
                    break
        
        return metadata
    
    def clean_html(self, html_content: str) -> str:
        """
        Clean HTML content by removing unwanted elements.
        
        Args:
            html_content: Raw HTML content
            
        Returns:
            Cleaned HTML content
        """
        soup = BeautifulSoup(html_content, 'html.parser')
        
        # Remove elements specified in configuration
        remove_elements = self.config.get('post_processing', {}).get('remove_elements', [])
        for selector in remove_elements:
            for element in soup.select(selector):
                element.decompose()
        
        # Remove comments
        for comment in soup.find_all(text=lambda text: isinstance(text, str) and '<!--' in text):
            comment.extract()
        
        return str(soup)
    
    def extract_tables(self, soup: BeautifulSoup) -> List[Dict[str, Any]]:
        """
        Extract tables from HTML content.
        
        Args:
            soup: BeautifulSoup object of the HTML document
            
        Returns:
            List of dictionaries representing tables
        """
        tables = []
        
        for table in soup.find_all('table'):
            table_data = {
                'headers': [],
                'rows': []
            }
            
            # Extract headers
            headers = table.find_all('th')
            if headers:
                table_data['headers'] = [header.text.strip() for header in headers]
            
            # Extract rows
            for row in table.find_all('tr'):
                cells = row.find_all(['td', 'th'])
                if cells and not all(cell.name == 'th' for cell in cells):  # Skip header rows
                    row_data = [cell.text.strip() for cell in cells]
                    table_data['rows'].append(row_data)
            
            if table_data['rows']:  # Only add tables with actual data
                tables.append(table_data)
        
        return tables
    
    def extract_lists(self, soup: BeautifulSoup) -> List[Dict[str, Any]]:
        """
        Extract lists from HTML content.
        
        Args:
            soup: BeautifulSoup object of the HTML document
            
        Returns:
            List of dictionaries representing lists
        """
        lists = []
        
        for list_element in soup.find_all(['ul', 'ol']):
            list_data = {
                'type': list_element.name,
                'items': []
            }
            
            for item in list_element.find_all('li'):
                list_data['items'].append(item.text.strip())
            
            if list_data['items']:  # Only add lists with actual items
                lists.append(list_data)
        
        return lists
    
    def categorize_content(self, url: str, text_content: str) -> List[str]:
        """
        Categorize content based on rules in configuration.
        
        Args:
            url: URL of the content
            text_content: Text content to categorize
            
        Returns:
            List of category names that apply to this content
        """
        import re
        categories = []
        
        categorization_rules = self.config.get('categorization', {}).get('rules', [])
        
        for rule in categorization_rules:
            pattern = rule.get('pattern')
            category = rule.get('category')
            
            if pattern and category:
                # Check URL first
                if re.search(pattern, url, re.IGNORECASE):
                    categories.append(category)
                    continue
                
                # Check content
                if re.search(pattern, text_content, re.IGNORECASE):
                    categories.append(category)
        
        return categories
    
    def crawl(self, max_pages: Optional[int] = None) -> List[Dict[str, Any]]:
        """
        Crawl the website starting from the configured start URLs.
        
        Args:
            max_pages: Maximum number of pages to crawl (overrides config if provided)
            
        Returns:
            List of extracted data items
        """
        if max_pages is None:
            max_pages = self.max_pages
        
        urls_to_visit = list(self.start_urls)
        extracted_items = []
        
        while urls_to_visit and self.stats['pages_crawled'] < max_pages:
            url = urls_to_visit.pop(0)
            
            if url in self.visited_urls:
                continue
                
            self.visited_urls.add(url)
            self.stats['pages_crawled'] += 1
            
            logger.info(f"Crawling {url} ({self.stats['pages_crawled']}/{max_pages})")
            
            html_content, metadata = self.fetch_page(url)
            if not html_content:
                continue
            
            try:
                # Clean HTML
                if self.config.get('post_processing', {}).get('clean_text', True):
                    html_content = self.clean_html(html_content)
                
                # Extract structured data
                extracted_data = self.extract_content(url, html_content)
                
                if extracted_data:
                    # Add metadata
                    extracted_data['url'] = url
                    extracted_data['crawl_timestamp'] = datetime.now().isoformat()
                    extracted_data['source_id'] = self.source_id
                    
                    extracted_items.append(extracted_data)
                    self.stats['successful_extractions'] += 1
                else:
                    self.stats['failed_extractions'] += 1
                
                # Extract links for further crawling
                new_links = self.extract_links(url, html_content)
                urls_to_visit.extend([link for link in new_links if link not in self.visited_urls])
                
            except Exception as e:
                logger.error(f"Error processing {url}: {str(e)}")
                self.stats['failed_extractions'] += 1
                self.stats['errors'].append({
                    'url': url,
                    'error': str(e),
                    'timestamp': datetime.now()
                })
        
        self.stats['end_time'] = datetime.now()
        self.stats['duration'] = (self.stats['end_time'] - self.stats['start_time']).total_seconds()
        
        logger.info(f"Crawl completed: {self.stats['successful_extractions']} items extracted, "
                   f"{self.stats['failed_extractions']} failures, "
                   f"{len(self.visited_urls)} pages visited")
        
        return extracted_items 