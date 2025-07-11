"""
Logging configuration for the CareCircle crawler system.
"""

import os
import sys
from pathlib import Path
from loguru import logger
from typing import Optional


def setup_logger(
    name: str = "carecircle_crawler",
    log_level: str = "INFO",
    log_dir: Optional[str] = None,
    console_output: bool = True,
    file_output: bool = True,
    rotation: str = "1 day",
    retention: str = "30 days",
    max_size: str = "10 MB"
) -> None:
    """
    Set up logging configuration for the crawler system.
    
    Args:
        name: Logger name
        log_level: Logging level (DEBUG, INFO, WARNING, ERROR)
        log_dir: Directory for log files
        console_output: Enable console logging
        file_output: Enable file logging
        rotation: Log file rotation interval
        retention: Log file retention period
        max_size: Maximum log file size
    """
    # Remove default logger
    logger.remove()
    
    # Set up log directory
    if log_dir is None:
        log_dir = "./output/logs"
    
    log_path = Path(log_dir)
    log_path.mkdir(parents=True, exist_ok=True)
    
    # Log format
    log_format = (
        "<green>{time:YYYY-MM-DD HH:mm:ss}</green> | "
        "<level>{level: <8}</level> | "
        "<cyan>{name}</cyan>:<cyan>{function}</cyan>:<cyan>{line}</cyan> | "
        "<level>{message}</level>"
    )
    
    # Console logging
    if console_output:
        logger.add(
            sys.stdout,
            format=log_format,
            level=log_level,
            colorize=True
        )
    
    # File logging
    if file_output:
        # General log file
        logger.add(
            log_path / f"{name}.log",
            format=log_format,
            level=log_level,
            rotation=rotation,
            retention=retention,
            compression="gz"
        )
        
        # Error log file
        logger.add(
            log_path / f"{name}_errors.log",
            format=log_format,
            level="ERROR",
            rotation=rotation,
            retention=retention,
            compression="gz"
        )
    
    # Set logger name
    logger.bind(name=name)


def get_logger(name: str = "carecircle_crawler"):
    """Get a logger instance with the specified name."""
    return logger.bind(name=name)


def log_crawler_start(source_id: str, source_name: str):
    """Log the start of a crawler run."""
    logger.info(f"Starting crawler for {source_name} (ID: {source_id})")


def log_crawler_end(source_id: str, pages_crawled: int, items_extracted: int):
    """Log the end of a crawler run."""
    logger.info(
        f"Crawler completed for {source_id}: "
        f"{pages_crawled} pages crawled, {items_extracted} items extracted"
    )


def log_error_with_context(error: Exception, context: dict):
    """Log an error with additional context information."""
    logger.error(f"Error occurred: {str(error)}")
    for key, value in context.items():
        logger.error(f"  {key}: {value}")


def log_api_request(method: str, url: str, status_code: int, response_time: float):
    """Log API request details."""
    logger.info(
        f"API {method} {url} -> {status_code} "
        f"({response_time:.2f}s)"
    )


def log_content_processed(
    source_id: str, 
    content_id: str, 
    title: str, 
    content_length: int,
    quality_score: float
):
    """Log content processing details."""
    logger.info(
        f"Processed content from {source_id}: "
        f"ID={content_id}, Title='{title[:50]}...', "
        f"Length={content_length}, Quality={quality_score:.2f}"
    )


def log_upload_batch(batch_id: str, item_count: int, success: bool):
    """Log batch upload results."""
    status = "SUCCESS" if success else "FAILED"
    logger.info(f"Batch upload {batch_id}: {item_count} items - {status}")


# Environment-based logger setup
def setup_from_env():
    """Set up logger based on environment variables."""
    log_level = os.getenv("LOG_LEVEL", "INFO")
    log_dir = os.getenv("OUTPUT_DIR", "./output") + "/logs"
    
    setup_logger(
        log_level=log_level,
        log_dir=log_dir
    )
