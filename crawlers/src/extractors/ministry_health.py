"""
Ministry of Health (Bộ Y tế) content extractor.
"""

import re
from typing import Dict, List, Any, Generator
from urllib.parse import urljoin, urlparse
from bs4 import BeautifulSoup
from loguru import logger

from ..core.base_crawler import BaseCrawler


class MinistryHealthExtractor(BaseCrawler):
    """
    Specialized extractor for Vietnam Ministry of Health website.
    
    Handles government health policies, treatment guidelines,
    official announcements, and medical regulations.
    """
    
    def __init__(self, source_config: Dict[str, Any], settings: Dict[str, Any]):
        """Initialize Ministry of Health extractor."""
        super().__init__(source_config, settings)
        
        # Ministry-specific patterns
        self.content_patterns = {
            "policy": r"(chính sách|quy định|thông tư|nghị định)",
            "guideline": r"(hướng dẫn|quy trình|tiêu chuẩn)",
            "announcement": r"(thông báo|công bố|thông tin)",
            "regulation": r"(quy định|quy chế|điều lệ)"
        }
        
        # URL patterns to prioritize
        self.priority_patterns = [
            r"/van-ban/",
            r"/tin-tuc/",
            r"/hoat-dong-chuyen-mon/",
            r"/chinh-sach/",
            r"/huong-dan/"
        ]
        
        logger.info("Initialized Ministry of Health extractor")
    
    def get_urls_to_crawl(self) -> Generator[str, None, None]:
        """
        Generate URLs to crawl from Ministry of Health website.
        
        Yields:
            URLs to crawl
        """
        # Start with configured start URLs
        start_urls = self.source_config.get("start_urls", [])
        
        for start_url in start_urls:
            yield from self._discover_urls_from_page(start_url)
    
    def _discover_urls_from_page(self, page_url: str) -> Generator[str, None, None]:
        """Discover URLs from a page."""
        try:
            response = self._make_request(page_url)
            if not response:
                return
            
            soup = BeautifulSoup(response.content, 'html.parser')
            
            # Find all links
            links = soup.find_all('a', href=True)
            
            for link in links:
                href = link['href']
                
                # Convert relative URLs to absolute
                if href.startswith('/'):
                    full_url = urljoin(self.base_url, href)
                elif href.startswith('http'):
                    full_url = href
                else:
                    continue
                
                # Filter URLs
                if self._should_crawl_url(full_url):
                    yield full_url
                    
                    # Also discover from article listing pages
                    if self._is_listing_page(full_url):
                        yield from self._discover_urls_from_page(full_url)
        
        except Exception as e:
            logger.error(f"URL discovery failed for {page_url}: {e}")
    
    def _should_crawl_url(self, url: str) -> bool:
        """Check if URL should be crawled."""
        # Parse URL
        parsed = urlparse(url)
        
        # Must be from the same domain
        if parsed.netloc and parsed.netloc not in self.base_url:
            return False
        
        # Check exclude patterns
        exclude_patterns = self.source_config.get("exclude_patterns", [])
        for pattern in exclude_patterns:
            if re.search(pattern, url):
                return False
        
        # Check if it's a content page
        if self._is_content_page(url):
            return True
        
        # Check if it's a listing page we should explore
        if self._is_listing_page(url):
            return True
        
        return False
    
    def _is_content_page(self, url: str) -> bool:
        """Check if URL is a content page."""
        # Look for article/content indicators
        content_indicators = [
            r"/chi-tiet/",
            r"/bai-viet/",
            r"/tin-tuc/.*\d+",
            r"/van-ban/.*\d+",
            r"/thong-tin/.*\d+",
            r"\.html$",
            r"\.htm$"
        ]
        
        for pattern in content_indicators:
            if re.search(pattern, url, re.IGNORECASE):
                return True
        
        return False
    
    def _is_listing_page(self, url: str) -> bool:
        """Check if URL is a listing page."""
        listing_indicators = [
            r"/tin-tuc/?$",
            r"/van-ban/?$",
            r"/hoat-dong-chuyen-mon/?$",
            r"/danh-muc/",
            r"/chuyen-muc/",
            r"page=\d+",
            r"trang-\d+"
        ]
        
        for pattern in listing_indicators:
            if re.search(pattern, url, re.IGNORECASE):
                return True
        
        return False
    
    def _determine_content_type(self, url: str, title: str, content: str) -> str:
        """
        Determine content type for Ministry of Health content.
        
        Args:
            url: Source URL
            title: Content title
            content: Content text
            
        Returns:
            Content type classification
        """
        url_lower = url.lower()
        title_lower = title.lower()
        content_lower = content.lower()
        
        # Check URL patterns first
        if "/van-ban/" in url_lower:
            return "regulation"
        elif "/tin-tuc/" in url_lower:
            return "news"
        elif "/hoat-dong-chuyen-mon/" in url_lower:
            return "guideline"
        elif "/chinh-sach/" in url_lower:
            return "policy"
        
        # Check content patterns
        for content_type, pattern in self.content_patterns.items():
            if re.search(pattern, title_lower) or re.search(pattern, content_lower):
                return content_type
        
        # Default classification
        return "article"
    
    def _extract_content(self, response, url: str) -> Dict[str, Any]:
        """
        Enhanced content extraction for Ministry of Health pages.
        
        Args:
            response: HTTP response object
            url: Source URL
            
        Returns:
            Extracted content with Ministry-specific enhancements
        """
        # Use base extraction first
        base_content = super()._extract_content(response, url)
        if not base_content:
            return None
        
        try:
            soup = BeautifulSoup(response.content, 'html.parser')
            
            # Extract Ministry-specific metadata
            ministry_metadata = self._extract_ministry_metadata(soup, url)
            
            # Enhance base content
            base_content["metadata"].update(ministry_metadata)
            
            # Add authority score (government source = high authority)
            base_content["metadata"]["authority_score"] = 95
            
            # Extract document number if available
            doc_number = self._extract_document_number(soup, base_content["title"])
            if doc_number:
                base_content["metadata"]["document_number"] = doc_number
            
            # Extract effective date for regulations
            effective_date = self._extract_effective_date(soup, base_content["content"])
            if effective_date:
                base_content["metadata"]["effective_date"] = effective_date
            
            # Extract related documents
            related_docs = self._extract_related_documents(soup)
            if related_docs:
                base_content["metadata"]["related_documents"] = related_docs
            
            return base_content
            
        except Exception as e:
            logger.error(f"Ministry-specific extraction failed for {url}: {e}")
            return base_content
    
    def _extract_ministry_metadata(self, soup: BeautifulSoup, url: str) -> Dict[str, Any]:
        """Extract Ministry of Health specific metadata."""
        metadata = {}
        
        # Extract department/division
        dept_selectors = [
            ".department", ".phong-ban", ".don-vi",
            "[class*='department']", "[class*='phong-ban']"
        ]
        
        for selector in dept_selectors:
            dept_elem = soup.select_one(selector)
            if dept_elem:
                metadata["department"] = dept_elem.get_text(strip=True)
                break
        
        # Extract document type
        doc_type_selectors = [
            ".doc-type", ".loai-van-ban", ".document-type",
            "[class*='doc-type']", "[class*='loai-van-ban']"
        ]
        
        for selector in doc_type_selectors:
            doc_type_elem = soup.select_one(selector)
            if doc_type_elem:
                metadata["document_type"] = doc_type_elem.get_text(strip=True)
                break
        
        # Extract signer information
        signer_selectors = [
            ".signer", ".nguoi-ky", ".signature",
            "[class*='signer']", "[class*='nguoi-ky']"
        ]
        
        for selector in signer_selectors:
            signer_elem = soup.select_one(selector)
            if signer_elem:
                metadata["signer"] = signer_elem.get_text(strip=True)
                break
        
        return metadata
    
    def _extract_document_number(self, soup: BeautifulSoup, title: str) -> str:
        """Extract official document number."""
        # Common Vietnamese document number patterns
        patterns = [
            r"số\s*(\d+/\d+/[A-Z-]+)",
            r"(\d+/\d+/[A-Z-]+)",
            r"số\s*(\d+/[A-Z-]+)",
            r"(\d+/QĐ-[A-Z]+)",
            r"(\d+/TT-[A-Z]+)",
            r"(\d+/NĐ-[A-Z]+)"
        ]
        
        # Check title first
        for pattern in patterns:
            match = re.search(pattern, title, re.IGNORECASE)
            if match:
                return match.group(1)
        
        # Check document content
        doc_number_elem = soup.select_one(".doc-number, .so-van-ban, [class*='doc-number']")
        if doc_number_elem:
            doc_text = doc_number_elem.get_text(strip=True)
            for pattern in patterns:
                match = re.search(pattern, doc_text, re.IGNORECASE)
                if match:
                    return match.group(1)
        
        return None
    
    def _extract_effective_date(self, soup: BeautifulSoup, content: str) -> str:
        """Extract effective date for regulations."""
        # Look for effective date patterns
        date_patterns = [
            r"có hiệu lực từ\s*ngày\s*(\d{1,2}/\d{1,2}/\d{4})",
            r"hiệu lực\s*:\s*(\d{1,2}/\d{1,2}/\d{4})",
            r"áp dụng từ\s*(\d{1,2}/\d{1,2}/\d{4})"
        ]
        
        for pattern in date_patterns:
            match = re.search(pattern, content, re.IGNORECASE)
            if match:
                return match.group(1)
        
        # Check specific elements
        date_elem = soup.select_one(".effective-date, .ngay-hieu-luc, [class*='effective']")
        if date_elem:
            date_text = date_elem.get_text(strip=True)
            for pattern in date_patterns:
                match = re.search(pattern, date_text, re.IGNORECASE)
                if match:
                    return match.group(1)
        
        return None
    
    def _extract_related_documents(self, soup: BeautifulSoup) -> List[str]:
        """Extract related documents."""
        related_docs = []
        
        # Look for related document sections
        related_sections = soup.select(".related-docs, .van-ban-lien-quan, [class*='related']")
        
        for section in related_sections:
            links = section.find_all('a', href=True)
            for link in links:
                doc_title = link.get_text(strip=True)
                if doc_title and len(doc_title) > 10:
                    related_docs.append(doc_title)
        
        return related_docs[:5]  # Limit to 5 related documents
