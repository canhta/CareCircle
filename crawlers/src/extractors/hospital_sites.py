"""
Vietnamese hospital website extractor.
"""

import re
from typing import Dict, List, Any, Generator
from urllib.parse import urljoin, urlparse
from bs4 import BeautifulSoup
from loguru import logger

from ..core.base_crawler import BaseCrawler


class HospitalSiteExtractor(BaseCrawler):
    """
    Specialized extractor for Vietnamese hospital websites.
    
    Handles medical information, treatment protocols, department information,
    patient guides, and hospital announcements.
    """
    
    def __init__(self, source_config: Dict[str, Any], settings: Dict[str, Any]):
        """Initialize hospital site extractor."""
        super().__init__(source_config, settings)
        
        # Hospital-specific patterns
        self.content_patterns = {
            "treatment": r"(điều trị|chữa trị|phương pháp)",
            "procedure": r"(quy trình|thủ tục|cách thức)",
            "department": r"(khoa|phòng|trung tâm|đơn vị)",
            "service": r"(dịch vụ|khám|chẩn đoán|xét nghiệm)"
        }
        
        # Medical specialties in Vietnamese
        self.medical_specialties = {
            "cardiology": ["tim mạch", "tim", "mạch máu"],
            "neurology": ["thần kinh", "não", "đột quỵ"],
            "oncology": ["ung thư", "ung bướu", "khối u"],
            "pediatrics": ["nhi", "trẻ em", "em bé"],
            "obstetrics": ["sản", "phụ khoa", "sinh đẻ"],
            "orthopedics": ["xương khớp", "chấn thương"],
            "gastroenterology": ["tiêu hóa", "dạ dày", "ruột"],
            "respiratory": ["hô hấp", "phổi", "hen suyễn"],
            "endocrinology": ["nội tiết", "tiểu đường", "tuyến giáp"],
            "dermatology": ["da liễu", "da", "nấm"],
            "ophthalmology": ["mắt", "nhãn khoa"],
            "ent": ["tai mũi họng", "tai", "mũi", "họng"],
            "emergency": ["cấp cứu", "응급", "khẩn cấp"],
            "surgery": ["phẫu thuật", "ngoại khoa"],
            "internal": ["nội khoa", "nội tổng hợp"]
        }
        
        logger.info("Initialized hospital site extractor")
    
    def get_urls_to_crawl(self) -> Generator[str, None, None]:
        """
        Generate URLs to crawl from hospital websites.
        
        Yields:
            URLs to crawl
        """
        # Start with configured start URLs
        start_urls = self.source_config.get("start_urls", [])
        
        for start_url in start_urls:
            yield from self._discover_urls_from_page(start_url)
            
            # Discover department/specialty pages
            yield from self._discover_department_urls(start_url)
    
    def _discover_urls_from_page(self, page_url: str) -> Generator[str, None, None]:
        """Discover URLs from a hospital page."""
        try:
            response = self._make_request(page_url)
            if not response:
                return
            
            soup = BeautifulSoup(response.content, 'html.parser')
            
            # Find content links using hospital-specific patterns
            content_selectors = [
                "article a[href]",
                ".news-item a[href]",
                ".service-item a[href]",
                ".department-item a[href]",
                ".medical-info a[href]",
                "[class*='tin-tuc'] a[href]",
                "[class*='dich-vu'] a[href]",
                "[class*='khoa'] a[href]",
                "h2 a[href]", "h3 a[href]"
            ]
            
            found_urls = set()
            
            for selector in content_selectors:
                links = soup.select(selector)
                for link in links:
                    href = link.get('href')
                    if href:
                        full_url = self._normalize_url(href)
                        if full_url and self._should_crawl_url(full_url):
                            found_urls.add(full_url)
            
            # Yield unique URLs
            for url in found_urls:
                yield url
                
        except Exception as e:
            logger.error(f"URL discovery failed for {page_url}: {e}")
    
    def _discover_department_urls(self, base_url: str) -> Generator[str, None, None]:
        """Discover department and specialty pages."""
        try:
            response = self._make_request(base_url)
            if not response:
                return
            
            soup = BeautifulSoup(response.content, 'html.parser')
            
            # Look for department/specialty navigation
            dept_selectors = [
                "nav a[href*='khoa']",
                "nav a[href*='chuyen-khoa']",
                ".menu a[href*='khoa']",
                ".navigation a[href*='khoa']",
                "a[href*='chuyen-khoa']",
                "a[href*='phong-kham']"
            ]
            
            dept_urls = set()
            
            for selector in dept_selectors:
                links = soup.select(selector)
                for link in links:
                    href = link.get('href')
                    if href:
                        full_url = self._normalize_url(href)
                        if full_url and self._is_department_url(full_url):
                            dept_urls.add(full_url)
            
            # Crawl department pages for content
            for dept_url in dept_urls:
                yield from self._discover_urls_from_page(dept_url)
                
        except Exception as e:
            logger.error(f"Department discovery failed for {base_url}: {e}")
    
    def _normalize_url(self, href: str) -> str:
        """Normalize URL to absolute form."""
        if href.startswith('http'):
            return href
        elif href.startswith('/'):
            return urljoin(self.base_url, href)
        else:
            return urljoin(self.base_url, '/' + href)
    
    def _should_crawl_url(self, url: str) -> bool:
        """Check if URL should be crawled."""
        # Parse URL
        parsed = urlparse(url)
        
        # Must be from the same domain
        base_domain = urlparse(self.base_url).netloc
        if parsed.netloc and parsed.netloc != base_domain:
            return False
        
        # Check exclude patterns
        exclude_patterns = self.source_config.get("exclude_patterns", [])
        for pattern in exclude_patterns:
            if re.search(pattern, url):
                return False
        
        # Must be a content URL
        return self._is_content_url(url)
    
    def _is_content_url(self, url: str) -> bool:
        """Check if URL is a content page."""
        content_indicators = [
            r"/tin-tuc/",
            r"/thong-tin/",
            r"/huong-dan/",
            r"/dich-vu/",
            r"/chuyen-khoa/",
            r"/khoa/",
            r"/bai-viet/",
            r"/chi-tiet/",
            r"\.html?$",
            r"/\d+/$",
            r"-\d+\.html?$"
        ]
        
        for pattern in content_indicators:
            if re.search(pattern, url, re.IGNORECASE):
                return True
        
        return False
    
    def _is_department_url(self, url: str) -> bool:
        """Check if URL is a department page."""
        dept_indicators = [
            r"/khoa/",
            r"/chuyen-khoa/",
            r"/phong-kham/",
            r"/trung-tam/",
            r"/don-vi/"
        ]
        
        for pattern in dept_indicators:
            if re.search(pattern, url, re.IGNORECASE):
                return True
        
        return False
    
    def _determine_content_type(self, url: str, title: str, content: str) -> str:
        """
        Determine content type for hospital content.
        
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
        if "/dich-vu/" in url_lower or "/service/" in url_lower:
            return "service"
        elif "/chuyen-khoa/" in url_lower or "/khoa/" in url_lower:
            return "department"
        elif "/huong-dan/" in url_lower or "/guide/" in url_lower:
            return "guide"
        elif "/tin-tuc/" in url_lower:
            return "news"
        
        # Check content patterns
        for content_type, pattern in self.content_patterns.items():
            if re.search(pattern, title_lower) or re.search(pattern, content_lower):
                return content_type
        
        # Default classification
        return "medical_info"
    
    def _extract_content(self, response, url: str) -> Dict[str, Any]:
        """
        Enhanced content extraction for hospital pages.
        
        Args:
            response: HTTP response object
            url: Source URL
            
        Returns:
            Extracted content with hospital-specific enhancements
        """
        # Use base extraction first
        base_content = super()._extract_content(response, url)
        if not base_content:
            return None
        
        try:
            soup = BeautifulSoup(response.content, 'html.parser')
            
            # Extract hospital-specific metadata
            hospital_metadata = self._extract_hospital_metadata(soup, url)
            
            # Enhance base content
            base_content["metadata"].update(hospital_metadata)
            
            # Determine medical specialty
            specialty = self._determine_medical_specialty(base_content["title"], base_content["content"])
            if specialty:
                base_content["metadata"]["medical_specialty"] = specialty
            
            # Extract contact information
            contact_info = self._extract_contact_info(soup)
            if contact_info:
                base_content["metadata"]["contact_info"] = contact_info
            
            # Extract doctor information
            doctor_info = self._extract_doctor_info(soup)
            if doctor_info:
                base_content["metadata"]["doctor_info"] = doctor_info
            
            # Authority score for hospitals (high authority for medical content)
            base_content["metadata"]["authority_score"] = 85
            
            return base_content
            
        except Exception as e:
            logger.error(f"Hospital-specific extraction failed for {url}: {e}")
            return base_content
    
    def _extract_hospital_metadata(self, soup: BeautifulSoup, url: str) -> Dict[str, Any]:
        """Extract hospital-specific metadata."""
        metadata = {}
        
        # Extract department/specialty
        dept_selectors = [
            ".department", ".specialty", ".khoa", ".chuyen-khoa",
            "[class*='department']", "[class*='khoa']"
        ]
        
        for selector in dept_selectors:
            dept_elem = soup.select_one(selector)
            if dept_elem:
                metadata["department"] = dept_elem.get_text(strip=True)
                break
        
        # Extract service type
        service_selectors = [
            ".service-type", ".dich-vu", ".loai-dich-vu",
            "[class*='service']", "[class*='dich-vu']"
        ]
        
        for selector in service_selectors:
            service_elem = soup.select_one(selector)
            if service_elem:
                metadata["service_type"] = service_elem.get_text(strip=True)
                break
        
        # Extract hospital name from breadcrumb or header
        hospital_selectors = [
            ".hospital-name", ".breadcrumb a:first-child", "h1",
            "[class*='hospital']", ".site-title"
        ]
        
        for selector in hospital_selectors:
            hospital_elem = soup.select_one(selector)
            if hospital_elem:
                hospital_name = hospital_elem.get_text(strip=True)
                if "bệnh viện" in hospital_name.lower() or "hospital" in hospital_name.lower():
                    metadata["hospital_name"] = hospital_name
                    break
        
        return metadata
    
    def _determine_medical_specialty(self, title: str, content: str) -> str:
        """Determine medical specialty based on content."""
        text = (title + " " + content).lower()
        
        # Score each specialty
        specialty_scores = {}
        
        for specialty, keywords in self.medical_specialties.items():
            score = 0
            for keyword in keywords:
                score += text.count(keyword)
            
            if score > 0:
                specialty_scores[specialty] = score
        
        # Return specialty with highest score
        if specialty_scores:
            return max(specialty_scores, key=specialty_scores.get)
        
        return "general"
    
    def _extract_contact_info(self, soup: BeautifulSoup) -> Dict[str, str]:
        """Extract contact information."""
        contact_info = {}
        
        # Extract phone numbers
        phone_pattern = r'(\+84|0)[0-9\s\-\.]{8,}'
        phone_elements = soup.find_all(text=re.compile(phone_pattern))
        
        for elem in phone_elements:
            match = re.search(phone_pattern, elem)
            if match:
                contact_info["phone"] = match.group().strip()
                break
        
        # Extract email
        email_pattern = r'[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}'
        email_elements = soup.find_all(text=re.compile(email_pattern))
        
        for elem in email_elements:
            match = re.search(email_pattern, elem)
            if match:
                contact_info["email"] = match.group().strip()
                break
        
        # Extract address
        address_selectors = [
            ".address", ".dia-chi", "[class*='address']",
            "[class*='dia-chi']", ".contact-address"
        ]
        
        for selector in address_selectors:
            addr_elem = soup.select_one(selector)
            if addr_elem:
                address = addr_elem.get_text(strip=True)
                if len(address) > 20:  # Only substantial addresses
                    contact_info["address"] = address
                    break
        
        return contact_info
    
    def _extract_doctor_info(self, soup: BeautifulSoup) -> List[Dict[str, str]]:
        """Extract doctor information."""
        doctors = []
        
        # Look for doctor sections
        doctor_selectors = [
            ".doctor", ".bac-si", ".physician", "[class*='doctor']",
            "[class*='bac-si']", ".staff-member"
        ]
        
        for selector in doctor_selectors:
            doctor_elements = soup.select(selector)
            
            for elem in doctor_elements:
                doctor_info = {}
                
                # Extract name
                name_elem = elem.select_one("h3, h4, .name, .ten, [class*='name']")
                if name_elem:
                    doctor_info["name"] = name_elem.get_text(strip=True)
                
                # Extract title/position
                title_elem = elem.select_one(".title, .chuc-vu, .position, [class*='title']")
                if title_elem:
                    doctor_info["title"] = title_elem.get_text(strip=True)
                
                # Extract specialty
                specialty_elem = elem.select_one(".specialty, .chuyen-khoa, [class*='specialty']")
                if specialty_elem:
                    doctor_info["specialty"] = specialty_elem.get_text(strip=True)
                
                if doctor_info.get("name"):
                    doctors.append(doctor_info)
        
        return doctors[:5]  # Limit to 5 doctors
