#!/bin/bash

# CareCircle Vietnamese Healthcare Crawler Docker Setup
# Simple Docker-based setup for Vietnamese NLP libraries

set -e  # Exit on any error

# Colors and emojis for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Helper functions
print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_info() {
    echo -e "${BLUE}🔄 $1${NC}"
}

print_check() {
    echo -e "${BLUE}🔍 $1${NC}"
}

# Function to run commands with error handling
run_command() {
    local cmd="$1"
    local description="$2"
    local show_output="${3:-false}"

    print_info "$description..."

    if [ "$show_output" = "true" ]; then
        if eval "$cmd"; then
            print_success "$description completed"
            return 0
        else
            print_error "$description failed"
            return 1
        fi
    else
        if eval "$cmd" > /dev/null 2>&1; then
            print_success "$description completed"
            return 0
        else
            print_error "$description failed"
            return 1
        fi
    fi
}

# Check Docker installation
check_docker() {
    print_check "Checking Docker installation..."

    if ! command -v docker &> /dev/null; then
        print_error "Docker not found. Please install Docker first."
        print_info "Visit: https://docs.docker.com/get-docker/"
        exit 1
    fi

    # Check if Docker daemon is running
    if ! docker info &> /dev/null; then
        print_error "Docker daemon is not running. Please start Docker."
        exit 1
    fi

    local docker_version=$(docker --version | cut -d' ' -f3 | cut -d',' -f1)
    print_success "Docker $docker_version is running"

    # Check for docker-compose
    if command -v docker-compose &> /dev/null; then
        local compose_version=$(docker-compose --version | cut -d' ' -f3 | cut -d',' -f1)
        print_success "Docker Compose $compose_version is available"
        return 0
    elif docker compose version &> /dev/null; then
        local compose_version=$(docker compose version --short)
        print_success "Docker Compose $compose_version is available (plugin)"
        return 0
    else
        print_error "Docker Compose not found. Please install Docker Compose."
        exit 1
    fi
}

# Build Docker image
build_docker_image() {
    print_info "Building Docker image with Vietnamese NLP libraries..."
    print_warning "This may take several minutes on first build..."

    if run_command "docker build -t carecircle-crawler:latest ." "Building Docker image" "true"; then
        print_success "Docker image built successfully"
        return 0
    else
        print_error "Failed to build Docker image"
        return 1
    fi
}

# Start Docker services
start_docker_services() {
    print_info "Starting Docker services..."

    # Check if docker-compose or docker compose is available
    local compose_cmd=""
    if command -v docker-compose &> /dev/null; then
        compose_cmd="docker-compose"
    else
        compose_cmd="docker compose"
    fi

    if run_command "$compose_cmd up -d" "Starting Docker services" "true"; then
        print_success "Docker services started successfully"
        return 0
    else
        print_error "Failed to start Docker services"
        return 1
    fi
}

# Create necessary directories
create_directories() {
    print_info "Creating output directories..."
    
    local directories=(
        "output/raw"
        "output/processed"
        "output/logs"
        "output/uploads"
        "models/pyvi"
    )
    
    for dir in "${directories[@]}"; do
        mkdir -p "$dir"
    done
    
    print_success "Directories created"
}

# Setup configuration files
setup_configuration() {
    print_info "Setting up configuration..."
    
    # Copy example environment file
    if [ -f ".env.example" ] && [ ! -f ".env" ]; then
        cp .env.example .env
        print_success "Created .env file from example"
        print_warning "Please edit .env file with your configuration"
    fi
    
    # Check if configuration files exist
    local config_files=(
        "config/sources.json"
        "config/crawler_settings.json"
        "config/api_config.json"
    )
    
    local missing_configs=()
    for config_file in "${config_files[@]}"; do
        if [ ! -f "$config_file" ]; then
            missing_configs+=("$config_file")
        fi
    done
    
    if [ ${#missing_configs[@]} -gt 0 ]; then
        print_warning "Missing configuration files: ${missing_configs[*]}"
        return 1
    fi
    
    print_success "Configuration files found"
    return 0
}

# Test Docker installation
test_docker_installation() {
    print_info "Testing Docker installation..."

    # Test basic container functionality
    local test_cmd="docker run --rm carecircle-crawler:latest python -c \"
import sys
print('✅ Python is working')

# Test basic dependencies
try:
    import requests
    import bs4
    import pandas
    import loguru
    print('✅ Basic dependencies imported successfully')
except ImportError as e:
    print(f'❌ Basic dependency import failed: {e}')
    sys.exit(1)

# Test Vietnamese NLP libraries
try:
    import pyvi
    from pyvi import ViTokenizer
    print('✅ Vietnamese NLP (pyvi) imported successfully')

    # Test basic functionality
    text = 'Xin chào thế giới'
    tokens = ViTokenizer.tokenize(text)
    print(f'✅ Vietnamese tokenization: {tokens}')

except ImportError as e:
    print(f'❌ Vietnamese NLP import failed: {e}')
    sys.exit(1)
except Exception as e:
    print(f'⚠️  Vietnamese NLP test failed: {e}')

print('🎉 Docker installation test passed!')
\""

    if run_command "$test_cmd" "Testing Docker container" "true"; then
        print_success "Docker installation test passed"
        return 0
    else
        print_error "Docker installation test failed"
        return 1
    fi
}

# Print next steps
print_next_steps() {
    echo
    echo "============================================================"
    echo "🎉 DOCKER SETUP COMPLETED SUCCESSFULLY!"
    echo "============================================================"

    echo
    echo "📋 NEXT STEPS:"
    echo
    echo "1. Configure your environment:"
    echo "   - Edit .env file with your Firebase JWT token and backend URL"
    echo "   - Update config/api_config.json with correct API endpoints"
    echo "   - Customize config/sources.json for your Vietnamese healthcare sources"

    echo
    echo "2. Run Docker commands:"
    echo "   # Check container status"
    echo "   docker-compose ps"
    echo
    echo "   # View logs"
    echo "   docker-compose logs -f carecircle-crawler"
    echo
    echo "   # Execute commands in container"
    echo "   docker-compose exec carecircle-crawler python scripts/validate_sources.py"
    echo
    echo "   # Run crawler"
    echo "   docker-compose exec carecircle-crawler python scripts/crawl_source.py ministry-health --limit 5"
    echo
    echo "   # Upload data"
    echo "   docker-compose exec carecircle-crawler python scripts/upload_data.py --source ministry-health"

    echo
    echo "3. Development workflow:"
    echo "   # Start services"
    echo "   docker-compose up -d"
    echo
    echo "   # Stop services"
    echo "   docker-compose down"
    echo
    echo "   # Rebuild after code changes"
    echo "   docker-compose build && docker-compose up -d"

    echo
    echo "📚 DOCUMENTATION:"
    echo "   - README.md: Architecture overview"
    echo "   - docs/crawlers/setup-guide.md: Detailed setup guide"
    echo "   - docs/crawlers/data-ingestion-api.md: API documentation"

    echo
    echo "🐳 DOCKER COMMANDS:"
    echo "   - Container shell: docker-compose exec carecircle-crawler bash"
    echo "   - Python shell: docker-compose exec carecircle-crawler python"
    echo "   - View container info: docker inspect carecircle-crawler"

    echo
    echo "🆘 SUPPORT:"
    echo "   - Check container logs: docker-compose logs carecircle-crawler"
    echo "   - Check container health: docker-compose ps"
    echo "   - Restart services: docker-compose restart"

    echo
    echo "============================================================"
}

# Main setup function
main() {
    echo "🚀 CareCircle Vietnamese Healthcare Crawler Docker Setup"
    echo "============================================================"

    # Check Docker installation
    check_docker

    # Create directories
    create_directories

    # Setup configuration
    if ! setup_configuration; then
        print_warning "Please ensure all configuration files are properly set up"
    fi

    # Build Docker image
    if ! build_docker_image; then
        exit 1
    fi

    # Start Docker services
    if ! start_docker_services; then
        exit 1
    fi

    # Test Docker installation
    if ! test_docker_installation; then
        print_warning "Docker installation test failed, but services are running"
        print_info "You can manually test with: docker-compose exec carecircle-crawler python -c 'import pyvi; print(\"OK\")'"
    fi

    # Print next steps
    print_next_steps
}

# Run main function
main "$@"
