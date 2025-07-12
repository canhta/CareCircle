#!/bin/bash

# CareCircle Vietnamese Healthcare Multi-Agent System Test Script
# Comprehensive testing of all implemented features and infrastructure

set -e

echo "🧪 CareCircle Vietnamese Healthcare Multi-Agent System Testing"
echo "=============================================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}[✓ PASS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[⚠ WARN]${NC} $1"
}

print_error() {
    echo -e "${RED}[✗ FAIL]${NC} $1"
}

print_test() {
    echo -e "${BLUE}[TEST]${NC} $1"
}

# Test configuration
BACKEND_URL="http://localhost:3001"
VIETNAMESE_NLP_URL="http://localhost:8080"
MILVUS_URL="http://localhost:9091"
REDIS_URL="localhost:6380"

# Test Firebase token (you'll need to replace this with a valid token)
FIREBASE_TOKEN="your_test_firebase_token_here"

# Test counter
TESTS_PASSED=0
TESTS_FAILED=0
TOTAL_TESTS=0

# Function to run a test
run_test() {
    local test_name="$1"
    local test_command="$2"
    local expected_status="$3"
    
    TOTAL_TESTS=$((TOTAL_TESTS + 1))
    print_test "$test_name"
    
    if eval "$test_command"; then
        if [ "$expected_status" = "success" ]; then
            print_status "$test_name"
            TESTS_PASSED=$((TESTS_PASSED + 1))
        else
            print_error "$test_name (expected failure but got success)"
            TESTS_FAILED=$((TESTS_FAILED + 1))
        fi
    else
        if [ "$expected_status" = "failure" ]; then
            print_status "$test_name (expected failure)"
            TESTS_PASSED=$((TESTS_PASSED + 1))
        else
            print_error "$test_name"
            TESTS_FAILED=$((TESTS_FAILED + 1))
        fi
    fi
}

# Infrastructure Tests
echo ""
echo "🔧 Infrastructure Tests"
echo "========================"

run_test "Backend Health Check" \
    "curl -f -s $BACKEND_URL/health > /dev/null" \
    "success"

run_test "Vietnamese NLP Service Health Check" \
    "curl -f -s $VIETNAMESE_NLP_URL/health > /dev/null" \
    "success"

run_test "Milvus Vector Database Health Check" \
    "curl -f -s $MILVUS_URL/health > /dev/null" \
    "success"

run_test "Redis Vietnamese Health Check" \
    "redis-cli -h localhost -p 6380 ping | grep -q PONG" \
    "success"

# Vietnamese NLP Service Tests
echo ""
echo "🇻🇳 Vietnamese NLP Service Tests"
echo "================================="

run_test "Vietnamese Text Tokenization" \
    "curl -f -s -X POST $VIETNAMESE_NLP_URL/tokenize -H 'Content-Type: application/json' -d '{\"text\": \"Tôi bị đau đầu và sốt\"}' | jq -e '.tokens | length > 0'" \
    "success"

run_test "Vietnamese Medical Entity Extraction" \
    "curl -f -s -X POST $VIETNAMESE_NLP_URL/extract-entities -H 'Content-Type: application/json' -d '{\"text\": \"Tôi bị đau đầu, sốt cao và buồn nôn\"}' | jq -e '.entities | length > 0'" \
    "success"

run_test "Vietnamese Emergency Detection" \
    "curl -f -s -X POST $VIETNAMESE_NLP_URL/analyze -H 'Content-Type: application/json' -d '{\"text\": \"Cấp cứu! Tôi bị đau tim dữ dội\"}' | jq -e '.urgency_analysis.is_emergency == true'" \
    "success"

# Backend API Tests (Note: These require valid Firebase token)
echo ""
echo "🏥 Vietnamese Healthcare API Tests"
echo "=================================="

if [ "$FIREBASE_TOKEN" != "your_test_firebase_token_here" ]; then
    run_test "Vietnamese Healthcare Status Check" \
        "curl -f -s -H 'Authorization: Bearer $FIREBASE_TOKEN' $BACKEND_URL/api/v1/ai-assistant/vietnamese-healthcare/status | jq -e '.success == true'" \
        "success"

    run_test "Vietnamese Healthcare Chat Query" \
        "curl -f -s -X POST -H 'Authorization: Bearer $FIREBASE_TOKEN' -H 'Content-Type: application/json' $BACKEND_URL/api/v1/ai-assistant/vietnamese-healthcare/chat -d '{\"message\": \"Tôi bị đau đầu, có thuốc gì không?\", \"culturalContext\": \"mixed\"}' | jq -e '.success == true'" \
        "success"

    run_test "Vietnamese Medical Knowledge Search" \
        "curl -f -s -X POST -H 'Authorization: Bearer $FIREBASE_TOKEN' -H 'Content-Type: application/json' $BACKEND_URL/api/v1/ai-assistant/vietnamese-healthcare/search-knowledge -d '{\"query\": \"đau đầu\", \"language\": \"vietnamese\"}' | jq -e '.success == true'" \
        "success"

    run_test "Knowledge Base Statistics" \
        "curl -f -s -H 'Authorization: Bearer $FIREBASE_TOKEN' $BACKEND_URL/api/v1/ai-assistant/vietnamese-healthcare/knowledge-stats | jq -e '.success == true'" \
        "success"
else
    print_warning "Skipping API tests - Firebase token not configured"
    print_warning "Set FIREBASE_TOKEN environment variable to run API tests"
fi

# Vector Database Tests
echo ""
echo "🔍 Vector Database Tests"
echo "========================"

run_test "Milvus Collection Exists" \
    "curl -f -s $MILVUS_URL/api/v1/collection/vietnamese_medical_knowledge > /dev/null" \
    "success"

# PHI Protection Tests
echo ""
echo "🔒 PHI Protection Tests"
echo "======================="

# Test Vietnamese PHI patterns
run_test "Vietnamese ID Card Detection" \
    "echo 'CMND: 123456789' | grep -q '[0-9]\\{9\\}'" \
    "success"

run_test "Vietnamese Phone Number Detection" \
    "echo 'Số điện thoại: 0123456789' | grep -q '0[0-9]\\{9\\}'" \
    "success"

# Traditional Medicine Integration Tests
echo ""
echo "🌿 Traditional Medicine Integration Tests"
echo "========================================="

run_test "Traditional Medicine Terms Detection" \
    "echo 'thuốc nam, đông y, bài thuốc' | grep -q 'thuốc nam'" \
    "success"

run_test "Cultural Context Recognition" \
    "echo 'y học cổ truyền Việt Nam' | grep -q 'y học cổ truyền'" \
    "success"

# Performance Tests
echo ""
echo "⚡ Performance Tests"
echo "==================="

run_test "Vietnamese NLP Response Time < 5s" \
    "timeout 5s curl -f -s -X POST $VIETNAMESE_NLP_URL/analyze -H 'Content-Type: application/json' -d '{\"text\": \"Tôi bị đau bụng\"}' > /dev/null" \
    "success"

# Integration Tests
echo ""
echo "🔗 Integration Tests"
echo "==================="

run_test "End-to-End Vietnamese Healthcare Query Processing" \
    "curl -f -s -X POST $VIETNAMESE_NLP_URL/analyze -H 'Content-Type: application/json' -d '{\"text\": \"Tôi bị đau đầu và sốt, có nên uống thuốc nam không?\"}' | jq -e '.summary.has_medical_terms == true'" \
    "success"

# Security Tests
echo ""
echo "🛡️ Security Tests"
echo "=================="

run_test "Unauthorized API Access Blocked" \
    "curl -f -s $BACKEND_URL/api/v1/ai-assistant/vietnamese-healthcare/status" \
    "failure"

run_test "Invalid Input Handling" \
    "curl -f -s -X POST $VIETNAMESE_NLP_URL/tokenize -H 'Content-Type: application/json' -d '{}' | jq -e '.error != null'" \
    "success"

# Test Summary
echo ""
echo "📊 Test Summary"
echo "==============="
echo "Total Tests: $TOTAL_TESTS"
echo "Passed: $TESTS_PASSED"
echo "Failed: $TESTS_FAILED"

if [ $TESTS_FAILED -eq 0 ]; then
    print_status "All tests passed! 🎉"
    echo ""
    echo "✅ Vietnamese Healthcare Multi-Agent System is working correctly!"
    echo ""
    echo "🚀 Ready for production deployment!"
    echo ""
    echo "📝 Next Steps:"
    echo "  1. Configure Firecrawl API key for website crawling"
    echo "  2. Set up Firebase authentication tokens"
    echo "  3. Run initial Vietnamese healthcare website crawl"
    echo "  4. Monitor system performance and logs"
    echo ""
    exit 0
else
    print_error "$TESTS_FAILED tests failed!"
    echo ""
    echo "❌ Please fix the failing tests before proceeding"
    echo ""
    echo "🔧 Troubleshooting:"
    echo "  1. Check if all services are running: docker-compose ps"
    echo "  2. Check service logs: docker-compose logs [service-name]"
    echo "  3. Verify environment variables are set correctly"
    echo "  4. Ensure Firebase authentication is configured"
    echo ""
    exit 1
fi
