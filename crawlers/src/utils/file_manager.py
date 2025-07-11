"""
File management utilities for crawler data storage.
"""

import os
import json
import gzip
import shutil
from pathlib import Path
from typing import Dict, List, Any, Optional
from datetime import datetime, timezone, timedelta
from loguru import logger


class FileManager:
    """
    Manage local file storage for crawler data.
    
    Handles saving raw and processed content, managing output directories,
    and cleaning up old files.
    """
    
    def __init__(self, settings: Dict[str, Any]):
        """
        Initialize file manager.
        
        Args:
            settings: File management configuration
        """
        self.settings = settings
        self.output_config = settings.get("output", {})
        
        # Set up directory paths
        self.base_dir = Path(self.output_config.get("raw_data_dir", "./output")).parent
        self.raw_dir = Path(self.output_config.get("raw_data_dir", "./output/raw"))
        self.processed_dir = Path(self.output_config.get("processed_data_dir", "./output/processed"))
        self.logs_dir = Path(self.output_config.get("logs_dir", "./output/logs"))
        self.uploads_dir = Path(self.output_config.get("uploads_dir", "./output/uploads"))
        
        # Create directories
        self._create_directories()
        
        # File settings
        self.compression = self.output_config.get("compression", "gzip")
        self.file_format = self.output_config.get("file_format", "json")
        
        logger.info(f"Initialized file manager with base directory: {self.base_dir}")
    
    def _create_directories(self):
        """Create output directories if they don't exist."""
        directories = [self.raw_dir, self.processed_dir, self.logs_dir, self.uploads_dir]
        
        for directory in directories:
            directory.mkdir(parents=True, exist_ok=True)
            logger.debug(f"Created directory: {directory}")
    
    def save_raw_content(self, source_id: str, content_items: List[Dict[str, Any]]) -> str:
        """
        Save raw crawled content to file.
        
        Args:
            source_id: Source identifier
            content_items: List of raw content items
            
        Returns:
            Path to saved file
        """
        timestamp = datetime.now(timezone.utc).strftime("%Y%m%d_%H%M%S")
        filename = f"{source_id}_raw_{timestamp}.json"
        
        # Create source-specific directory
        source_dir = self.raw_dir / source_id
        source_dir.mkdir(exist_ok=True)
        
        file_path = source_dir / filename
        
        # Save data
        data = {
            "source_id": source_id,
            "crawled_at": datetime.now(timezone.utc).isoformat(),
            "item_count": len(content_items),
            "items": content_items
        }
        
        self._save_json_file(file_path, data)
        
        logger.info(f"Saved {len(content_items)} raw items to {file_path}")
        return str(file_path)
    
    def save_processed_content(self, source_id: str, processed_items: List[Dict[str, Any]]) -> str:
        """
        Save processed content to file.
        
        Args:
            source_id: Source identifier
            processed_items: List of processed content items
            
        Returns:
            Path to saved file
        """
        timestamp = datetime.now(timezone.utc).strftime("%Y%m%d_%H%M%S")
        filename = f"{source_id}_processed_{timestamp}.json"
        
        # Create source-specific directory
        source_dir = self.processed_dir / source_id
        source_dir.mkdir(exist_ok=True)
        
        file_path = source_dir / filename
        
        # Save data
        data = {
            "source_id": source_id,
            "processed_at": datetime.now(timezone.utc).isoformat(),
            "item_count": len(processed_items),
            "items": processed_items
        }
        
        self._save_json_file(file_path, data)
        
        logger.info(f"Saved {len(processed_items)} processed items to {file_path}")
        return str(file_path)
    
    def save_upload_batch(self, batch_id: str, upload_data: Dict[str, Any]) -> str:
        """
        Save upload batch data for tracking.
        
        Args:
            batch_id: Batch identifier
            upload_data: Upload batch data and results
            
        Returns:
            Path to saved file
        """
        filename = f"{batch_id}.json"
        file_path = self.uploads_dir / filename
        
        # Add metadata
        upload_data["saved_at"] = datetime.now(timezone.utc).isoformat()
        
        self._save_json_file(file_path, upload_data)
        
        logger.info(f"Saved upload batch data to {file_path}")
        return str(file_path)
    
    def _save_json_file(self, file_path: Path, data: Dict[str, Any]):
        """Save data to JSON file with optional compression."""
        json_str = json.dumps(data, ensure_ascii=False, indent=2)
        
        if self.compression == "gzip":
            with gzip.open(f"{file_path}.gz", 'wt', encoding='utf-8') as f:
                f.write(json_str)
        else:
            with open(file_path, 'w', encoding='utf-8') as f:
                f.write(json_str)
    
    def load_raw_content(self, file_path: str) -> Optional[Dict[str, Any]]:
        """
        Load raw content from file.
        
        Args:
            file_path: Path to content file
            
        Returns:
            Loaded content data or None if failed
        """
        return self._load_json_file(Path(file_path))
    
    def load_processed_content(self, file_path: str) -> Optional[Dict[str, Any]]:
        """
        Load processed content from file.
        
        Args:
            file_path: Path to content file
            
        Returns:
            Loaded content data or None if failed
        """
        return self._load_json_file(Path(file_path))
    
    def _load_json_file(self, file_path: Path) -> Optional[Dict[str, Any]]:
        """Load data from JSON file with optional decompression."""
        try:
            # Try compressed file first
            compressed_path = Path(f"{file_path}.gz")
            if compressed_path.exists():
                with gzip.open(compressed_path, 'rt', encoding='utf-8') as f:
                    return json.load(f)
            
            # Try uncompressed file
            if file_path.exists():
                with open(file_path, 'r', encoding='utf-8') as f:
                    return json.load(f)
            
            logger.warning(f"File not found: {file_path}")
            return None
            
        except Exception as e:
            logger.error(f"Failed to load file {file_path}: {e}")
            return None
    
    def list_source_files(self, source_id: str, content_type: str = "raw") -> List[str]:
        """
        List files for a specific source.
        
        Args:
            source_id: Source identifier
            content_type: Type of content ("raw" or "processed")
            
        Returns:
            List of file paths
        """
        if content_type == "raw":
            source_dir = self.raw_dir / source_id
        elif content_type == "processed":
            source_dir = self.processed_dir / source_id
        else:
            raise ValueError(f"Invalid content type: {content_type}")
        
        if not source_dir.exists():
            return []
        
        files = []
        for file_path in source_dir.iterdir():
            if file_path.is_file() and (file_path.suffix == '.json' or file_path.suffix == '.gz'):
                files.append(str(file_path))
        
        return sorted(files)
    
    def get_latest_file(self, source_id: str, content_type: str = "processed") -> Optional[str]:
        """
        Get the latest file for a source.
        
        Args:
            source_id: Source identifier
            content_type: Type of content ("raw" or "processed")
            
        Returns:
            Path to latest file or None
        """
        files = self.list_source_files(source_id, content_type)
        return files[-1] if files else None
    
    def cleanup_old_files(self, retention_days: Optional[int] = None):
        """
        Clean up old files based on retention policy.
        
        Args:
            retention_days: Number of days to retain files (uses config if None)
        """
        if retention_days is None:
            # Get retention settings from environment or config
            import os
            raw_retention = int(os.getenv("RAW_DATA_RETENTION_DAYS", "30"))
            processed_retention = int(os.getenv("PROCESSED_DATA_RETENTION_DAYS", "90"))
        else:
            raw_retention = processed_retention = retention_days
        
        current_time = datetime.now(timezone.utc)
        
        # Clean raw data
        self._cleanup_directory(self.raw_dir, current_time, raw_retention)
        
        # Clean processed data
        self._cleanup_directory(self.processed_dir, current_time, processed_retention)
        
        # Clean upload data (shorter retention)
        self._cleanup_directory(self.uploads_dir, current_time, 7)
        
        logger.info(f"Cleanup completed: raw={raw_retention}d, processed={processed_retention}d")
    
    def _cleanup_directory(self, directory: Path, current_time: datetime, retention_days: int):
        """Clean up files in a directory older than retention period."""
        if not directory.exists():
            return
        
        cutoff_time = current_time - timedelta(days=retention_days)
        deleted_count = 0
        
        for file_path in directory.rglob("*"):
            if file_path.is_file():
                # Get file modification time
                file_mtime = datetime.fromtimestamp(file_path.stat().st_mtime, tz=timezone.utc)
                
                if file_mtime < cutoff_time:
                    try:
                        file_path.unlink()
                        deleted_count += 1
                        logger.debug(f"Deleted old file: {file_path}")
                    except Exception as e:
                        logger.warning(f"Failed to delete {file_path}: {e}")
        
        if deleted_count > 0:
            logger.info(f"Deleted {deleted_count} old files from {directory}")
    
    def get_storage_stats(self) -> Dict[str, Any]:
        """Get storage statistics."""
        stats = {
            "directories": {},
            "total_size": 0,
            "total_files": 0
        }
        
        directories = {
            "raw": self.raw_dir,
            "processed": self.processed_dir,
            "logs": self.logs_dir,
            "uploads": self.uploads_dir
        }
        
        for name, directory in directories.items():
            if directory.exists():
                dir_stats = self._get_directory_stats(directory)
                stats["directories"][name] = dir_stats
                stats["total_size"] += dir_stats["size"]
                stats["total_files"] += dir_stats["files"]
            else:
                stats["directories"][name] = {"size": 0, "files": 0}
        
        # Convert size to human readable
        stats["total_size_mb"] = stats["total_size"] / (1024 * 1024)
        
        return stats
    
    def _get_directory_stats(self, directory: Path) -> Dict[str, int]:
        """Get statistics for a directory."""
        total_size = 0
        file_count = 0
        
        for file_path in directory.rglob("*"):
            if file_path.is_file():
                total_size += file_path.stat().st_size
                file_count += 1
        
        return {"size": total_size, "files": file_count}
    
    def export_data(self, source_id: str, output_path: str, content_type: str = "processed"):
        """
        Export all data for a source to a single file.
        
        Args:
            source_id: Source identifier
            output_path: Output file path
            content_type: Type of content to export
        """
        files = self.list_source_files(source_id, content_type)
        
        if not files:
            logger.warning(f"No files found for source {source_id}")
            return
        
        all_items = []
        
        for file_path in files:
            data = self._load_json_file(Path(file_path))
            if data and "items" in data:
                all_items.extend(data["items"])
        
        export_data = {
            "source_id": source_id,
            "content_type": content_type,
            "exported_at": datetime.now(timezone.utc).isoformat(),
            "total_items": len(all_items),
            "items": all_items
        }
        
        self._save_json_file(Path(output_path), export_data)
        
        logger.info(f"Exported {len(all_items)} items to {output_path}")
