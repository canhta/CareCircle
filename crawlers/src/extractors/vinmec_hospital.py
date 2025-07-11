"""
Vinmec International Hospital extractor.
"""

import re
from typing import Dict, List, Any, Generator
from urllib.parse import urljoin, urlparse
from bs4 import BeautifulSoup
from loguru import logger

from ..core.base_crawler import BaseCrawler


class VinmecExtractor(BaseCrawler):
    """
    Specialized extractor for Vinmec International Hospital website.
    
    Handles medical articles, health guides, service information,
    doctor profiles, and Vinmec-specific medical content.
    """
    
    def __init__(self, source_config: Dict[str, Any], settings: Dict[str, Any]):
        """Initialize Vinmec extractor."""
        super().__init__(source_config, settings)
        
        # Vinmec-specific patterns
        self.content_patterns = {
            "health_guide": r"(hướng dẫn|cách chăm sóc|lời khuyên)",
            "medical_article": r"(bệnh|triệu chứng|điều trị|chẩn đoán)",
            "service_info": r"(dịch vụ|khám|xét nghiệm|phẫu thuật)",
            "doctor_profile": r"(bác sĩ|tiến sĩ|thạc sĩ|giáo sư)"
        }
        
        # Vinmec medical specialties and services
        self.vinmec_specialties = {
            "cardiology": ["tim mạch", "tim", "mạch vành", "huyết áp", "nhồi máu cơ tim"],
            "oncology": ["ung thư", "ung bướu", "khối u", "hóa trị", "xạ trị", "ác tính"],
            "neurology": ["thần kinh", "não", "đột quỵ", "parkinson", "alzheimer"],
            "orthopedics": ["xương khớp", "cột sống", "gãy xương", "chấn thương"],
            "pediatrics": ["nhi khoa", "trẻ em", "em bé", "vaccine", "dinh dưỡng trẻ"],
            "obstetrics": ["sản phụ khoa", "thai", "sinh", "mang thai", "phụ nữ"],
            "gastroenterology": ["tiêu hóa", "dạ dày", "gan", "ruột", "đại tràng"],
            "respiratory": ["hô hấp", "phổi", "hen suyễn", "copd", "lao"],
            "endocrinology": ["nội tiết", "tiểu đường", "tuyến giáp", "hormone"],
            "dermatology": ["da liễu", "da", "nấm", "viêm da", "dị ứng"],
            "ophthalmology": ["mắt", "nhãn khoa", "cận thị", "đục thủy tinh thể"],
            "ent": ["tai mũi họng", "viêm xoang", "viêm amidan", "nghe kém"],
            "urology": ["tiết niệu", "thận", "bàng quang", "tuyến tiền liệt"],
            "emergency": ["cấp cứu", "응급", "khẩn cấp", "tai nạn"],
            "checkup": ["khám tổng quát", "sức khỏe", "tầm soát", "kiểm tra"]
        }
        
        # Vinmec locations
        self.vinmec_locations = [
            "vinmec central park", "vinmec times city", "vinmec royal city",
            "vinmec smart city", "vinmec nha trang", "vinmec da nang",
            "vinmec hai phong", "vinmec phu quoc"
        ]
        
        logger.info("Initialized Vinmec Hospital extractor")
    
    def get_urls_to_crawl(self) -> Generator[str, None, None]:
        """
        Generate URLs to crawl from Vinmec website.
        
        Yields:
            URLs to crawl
        """
        # Start with configured start URLs
        start_urls = self.source_config.get("start_urls", [])
        
        for start_url in start_urls:
            yield from self._discover_urls_from_page(start_url)
            
            # Discover specialty pages
            yield from self._discover_specialty_urls(start_url)
            
            # Discover doctor profile pages
            yield from self._discover_doctor_urls(start_url)
    
    def _discover_urls_from_page(self, page_url: str) -> Generator[str, None, None]:
        """Discover URLs from a Vinmec page."""
        try:
            response = self._make_request(page_url)
            if not response:
                return
            
            soup = BeautifulSoup(response.content, 'html.parser')
            
            # Find content links using Vinmec-specific patterns
            content_selectors = [
                # Article links
                "article a[href]",
                ".article-item a[href]",
                ".news-item a[href]",
                ".post-item a[href]",
                
                # Health guide links
                ".health-guide a[href]",
                ".medical-article a[href]",
                
                # Service links
                ".service-item a[href]",
                ".specialty-item a[href]",
                
                # Doctor profile links
                ".doctor-item a[href]",
                ".doctor-profile a[href]",
                
                # General content links
                "h2 a[href]", "h3 a[href]", "h4 a[href]",
                "[class*='title'] a[href]",
                "[class*='link'] a[href]"
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
    
    def _discover_specialty_urls(self, base_url: str) -> Generator[str, None, None]:
        """Discover Vinmec specialty and service pages."""
        try:
            response = self._make_request(base_url)
            if not response:
                return
            
            soup = BeautifulSoup(response.content, 'html.parser')
            
            # Look for specialty navigation
            specialty_selectors = [
                "nav a[href*='chuyen-khoa']",
                "nav a[href*='dich-vu']",
                ".menu a[href*='chuyen-khoa']",
                ".navigation a[href*='dich-vu']",
                "a[href*='specialty']",
                "a[href*='service']",
                "a[href*='kham-benh']",
                "a[href*='phau-thuat']"
            ]
            
            specialty_urls = set()
            
            for selector in specialty_selectors:
                links = soup.select(selector)
                for link in links:
                    href = link.get('href')
                    if href:
                        full_url = self._normalize_url(href)
                        if full_url and self._is_specialty_url(full_url):
                            specialty_urls.add(full_url)
            
            # Crawl specialty pages for content
            for specialty_url in specialty_urls:
                yield from self._discover_urls_from_page(specialty_url)
                
        except Exception as e:
            logger.error(f"Specialty discovery failed for {base_url}: {e}")
    
    def _discover_doctor_urls(self, base_url: str) -> Generator[str, None, None]:
        """Discover Vinmec doctor profile pages."""
        try:
            response = self._make_request(base_url)
            if not response:
                return
            
            soup = BeautifulSoup(response.content, 'html.parser')
            
            # Look for doctor directory links
            doctor_selectors = [
                "a[href*='bac-si']",
                "a[href*='doctor']",
                "a[href*='physician']",
                ".doctor-list a[href]",
                ".physician-list a[href]",
                "[class*='doctor'] a[href]"
            ]
            
            doctor_urls = set()
            
            for selector in doctor_selectors:
                links = soup.select(selector)
                for link in links:
                    href = link.get('href')
                    if href:
                        full_url = self._normalize_url(href)
                        if full_url and self._is_doctor_url(full_url):
                            doctor_urls.add(full_url)
            
            # Yield doctor profile URLs
            for doctor_url in doctor_urls:
                yield doctor_url
                
        except Exception as e:
            logger.error(f"Doctor discovery failed for {base_url}: {e}")
    
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
        
        # Must be from Vinmec domain
        if parsed.netloc and 'vinmec.com' not in parsed.netloc:
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
            r"/bai-viet/",
            r"/tin-tuc/",
            r"/suc-khoe/",
            r"/benh-hoc/",
            r"/chuyen-khoa/",
            r"/dich-vu/",
            r"/bac-si/",
            r"/huong-dan/",
            r"/kien-thuc/",
            r"\.html?$",
            r"/\d+/$",
            r"-\d+\.html?$"
        ]
        
        for pattern in content_indicators:
            if re.search(pattern, url, re.IGNORECASE):
                return True
        
        return False
    
    def _is_specialty_url(self, url: str) -> bool:
        """Check if URL is a specialty page."""
        specialty_indicators = [
            r"/chuyen-khoa/",
            r"/dich-vu/",
            r"/specialty/",
            r"/service/",
            r"/kham-benh/",
            r"/phau-thuat/"
        ]
        
        for pattern in specialty_indicators:
            if re.search(pattern, url, re.IGNORECASE):
                return True
        
        return False
    
    def _is_doctor_url(self, url: str) -> bool:
        """Check if URL is a doctor profile page."""
        doctor_indicators = [
            r"/bac-si/",
            r"/doctor/",
            r"/physician/",
            r"/bs-"
        ]
        
        for pattern in doctor_indicators:
            if re.search(pattern, url, re.IGNORECASE):
                return True
        
        return False
    
    def _determine_content_type(self, url: str, title: str, content: str) -> str:
        """
        Determine content type for Vinmec content.
        
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
        if "/bac-si/" in url_lower or "/doctor/" in url_lower:
            return "doctor_profile"
        elif "/dich-vu/" in url_lower or "/service/" in url_lower:
            return "service"
        elif "/chuyen-khoa/" in url_lower or "/specialty/" in url_lower:
            return "specialty"
        elif "/huong-dan/" in url_lower or "/guide/" in url_lower:
            return "health_guide"
        elif "/tin-tuc/" in url_lower:
            return "news"
        
        # Check content patterns
        for content_type, pattern in self.content_patterns.items():
            if re.search(pattern, title_lower) or re.search(pattern, content_lower):
                return content_type
        
        # Default classification
        return "medical_article"

    def _extract_content(self, response, url: str) -> Dict[str, Any]:
        """
        Enhanced content extraction for Vinmec pages.

        Args:
            response: HTTP response object
            url: Source URL

        Returns:
            Extracted content with Vinmec-specific enhancements
        """
        # Use base extraction first
        base_content = super()._extract_content(response, url)
        if not base_content:
            return None

        try:
            soup = BeautifulSoup(response.content, 'html.parser')

            # Extract Vinmec-specific metadata
            vinmec_metadata = self._extract_vinmec_metadata(soup, url)

            # Enhance base content
            base_content["metadata"].update(vinmec_metadata)

            # Determine Vinmec specialty
            vinmec_specialty = self._determine_vinmec_specialty(base_content["title"], base_content["content"])
            if vinmec_specialty:
                base_content["metadata"]["vinmec_specialty"] = vinmec_specialty

            # Extract doctor information (if doctor profile)
            if self._is_doctor_url(url):
                doctor_info = self._extract_doctor_profile(soup)
                if doctor_info:
                    base_content["metadata"]["doctor_profile"] = doctor_info

            # Extract service information (if service page)
            if self._is_specialty_url(url):
                service_info = self._extract_service_info(soup)
                if service_info:
                    base_content["metadata"]["service_info"] = service_info

            # Extract Vinmec location
            location = self._extract_vinmec_location(soup, base_content["content"])
            if location:
                base_content["metadata"]["vinmec_location"] = location

            # Extract medical procedures/treatments
            procedures = self._extract_medical_procedures(soup, base_content["content"])
            if procedures:
                base_content["metadata"]["medical_procedures"] = procedures

            # Authority score for Vinmec (high authority private hospital)
            base_content["metadata"]["authority_score"] = 88

            # Add Vinmec-specific tags
            base_content["metadata"]["hospital_chain"] = "vinmec"
            base_content["metadata"]["hospital_type"] = "private_international"

            return base_content

        except Exception as e:
            logger.error(f"Vinmec-specific extraction failed for {url}: {e}")
            return base_content

    def _extract_vinmec_metadata(self, soup: BeautifulSoup, url: str) -> Dict[str, Any]:
        """Extract Vinmec-specific metadata."""
        metadata = {}

        # Extract department/specialty
        dept_selectors = [
            ".specialty", ".department", ".chuyen-khoa", ".khoa",
            "[class*='specialty']", "[class*='department']",
            ".breadcrumb a:nth-last-child(2)"  # Second to last breadcrumb
        ]

        for selector in dept_selectors:
            dept_elem = soup.select_one(selector)
            if dept_elem:
                dept_text = dept_elem.get_text(strip=True)
                if len(dept_text) > 3 and len(dept_text) < 100:
                    metadata["department"] = dept_text
                    break

        # Extract article category
        category_selectors = [
            ".category", ".tag", ".label", ".badge",
            "[class*='category']", "[class*='tag']"
        ]

        for selector in category_selectors:
            category_elem = soup.select_one(selector)
            if category_elem:
                category = category_elem.get_text(strip=True)
                if len(category) > 2 and len(category) < 50:
                    metadata["article_category"] = category
                    break

        # Extract reading time
        reading_time_selectors = [
            ".reading-time", ".read-time", "[class*='time']"
        ]

        for selector in reading_time_selectors:
            time_elem = soup.select_one(selector)
            if time_elem:
                time_text = time_elem.get_text(strip=True)
                time_match = re.search(r'(\d+)\s*(phút|minute)', time_text, re.IGNORECASE)
                if time_match:
                    metadata["reading_time_minutes"] = int(time_match.group(1))
                    break

        # Extract last updated date
        updated_selectors = [
            ".updated", ".last-modified", ".modified-date",
            "[class*='updated']", "[class*='modified']"
        ]

        for selector in updated_selectors:
            updated_elem = soup.select_one(selector)
            if updated_elem:
                updated_text = updated_elem.get_text(strip=True)
                metadata["last_updated"] = updated_text
                break

        return metadata

    def _determine_vinmec_specialty(self, title: str, content: str) -> str:
        """Determine Vinmec medical specialty based on content."""
        text = (title + " " + content).lower()

        # Score each specialty
        specialty_scores = {}

        for specialty, keywords in self.vinmec_specialties.items():
            score = 0
            for keyword in keywords:
                score += text.count(keyword)

            if score > 0:
                specialty_scores[specialty] = score

        # Return specialty with highest score
        if specialty_scores:
            return max(specialty_scores, key=specialty_scores.get)

        return "general"

    def _extract_doctor_profile(self, soup: BeautifulSoup) -> Dict[str, Any]:
        """Extract doctor profile information."""
        doctor_info = {}

        # Extract doctor name
        name_selectors = [
            "h1", ".doctor-name", ".physician-name", ".name",
            "[class*='doctor-name']", "[class*='name']"
        ]

        for selector in name_selectors:
            name_elem = soup.select_one(selector)
            if name_elem:
                name = name_elem.get_text(strip=True)
                if any(title in name.lower() for title in ["bs", "ts", "ths", "pgs", "gs"]):
                    doctor_info["name"] = name
                    break

        # Extract specialties
        specialty_selectors = [
            ".specialty", ".specialization", ".chuyen-khoa",
            "[class*='specialty']", "[class*='specialization']"
        ]

        specialties = []
        for selector in specialty_selectors:
            specialty_elems = soup.select(selector)
            for elem in specialty_elems:
                specialty = elem.get_text(strip=True)
                if len(specialty) > 5 and len(specialty) < 100:
                    specialties.append(specialty)

        if specialties:
            doctor_info["specialties"] = specialties[:3]  # Limit to 3

        # Extract education
        education_selectors = [
            ".education", ".degree", ".qualification",
            "[class*='education']", "[class*='degree']"
        ]

        education = []
        for selector in education_selectors:
            edu_elems = soup.select(selector)
            for elem in edu_elems:
                edu_text = elem.get_text(strip=True)
                if len(edu_text) > 10:
                    education.append(edu_text)

        if education:
            doctor_info["education"] = education[:3]  # Limit to 3

        # Extract experience
        experience_selectors = [
            ".experience", ".years", ".kinh-nghiem",
            "[class*='experience']", "[class*='years']"
        ]

        for selector in experience_selectors:
            exp_elem = soup.select_one(selector)
            if exp_elem:
                exp_text = exp_elem.get_text(strip=True)
                # Look for year patterns
                year_match = re.search(r'(\d+)\s*(năm|year)', exp_text, re.IGNORECASE)
                if year_match:
                    doctor_info["years_experience"] = int(year_match.group(1))
                    break

        # Extract languages
        language_selectors = [
            ".languages", ".language", ".ngon-ngu",
            "[class*='language']", "[class*='ngon-ngu']"
        ]

        for selector in language_selectors:
            lang_elem = soup.select_one(selector)
            if lang_elem:
                languages = lang_elem.get_text(strip=True)
                doctor_info["languages"] = languages
                break

        return doctor_info

    def _extract_service_info(self, soup: BeautifulSoup) -> Dict[str, Any]:
        """Extract service/specialty information."""
        service_info = {}

        # Extract service name
        service_name_selectors = [
            "h1", ".service-name", ".specialty-name",
            "[class*='service-name']", "[class*='specialty']"
        ]

        for selector in service_name_selectors:
            name_elem = soup.select_one(selector)
            if name_elem:
                service_info["service_name"] = name_elem.get_text(strip=True)
                break

        # Extract service description
        desc_selectors = [
            ".service-description", ".description", ".intro",
            "[class*='description']", "[class*='intro']"
        ]

        for selector in desc_selectors:
            desc_elem = soup.select_one(selector)
            if desc_elem:
                description = desc_elem.get_text(strip=True)
                if len(description) > 50:
                    service_info["description"] = description[:500]  # Limit length
                    break

        # Extract procedures offered
        procedure_selectors = [
            ".procedures", ".treatments", ".services-list",
            "[class*='procedure']", "[class*='treatment']"
        ]

        procedures = []
        for selector in procedure_selectors:
            proc_elems = soup.select(f"{selector} li, {selector} .item")
            for elem in proc_elems:
                proc_text = elem.get_text(strip=True)
                if len(proc_text) > 5 and len(proc_text) < 200:
                    procedures.append(proc_text)

        if procedures:
            service_info["procedures"] = procedures[:10]  # Limit to 10

        # Extract equipment/technology
        equipment_selectors = [
            ".equipment", ".technology", ".facilities",
            "[class*='equipment']", "[class*='technology']"
        ]

        equipment = []
        for selector in equipment_selectors:
            equip_elems = soup.select(f"{selector} li, {selector} .item")
            for elem in equip_elems:
                equip_text = elem.get_text(strip=True)
                if len(equip_text) > 5:
                    equipment.append(equip_text)

        if equipment:
            service_info["equipment"] = equipment[:5]  # Limit to 5

        return service_info

    def _extract_vinmec_location(self, soup: BeautifulSoup, content: str) -> str:
        """Extract Vinmec location/branch information."""
        content_lower = content.lower()

        # Check for location mentions in content
        for location in self.vinmec_locations:
            if location.lower() in content_lower:
                return location

        # Check for location in page elements
        location_selectors = [
            ".location", ".branch", ".hospital",
            "[class*='location']", "[class*='branch']"
        ]

        for selector in location_selectors:
            location_elem = soup.select_one(selector)
            if location_elem:
                location_text = location_elem.get_text(strip=True).lower()
                for location in self.vinmec_locations:
                    if location.lower() in location_text:
                        return location

        return None

    def _extract_medical_procedures(self, soup: BeautifulSoup, content: str) -> List[str]:
        """Extract medical procedures mentioned in content."""
        procedures = []

        # Common Vietnamese medical procedures
        procedure_keywords = [
            "phẫu thuật", "mổ", "cắt", "ghép", "nội soi", "chụp", "siêu âm",
            "xét nghiệm", "sinh thiết", "tạo hình", "thay khớp", "bypass",
            "stent", "laser", "robot", "vi phẫu", "nội soi", "laparoscopy"
        ]

        content_lower = content.lower()

        # Find procedure mentions
        for keyword in procedure_keywords:
            if keyword in content_lower:
                # Extract context around the keyword
                pattern = rf'.{{0,30}}{re.escape(keyword)}.{{0,30}}'
                matches = re.finditer(pattern, content_lower)
                for match in matches:
                    procedure_context = match.group().strip()
                    if len(procedure_context) > 10:
                        procedures.append(procedure_context)

        # Also check for procedure lists in HTML
        procedure_selectors = [
            ".procedures li", ".treatments li", ".services li",
            "[class*='procedure'] li", "[class*='treatment'] li"
        ]

        for selector in procedure_selectors:
            proc_elems = soup.select(selector)
            for elem in proc_elems:
                proc_text = elem.get_text(strip=True)
                if len(proc_text) > 5 and len(proc_text) < 100:
                    procedures.append(proc_text)

        # Remove duplicates and limit
        unique_procedures = list(dict.fromkeys(procedures))  # Preserve order
        return unique_procedures[:8]
