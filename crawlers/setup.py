#!/usr/bin/env python3
"""
Setup script for CareCircle Vietnamese Healthcare Crawler System.
"""

import os
import sys
import subprocess
import shutil
from pathlib import Path


def run_command(command, description):
    """Run a shell command and handle errors."""
    print(f"🔄 {description}...")
    try:
        result = subprocess.run(command, shell=True, check=True, capture_output=True, text=True)
        print(f"✅ {description} completed")
        return True
    except subprocess.CalledProcessError as e:
        print(f"❌ {description} failed:")
        print(f"   Command: {command}")
        print(f"   Error: {e.stderr}")
        return False


def check_python_version():
    """Check if Python version is compatible."""
    print("🔍 Checking Python version...")
    
    if sys.version_info < (3, 9):
        print(f"❌ Python 3.9+ required, found {sys.version}")
        return False
    
    print(f"✅ Python {sys.version.split()[0]} is compatible")
    return True


def create_virtual_environment():
    """Create Python virtual environment."""
    venv_path = Path(".venv")
    
    if venv_path.exists():
        print("📁 Virtual environment already exists")
        return True
    
    return run_command("python -m venv .venv", "Creating virtual environment")


def activate_and_install_dependencies():
    """Activate virtual environment and install dependencies."""
    # Determine activation command based on OS
    if os.name == 'nt':  # Windows
        activate_cmd = ".venv\\Scripts\\activate"
        pip_cmd = ".venv\\Scripts\\pip"
    else:  # Unix/Linux/macOS
        activate_cmd = "source .venv/bin/activate"
        pip_cmd = ".venv/bin/pip"
    
    # Upgrade pip
    if not run_command(f"{pip_cmd} install --upgrade pip", "Upgrading pip"):
        return False
    
    # Install dependencies
    if not run_command(f"{pip_cmd} install -r requirements.txt", "Installing dependencies"):
        return False
    
    return True


def create_directories():
    """Create necessary directories."""
    print("📁 Creating output directories...")
    
    directories = [
        "output/raw",
        "output/processed", 
        "output/logs",
        "output/uploads",
        "models/underthesea",
        "models/pyvi"
    ]
    
    for directory in directories:
        Path(directory).mkdir(parents=True, exist_ok=True)
    
    print("✅ Directories created")
    return True


def setup_configuration():
    """Set up configuration files."""
    print("⚙️ Setting up configuration...")
    
    # Copy example environment file
    env_example = Path(".env.example")
    env_file = Path(".env")
    
    if env_example.exists() and not env_file.exists():
        shutil.copy(env_example, env_file)
        print("📄 Created .env file from example")
        print("⚠️  Please edit .env file with your configuration")
    
    # Check if configuration files exist
    config_files = [
        "config/sources.json",
        "config/crawler_settings.json", 
        "config/api_config.json"
    ]
    
    missing_configs = []
    for config_file in config_files:
        if not Path(config_file).exists():
            missing_configs.append(config_file)
    
    if missing_configs:
        print(f"⚠️  Missing configuration files: {', '.join(missing_configs)}")
        return False
    
    print("✅ Configuration files found")
    return True


def test_installation():
    """Test the installation."""
    print("🧪 Testing installation...")
    
    # Determine python command based on OS
    if os.name == 'nt':  # Windows
        python_cmd = ".venv\\Scripts\\python"
    else:  # Unix/Linux/macOS
        python_cmd = ".venv/bin/python"
    
    # Test core imports
    test_script = """
import sys
sys.path.insert(0, 'src')

try:
    from core.base_crawler import BaseCrawler
    from core.content_processor import ContentProcessor
    from core.api_client import APIClient
    from utils.vietnamese_nlp import VietnameseNLP
    from utils.file_manager import FileManager
    from utils.validation import ContentValidator
    print("✅ All core modules imported successfully")
except ImportError as e:
    print(f"❌ Import failed: {e}")
    sys.exit(1)

try:
    import requests
    import beautifulsoup4
    import pandas
    import loguru
    print("✅ All dependencies imported successfully")
except ImportError as e:
    print(f"❌ Dependency import failed: {e}")
    sys.exit(1)

print("🎉 Installation test passed!")
"""
    
    return run_command(f'{python_cmd} -c "{test_script}"', "Testing installation")


def print_next_steps():
    """Print next steps for the user."""
    print("\n" + "="*60)
    print("🎉 SETUP COMPLETED SUCCESSFULLY!")
    print("="*60)
    
    print("\n📋 NEXT STEPS:")
    print("\n1. Configure your environment:")
    print("   - Edit .env file with your Firebase JWT token and backend URL")
    print("   - Update config/api_config.json with correct API endpoints")
    print("   - Customize config/sources.json for your Vietnamese healthcare sources")
    
    print("\n2. Activate the virtual environment:")
    if os.name == 'nt':  # Windows
        print("   .venv\\Scripts\\activate")
    else:  # Unix/Linux/macOS
        print("   source .venv/bin/activate")
    
    print("\n3. Test the setup:")
    print("   python scripts/validate_sources.py")
    
    print("\n4. Run your first crawler:")
    print("   python scripts/crawl_source.py ministry-health --limit 5")
    
    print("\n5. Upload data to backend:")
    print("   python scripts/upload_data.py --source ministry-health")
    
    print("\n📚 DOCUMENTATION:")
    print("   - README.md: Architecture overview")
    print("   - docs/crawlers/setup-guide.md: Detailed setup guide")
    print("   - docs/crawlers/data-ingestion-api.md: API documentation")
    
    print("\n🆘 SUPPORT:")
    print("   - Check logs in output/logs/ for troubleshooting")
    print("   - Run validate_sources.py to test source accessibility")
    print("   - Ensure backend is running and accessible")
    
    print("\n" + "="*60)


def main():
    """Main setup function."""
    print("🚀 CareCircle Vietnamese Healthcare Crawler Setup")
    print("="*60)
    
    # Check Python version
    if not check_python_version():
        sys.exit(1)
    
    # Create virtual environment
    if not create_virtual_environment():
        sys.exit(1)
    
    # Install dependencies
    if not activate_and_install_dependencies():
        sys.exit(1)
    
    # Create directories
    if not create_directories():
        sys.exit(1)
    
    # Setup configuration
    if not setup_configuration():
        print("⚠️  Please ensure all configuration files are properly set up")
    
    # Test installation
    if not test_installation():
        sys.exit(1)
    
    # Print next steps
    print_next_steps()


if __name__ == "__main__":
    main()
