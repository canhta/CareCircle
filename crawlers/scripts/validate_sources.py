#!/usr/bin/env python3
"""
Script to validate source configurations and accessibility.
"""

import os
import sys
import json
import argparse
import requests
from pathlib import Path
from urllib.parse import urljoin, urlparse
from urllib.robotparser import RobotFileParser
from typing import Dict, List, Any

# Add src to path
sys.path.insert(0, str(Path(__file__).parent.parent / "src"))

from core.logger import setup_logger, get_logger
from core.api_client import APIClient

# Load environment variables
from dotenv import load_dotenv
load_dotenv()


def load_config(config_path: str) -> Dict[str, Any]:
    """Load configuration from JSON file."""
    try:
        with open(config_path, 'r', encoding='utf-8') as f:
            return json.load(f)
    except Exception as e:
        print(f"Error loading config {config_path}: {e}")
        sys.exit(1)


def validate_url_accessibility(url: str, timeout: int = 10) -> Dict[str, Any]:
    """Validate if URL is accessible."""
    logger = get_logger()
    
    result = {
        "url": url,
        "accessible": False,
        "status_code": None,
        "response_time": None,
        "error": None
    }
    
    try:
        import time
        start_time = time.time()
        
        response = requests.get(
            url,
            timeout=timeout,
            headers={
                "User-Agent": "CareCircle-Crawler/1.0 (+https://carecircle.com/crawler)"
            }
        )
        
        end_time = time.time()
        response_time = end_time - start_time
        
        result.update({
            "accessible": response.status_code == 200,
            "status_code": response.status_code,
            "response_time": response_time
        })
        
        if response.status_code == 200:
            logger.info(f"✓ {url} - {response.status_code} ({response_time:.2f}s)")
        else:
            logger.warning(f"⚠ {url} - {response.status_code} ({response_time:.2f}s)")
            
    except requests.exceptions.RequestException as e:
        result["error"] = str(e)
        logger.error(f"✗ {url} - {str(e)}")
    
    return result


def validate_robots_txt(base_url: str, user_agent: str = "CareCircle-Crawler/1.0") -> Dict[str, Any]:
    """Validate robots.txt compliance."""
    logger = get_logger()
    
    result = {
        "robots_url": None,
        "accessible": False,
        "allows_crawling": False,
        "crawl_delay": None,
        "error": None
    }
    
    try:
        robots_url = urljoin(base_url, "/robots.txt")
        result["robots_url"] = robots_url
        
        rp = RobotFileParser()
        rp.set_url(robots_url)
        rp.read()
        
        result["accessible"] = True
        result["allows_crawling"] = rp.can_fetch(user_agent, base_url)
        
        # Try to get crawl delay
        try:
            crawl_delay = rp.crawl_delay(user_agent)
            if crawl_delay:
                result["crawl_delay"] = crawl_delay
        except:
            pass
        
        if result["allows_crawling"]:
            logger.info(f"✓ robots.txt allows crawling for {user_agent}")
        else:
            logger.warning(f"⚠ robots.txt disallows crawling for {user_agent}")
            
    except Exception as e:
        result["error"] = str(e)
        logger.warning(f"⚠ robots.txt check failed: {str(e)}")
    
    return result


def validate_selectors(url: str, selectors: Dict[str, str], timeout: int = 10) -> Dict[str, Any]:
    """Validate CSS selectors on a page."""
    logger = get_logger()
    
    result = {
        "url": url,
        "selectors_found": {},
        "total_selectors": len(selectors),
        "found_selectors": 0,
        "error": None
    }
    
    try:
        response = requests.get(
            url,
            timeout=timeout,
            headers={
                "User-Agent": "CareCircle-Crawler/1.0 (+https://carecircle.com/crawler)"
            }
        )
        
        if response.status_code != 200:
            result["error"] = f"HTTP {response.status_code}"
            return result
        
        from bs4 import BeautifulSoup
        soup = BeautifulSoup(response.content, 'html.parser')
        
        for selector_name, selector in selectors.items():
            elements = soup.select(selector)
            found = len(elements) > 0
            
            result["selectors_found"][selector_name] = {
                "found": found,
                "count": len(elements),
                "selector": selector
            }
            
            if found:
                result["found_selectors"] += 1
                logger.debug(f"✓ {selector_name}: {selector} ({len(elements)} elements)")
            else:
                logger.debug(f"✗ {selector_name}: {selector} (not found)")
        
        success_rate = result["found_selectors"] / result["total_selectors"]
        if success_rate >= 0.8:
            logger.info(f"✓ Selectors validation: {result['found_selectors']}/{result['total_selectors']} found")
        else:
            logger.warning(f"⚠ Selectors validation: {result['found_selectors']}/{result['total_selectors']} found")
            
    except Exception as e:
        result["error"] = str(e)
        logger.error(f"✗ Selector validation failed: {str(e)}")
    
    return result


def validate_source(source_config: Dict[str, Any], global_settings: Dict[str, Any]) -> Dict[str, Any]:
    """Validate a single source configuration."""
    logger = get_logger()
    source_id = source_config["id"]
    source_name = source_config["name"]
    
    logger.info(f"Validating source: {source_name} ({source_id})")
    
    validation_result = {
        "source_id": source_id,
        "source_name": source_name,
        "base_url": source_config["base_url"],
        "overall_status": "unknown",
        "issues": [],
        "recommendations": [],
        "details": {}
    }
    
    # Validate base URL accessibility
    url_result = validate_url_accessibility(source_config["base_url"])
    validation_result["details"]["url_accessibility"] = url_result
    
    if not url_result["accessible"]:
        validation_result["issues"].append(f"Base URL not accessible: {url_result.get('error', 'Unknown error')}")
    
    # Validate robots.txt
    user_agent = global_settings.get("user_agent", "CareCircle-Crawler/1.0")
    robots_result = validate_robots_txt(source_config["base_url"], user_agent)
    validation_result["details"]["robots_txt"] = robots_result
    
    if robots_result["accessible"] and not robots_result["allows_crawling"]:
        validation_result["issues"].append("robots.txt disallows crawling")
    
    if robots_result.get("crawl_delay"):
        validation_result["recommendations"].append(
            f"robots.txt suggests crawl delay of {robots_result['crawl_delay']} seconds"
        )
    
    # Validate selectors on start URLs
    start_urls = source_config.get("start_urls", [source_config["base_url"]])
    selectors = source_config.get("selectors", {})
    
    if selectors and start_urls:
        # Test selectors on first start URL
        test_url = start_urls[0]
        selector_result = validate_selectors(test_url, selectors)
        validation_result["details"]["selectors"] = selector_result
        
        if selector_result.get("error"):
            validation_result["issues"].append(f"Selector validation failed: {selector_result['error']}")
        elif selector_result["found_selectors"] == 0:
            validation_result["issues"].append("No selectors found on test page")
        elif selector_result["found_selectors"] < selector_result["total_selectors"]:
            missing = selector_result["total_selectors"] - selector_result["found_selectors"]
            validation_result["recommendations"].append(f"Consider updating {missing} selectors that weren't found")
    
    # Determine overall status
    if not validation_result["issues"]:
        validation_result["overall_status"] = "valid"
    elif url_result["accessible"]:
        validation_result["overall_status"] = "warning"
    else:
        validation_result["overall_status"] = "error"
    
    return validation_result


def validate_backend_connectivity(api_config: Dict[str, Any]) -> Dict[str, Any]:
    """Validate backend API connectivity."""
    logger = get_logger()
    
    result = {
        "backend_url": api_config["backend_url"],
        "connectivity": False,
        "authentication": False,
        "endpoints": {},
        "error": None
    }
    
    try:
        # Test basic connectivity
        response = requests.get(
            api_config["backend_url"],
            timeout=10,
            headers={"User-Agent": "CareCircle-Crawler/1.0"}
        )
        
        result["connectivity"] = response.status_code < 500
        
        if result["connectivity"]:
            logger.info(f"✓ Backend connectivity: {api_config['backend_url']}")
            
            # Test API endpoints with authentication
            try:
                api_client = APIClient(api_config)
                
                # Test sources endpoint
                sources_endpoint = api_config["api_endpoints"]["sources"]
                success, response_data, error = api_client._make_request("GET", sources_endpoint)
                
                result["endpoints"]["sources"] = {
                    "accessible": success,
                    "error": error
                }
                
                if success:
                    result["authentication"] = True
                    logger.info("✓ Backend authentication successful")
                else:
                    logger.warning(f"⚠ Backend authentication failed: {error}")
                
            except Exception as e:
                result["error"] = f"API client initialization failed: {str(e)}"
                logger.error(f"✗ API client failed: {str(e)}")
        else:
            logger.error(f"✗ Backend not accessible: HTTP {response.status_code}")
            
    except Exception as e:
        result["error"] = str(e)
        logger.error(f"✗ Backend connectivity failed: {str(e)}")
    
    return result


def main():
    """Main execution function."""
    parser = argparse.ArgumentParser(description="Validate source configurations and accessibility")
    parser.add_argument("--config-dir", default="./config", help="Configuration directory")
    parser.add_argument("--sources", nargs="+", help="Specific sources to validate (default: all)")
    parser.add_argument("--skip-backend", action="store_true", help="Skip backend connectivity test")
    parser.add_argument("--timeout", type=int, default=10, help="Request timeout in seconds")
    parser.add_argument("--log-level", default="INFO", help="Logging level")
    parser.add_argument("--output", help="Save validation report to file")
    
    args = parser.parse_args()
    
    # Set up logging
    setup_logger(log_level=args.log_level)
    logger = get_logger()
    
    logger.info("Starting source validation")
    
    # Load configurations
    config_dir = Path(args.config_dir)
    
    try:
        sources_config = load_config(config_dir / "sources.json")
        crawler_settings = load_config(config_dir / "crawler_settings.json")
        api_config = load_config(config_dir / "api_config.json")
    except Exception as e:
        logger.error(f"Configuration loading failed: {e}")
        sys.exit(1)
    
    # Filter sources to validate
    sources_to_validate = sources_config["sources"]
    
    if args.sources:
        sources_to_validate = [s for s in sources_to_validate if s["id"] in args.sources]
    
    if not sources_to_validate:
        logger.warning("No sources to validate")
        sys.exit(0)
    
    logger.info(f"Validating {len(sources_to_validate)} sources")
    
    # Validate sources
    validation_results = []
    global_settings = sources_config.get("global_settings", {})
    
    for source_config in sources_to_validate:
        result = validate_source(source_config, global_settings)
        validation_results.append(result)
    
    # Validate backend connectivity
    backend_result = None
    if not args.skip_backend:
        logger.info("Validating backend connectivity")
        backend_result = validate_backend_connectivity(api_config)
    
    # Generate summary report
    valid_sources = sum(1 for r in validation_results if r["overall_status"] == "valid")
    warning_sources = sum(1 for r in validation_results if r["overall_status"] == "warning")
    error_sources = sum(1 for r in validation_results if r["overall_status"] == "error")
    
    logger.info("=" * 60)
    logger.info("VALIDATION SUMMARY")
    logger.info("=" * 60)
    logger.info(f"Total sources: {len(validation_results)}")
    logger.info(f"Valid sources: {valid_sources}")
    logger.info(f"Sources with warnings: {warning_sources}")
    logger.info(f"Sources with errors: {error_sources}")
    
    if backend_result:
        backend_status = "✓" if backend_result["connectivity"] and backend_result["authentication"] else "✗"
        logger.info(f"Backend connectivity: {backend_status}")
    
    logger.info("=" * 60)
    
    # Print individual results
    for result in validation_results:
        status_icon = {"valid": "✓", "warning": "⚠", "error": "✗"}[result["overall_status"]]
        logger.info(f"{status_icon} {result['source_name']} ({result['source_id']})")
        
        for issue in result["issues"]:
            logger.info(f"    Issue: {issue}")
        
        for rec in result["recommendations"]:
            logger.info(f"    Recommendation: {rec}")
    
    # Save report if requested
    if args.output:
        report_data = {
            "validation_timestamp": datetime.now(timezone.utc).isoformat(),
            "summary": {
                "total_sources": len(validation_results),
                "valid_sources": valid_sources,
                "warning_sources": warning_sources,
                "error_sources": error_sources
            },
            "source_results": validation_results,
            "backend_result": backend_result
        }
        
        with open(args.output, 'w', encoding='utf-8') as f:
            json.dump(report_data, f, indent=2, ensure_ascii=False)
        
        logger.info(f"Validation report saved to: {args.output}")
    
    # Exit with appropriate code
    if error_sources == 0:
        logger.info("All sources validated successfully")
        sys.exit(0)
    else:
        logger.error(f"{error_sources} sources have errors")
        sys.exit(1)


if __name__ == "__main__":
    main()
