"""
Vietnamese health news portal extractor.
"""

import re
from typing import Dict, List, Any, Generator
from urllib.parse import urljoin, urlparse
from bs4 import BeautifulSoup
from loguru import logger

from ..core.base_crawler import BaseCrawler


class HealthNewsExtractor(BaseCrawler):
    """
    Specialized extractor for Vietnamese health news portals.
    
    Handles health news, medical research updates, wellness articles,
    and health-related information from news websites.
    """
    
    def __init__(self, source_config: Dict[str, Any], settings: Dict[str, Any]):
        """Initialize health news extractor."""
        super().__init__(source_config, settings)
        
        # News-specific patterns
        self.content_patterns = {
            "news": r"(tin tức|bài viết|báo cáo)",
            "research": r"(nghiên cứu|khoa học|phát hiện)",
            "advice": r"(lời khuyên|hướng dẫn|cách)",
            "prevention": r"(phòng ngừa|dự phòng|tránh)"
        }
        
        # Health topic categories
        self.health_categories = {
            "nutrition": ["dinh dưỡng", "ăn uống", "thực phẩm", "vitamin"],
            "fitness": ["thể dục", "tập luyện", "vận động", "gym"],
            "mental_health": ["tâm lý", "stress", "trầm cảm", "lo âu"],
            "disease": ["bệnh", "triệu chứng", "điều trị", "chữa"],
            "prevention": ["phòng ngừa", "vaccine", "tiêm chủng", "dự phòng"],
            "women_health": ["phụ nữ", "mang thai", "sinh đẻ", "kinh nguyệt"],
            "children_health": ["trẻ em", "nhi", "em bé", "trẻ nhỏ"],
            "elderly_health": ["người già", "cao tuổi", "lão khoa"]
        }
        
        logger.info("Initialized health news extractor")
    
    def get_urls_to_crawl(self) -> Generator[str, None, None]:
        """
        Generate URLs to crawl from health news portals.
        
        Yields:
            URLs to crawl
        """
        # Start with configured start URLs
        start_urls = self.source_config.get("start_urls", [])
        
        for start_url in start_urls:
            yield from self._discover_urls_from_page(start_url)
            
            # Also discover from pagination
            yield from self._discover_paginated_urls(start_url)
    
    def _discover_urls_from_page(self, page_url: str) -> Generator[str, None, None]:
        """Discover article URLs from a news page."""
        try:
            response = self._make_request(page_url)
            if not response:
                return
            
            soup = BeautifulSoup(response.content, 'html.parser')
            
            # Find article links using common news patterns
            article_selectors = [
                "article a[href]",
                ".article-title a[href]",
                ".news-item a[href]",
                ".post-title a[href]",
                "h2 a[href]", "h3 a[href]",
                "[class*='title'] a[href]",
                "[class*='headline'] a[href]"
            ]
            
            found_urls = set()
            
            for selector in article_selectors:
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
    
    def _discover_paginated_urls(self, base_url: str) -> Generator[str, None, None]:
        """Discover URLs from paginated news listings."""
        try:
            response = self._make_request(base_url)
            if not response:
                return
            
            soup = BeautifulSoup(response.content, 'html.parser')
            
            # Find pagination links
            pagination_selectors = [
                ".pagination a[href]",
                ".pager a[href]",
                "[class*='page'] a[href]",
                "a[href*='page=']",
                "a[href*='trang=']"
            ]
            
            page_urls = set()
            
            for selector in pagination_selectors:
                links = soup.select(selector)
                for link in links:
                    href = link.get('href')
                    if href:
                        full_url = self._normalize_url(href)
                        if full_url and self._is_pagination_url(full_url):
                            page_urls.add(full_url)
            
            # Crawl pagination pages (limit to avoid infinite loops)
            for i, page_url in enumerate(page_urls):
                if i >= 5:  # Limit to 5 pagination pages
                    break
                yield from self._discover_urls_from_page(page_url)
                
        except Exception as e:
            logger.error(f"Pagination discovery failed for {base_url}: {e}")
    
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
        
        # Must be from the same domain or allowed domains
        base_domain = urlparse(self.base_url).netloc
        if parsed.netloc and parsed.netloc != base_domain:
            return False
        
        # Check exclude patterns
        exclude_patterns = self.source_config.get("exclude_patterns", [])
        for pattern in exclude_patterns:
            if re.search(pattern, url):
                return False
        
        # Must be an article URL
        return self._is_article_url(url)
    
    def _is_article_url(self, url: str) -> bool:
        """Check if URL is an article page."""
        article_indicators = [
            r"/bai-viet/",
            r"/tin-tuc/",
            r"/suc-khoe/",
            r"/benh-hoc/",
            r"/dinh-duong/",
            r"/\d+\.html?$",
            r"/\d+/$",
            r"-\d+\.html?$",
            r"\.html?$"
        ]
        
        for pattern in article_indicators:
            if re.search(pattern, url, re.IGNORECASE):
                return True
        
        return False
    
    def _is_pagination_url(self, url: str) -> bool:
        """Check if URL is a pagination page."""
        pagination_indicators = [
            r"page=\d+",
            r"trang=\d+",
            r"/page/\d+",
            r"/trang-\d+"
        ]
        
        for pattern in pagination_indicators:
            if re.search(pattern, url, re.IGNORECASE):
                return True
        
        return False
    
    def _determine_content_type(self, url: str, title: str, content: str) -> str:
        """
        Determine content type for health news content.
        
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
        
        # Check for research content
        research_keywords = ["nghiên cứu", "khoa học", "phát hiện", "báo cáo"]
        if any(keyword in title_lower or keyword in content_lower for keyword in research_keywords):
            return "research"
        
        # Check for advice/guide content
        advice_keywords = ["cách", "hướng dẫn", "lời khuyên", "mẹo"]
        if any(keyword in title_lower for keyword in advice_keywords):
            return "advice"
        
        # Check for prevention content
        prevention_keywords = ["phòng ngừa", "dự phòng", "tránh", "ngăn chặn"]
        if any(keyword in title_lower or keyword in content_lower for keyword in prevention_keywords):
            return "prevention"
        
        # Default to news
        return "news"
    
    def _extract_content(self, response, url: str) -> Dict[str, Any]:
        """
        Enhanced content extraction for health news pages.
        
        Args:
            response: HTTP response object
            url: Source URL
            
        Returns:
            Extracted content with news-specific enhancements
        """
        # Use base extraction first
        base_content = super()._extract_content(response, url)
        if not base_content:
            return None
        
        try:
            soup = BeautifulSoup(response.content, 'html.parser')
            
            # Extract news-specific metadata
            news_metadata = self._extract_news_metadata(soup, url)
            
            # Enhance base content
            base_content["metadata"].update(news_metadata)
            
            # Determine health category
            health_category = self._determine_health_category(base_content["title"], base_content["content"])
            if health_category:
                base_content["metadata"]["health_category"] = health_category
            
            # Extract tags/keywords
            tags = self._extract_tags(soup)
            if tags:
                base_content["metadata"]["tags"] = tags
            
            # Extract reading time estimate
            reading_time = self._estimate_reading_time(base_content["content"])
            base_content["metadata"]["reading_time_minutes"] = reading_time
            
            # Authority score for news (lower than government sources)
            source_type = self.source_config.get("type", "news")
            authority_scores = {"news": 60, "medical_news": 70, "research": 75}
            base_content["metadata"]["authority_score"] = authority_scores.get(source_type, 60)
            
            return base_content
            
        except Exception as e:
            logger.error(f"News-specific extraction failed for {url}: {e}")
            return base_content
    
    def _extract_news_metadata(self, soup: BeautifulSoup, url: str) -> Dict[str, Any]:
        """Extract news-specific metadata."""
        metadata = {}
        
        # Extract category/section
        category_selectors = [
            ".category", ".section", ".breadcrumb a",
            "[class*='category']", "[class*='section']"
        ]
        
        for selector in category_selectors:
            category_elem = soup.select_one(selector)
            if category_elem:
                metadata["category"] = category_elem.get_text(strip=True)
                break
        
        # Extract summary/excerpt
        summary_selectors = [
            ".summary", ".excerpt", ".lead", ".intro",
            "[class*='summary']", "[class*='excerpt']"
        ]
        
        for selector in summary_selectors:
            summary_elem = soup.select_one(selector)
            if summary_elem:
                summary = summary_elem.get_text(strip=True)
                if len(summary) > 50:  # Only use substantial summaries
                    metadata["summary"] = summary[:500]  # Limit length
                    break
        
        # Extract source/agency (for news articles)
        source_selectors = [
            ".source", ".agency", ".news-source",
            "[class*='source']", "[class*='agency']"
        ]
        
        for selector in source_selectors:
            source_elem = soup.select_one(selector)
            if source_elem:
                metadata["news_source"] = source_elem.get_text(strip=True)
                break
        
        return metadata
    
    def _determine_health_category(self, title: str, content: str) -> str:
        """Determine health category based on content."""
        text = (title + " " + content).lower()
        
        # Score each category
        category_scores = {}
        
        for category, keywords in self.health_categories.items():
            score = 0
            for keyword in keywords:
                score += text.count(keyword)
            
            if score > 0:
                category_scores[category] = score
        
        # Return category with highest score
        if category_scores:
            return max(category_scores, key=category_scores.get)
        
        return "general"
    
    def _extract_tags(self, soup: BeautifulSoup) -> List[str]:
        """Extract article tags/keywords."""
        tags = []
        
        # Look for tag elements
        tag_selectors = [
            ".tags a", ".keywords a", ".tag-list a",
            "[class*='tag'] a", "[class*='keyword'] a"
        ]
        
        for selector in tag_selectors:
            tag_elements = soup.select(selector)
            for elem in tag_elements:
                tag = elem.get_text(strip=True)
                if tag and len(tag) > 2:
                    tags.append(tag)
        
        # Also look for meta keywords
        meta_keywords = soup.find("meta", {"name": "keywords"})
        if meta_keywords and meta_keywords.get("content"):
            keywords = meta_keywords["content"].split(",")
            tags.extend([kw.strip() for kw in keywords if kw.strip()])
        
        # Remove duplicates and limit
        unique_tags = list(dict.fromkeys(tags))  # Preserve order
        return unique_tags[:10]
    
    def _estimate_reading_time(self, content: str) -> int:
        """Estimate reading time in minutes."""
        # Average reading speed: 200 words per minute for Vietnamese
        words = len(content.split())
        reading_time = max(1, round(words / 200))
        return reading_time
