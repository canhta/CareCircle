#!/bin/bash

# CareCircle Vietnamese Healthcare Multi-Agent System Setup Script
# This script sets up the complete Vietnamese healthcare AI agent infrastructure

set -e

echo "🇻🇳 CareCircle Vietnamese Healthcare Multi-Agent System Setup"
echo "=============================================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_header() {
    echo -e "${BLUE}[STEP]${NC} $1"
}

# Check prerequisites
check_prerequisites() {
    print_header "Checking prerequisites..."
    
    # Check Docker
    if ! command -v docker &> /dev/null; then
        print_error "Docker is not installed. Please install Docker first."
        exit 1
    fi
    
    # Check Docker Compose
    if ! command -v docker-compose &> /dev/null; then
        print_error "Docker Compose is not installed. Please install Docker Compose first."
        exit 1
    fi
    
    # Check Node.js
    if ! command -v node &> /dev/null; then
        print_error "Node.js is not installed. Please install Node.js 22+ first."
        exit 1
    fi
    
    # Check npm
    if ! command -v npm &> /dev/null; then
        print_error "npm is not installed. Please install npm first."
        exit 1
    fi
    
    print_status "All prerequisites are installed ✅"
}

# Setup environment variables
setup_environment() {
    print_header "Setting up environment variables..."
    
    if [ ! -f .env ]; then
        print_warning ".env file not found. Creating from template..."
        cp .env.example .env 2>/dev/null || touch .env
    fi
    
    # Add Vietnamese healthcare specific environment variables
    cat >> .env << EOF

# Vietnamese Healthcare Multi-Agent Configuration
VIETNAMESE_NLP_SERVICE_URL=http://localhost:8080
MILVUS_URL=localhost:19530
ENABLE_VIETNAMESE_MULTI_AGENT_ORCHESTRATION=true
ENABLE_PHI_DETECTION=true
ENABLE_VIETNAMESE_NLP=true

# Vector Database Configuration
VECTOR_DATABASE_URL=localhost:19530
MILVUS_USERNAME=
MILVUS_PASSWORD=

# Vietnamese Healthcare Data Sources
VIETNAMESE_HEALTHCARE_CRAWL_SOURCES=vinmec,bachmai,moh
FIRECRAWL_API_KEY=your_firecrawl_key_here

# PHI Protection
PHI_ENCRYPTION_KEY=your_phi_encryption_key_here

# Redis Configuration for Vietnamese Healthcare
REDIS_VIETNAMESE_URL=redis://localhost:6379/0
EOF
    
    print_status "Environment variables configured ✅"
}

# Install backend dependencies
install_backend_dependencies() {
    print_header "Installing backend dependencies..."
    
    cd backend
    
    # Install Node.js dependencies
    npm install
    
    print_status "Backend dependencies installed ✅"
    cd ..
}

# Setup Vietnamese NLP service
setup_vietnamese_nlp() {
    print_header "Setting up Vietnamese NLP service..."
    
    cd vietnamese-nlp
    
    # Build Docker image
    print_status "Building Vietnamese NLP Docker image..."
    docker build -t carecircle-vietnamese-nlp .
    
    print_status "Vietnamese NLP service setup complete ✅"
    cd ..
}

# Start Vietnamese healthcare services
start_services() {
    print_header "Starting Vietnamese healthcare services..."

    # Start the Vietnamese healthcare infrastructure
    print_status "Starting Milvus vector database..."
    docker-compose up -d milvus-standalone milvus-etcd milvus-minio

    print_status "Starting Redis for Vietnamese healthcare..."
    docker-compose up -d redis

    print_status "Starting Vietnamese NLP service..."
    docker-compose up -d vietnamese-nlp
    
    # Wait for services to be ready
    print_status "Waiting for services to be ready..."
    sleep 30
    
    # Check service health
    check_service_health
}

# Check service health
check_service_health() {
    print_header "Checking service health..."
    
    # Check Milvus
    if curl -f http://localhost:9091/health &> /dev/null; then
        print_status "Milvus vector database is healthy ✅"
    else
        print_warning "Milvus vector database health check failed ⚠️"
    fi
    
    # Check Redis
    if docker exec carecircle-redis-vietnamese redis-cli ping &> /dev/null; then
        print_status "Redis Vietnamese is healthy ✅"
    else
        print_warning "Redis Vietnamese health check failed ⚠️"
    fi
    
    # Check Vietnamese NLP service
    if curl -f http://localhost:8080/health &> /dev/null; then
        print_status "Vietnamese NLP service is healthy ✅"
    else
        print_warning "Vietnamese NLP service health check failed ⚠️"
    fi
}

# Setup database schema
setup_database() {
    print_header "Setting up database schema..."
    
    cd backend
    
    # Generate Prisma client
    npx prisma generate
    
    # Push database schema
    npx prisma db push
    
    print_status "Database schema updated ✅"
    cd ..
}

# Start backend service
start_backend() {
    print_header "Starting CareCircle backend with Vietnamese healthcare agents..."
    
    cd backend
    
    # Start in development mode
    npm run start:dev &
    BACKEND_PID=$!
    
    print_status "Backend started with PID: $BACKEND_PID ✅"
    
    # Wait for backend to be ready
    sleep 10
    
    # Check backend health
    if curl -f http://localhost:3001/health &> /dev/null; then
        print_status "CareCircle backend is healthy ✅"
    else
        print_warning "Backend health check failed ⚠️"
    fi
    
    cd ..
}

# Display setup summary
display_summary() {
    print_header "Setup Summary"
    
    echo ""
    echo "🎉 Vietnamese Healthcare Multi-Agent System Setup Complete!"
    echo ""
    echo "📋 Services Status:"
    echo "  • Milvus Vector Database: http://localhost:9091"
    echo "  • Vietnamese NLP Service: http://localhost:8080"
    echo "  • Redis Vietnamese: localhost:6379"
    echo "  • CareCircle Backend: http://localhost:3001"
    echo ""
    echo "🧪 Test Endpoints:"
    echo "  • Health Check: curl http://localhost:3001/health"
    echo "  • Vietnamese Chat: POST http://localhost:3001/api/v1/ai-assistant/chat"
    echo "  • Vietnamese NLP: POST http://localhost:8080/analyze"
    echo ""
    echo "📚 Next Steps:"
    echo "  1. Configure Firecrawl API key in .env file"
    echo "  2. Test Vietnamese healthcare queries"
    echo "  3. Monitor agent interactions in logs"
    echo "  4. Review PHI protection in agent responses"
    echo ""
    echo "🛑 To stop services:"
    echo "  docker-compose down"
    echo ""
}

# Main execution
main() {
    echo "Starting Vietnamese Healthcare Multi-Agent System setup..."
    echo ""
    
    check_prerequisites
    setup_environment
    install_backend_dependencies
    setup_vietnamese_nlp
    start_services
    setup_database
    start_backend
    display_summary
    
    print_status "Setup completed successfully! 🎉"
}

# Handle script interruption
trap 'print_error "Setup interrupted. Cleaning up..."; docker-compose down; exit 1' INT

# Run main function
main "$@"
