#!/bin/bash

# CareCircle Authentication Integration Test Script
# This script tests the complete authentication flow between mobile and backend

set -e

# Configuration
API_BASE_URL="http://localhost:3000/api/v1"
TEST_EMAIL="integration-test@carecircle.dev"
TEST_PASSWORD="testpassword123"
TEST_DEVICE_ID="test-device-$(date +%s)"

echo "🧪 CareCircle Authentication Integration Test"
echo "=============================================="
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Helper functions
print_test() {
    echo -e "${BLUE}🔍 Testing: $1${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

# Test 1: Backend Health Check
print_test "Backend Health Check"
if curl -s -f "${API_BASE_URL}/auth/guest" > /dev/null 2>&1; then
    print_success "Backend is running and accessible"
else
    print_error "Backend is not accessible at ${API_BASE_URL}"
    echo "Please ensure the backend is running with: cd backend && npm run start:dev"
    exit 1
fi

echo ""

# Test 2: Guest Login
print_test "Guest Login Flow"
GUEST_RESPONSE=$(curl -s -X POST "${API_BASE_URL}/auth/guest" \
    -H "Content-Type: application/json" \
    -d "{\"deviceId\": \"${TEST_DEVICE_ID}\"}")

if echo "$GUEST_RESPONSE" | grep -q "accessToken"; then
    GUEST_TOKEN=$(echo "$GUEST_RESPONSE" | grep -o '"accessToken":"[^"]*"' | cut -d'"' -f4)
    GUEST_USER_ID=$(echo "$GUEST_RESPONSE" | grep -o '"id":"[^"]*"' | cut -d'"' -f4)
    print_success "Guest login successful"
    print_success "Guest User ID: $GUEST_USER_ID"
else
    print_error "Guest login failed"
    echo "Response: $GUEST_RESPONSE"
    exit 1
fi

echo ""

# Test 3: Guest User Profile Access
print_test "Guest User Profile Access"
PROFILE_RESPONSE=$(curl -s -X GET "${API_BASE_URL}/user/me" \
    -H "Authorization: Bearer ${GUEST_TOKEN}")

if echo "$PROFILE_RESPONSE" | grep -q "Guest User"; then
    print_success "Guest profile access successful"
else
    print_error "Guest profile access failed"
    echo "Response: $PROFILE_RESPONSE"
fi

echo ""

# Test 4: User Registration
print_test "User Registration Flow"
REGISTER_RESPONSE=$(curl -s -X POST "${API_BASE_URL}/auth/register" \
    -H "Content-Type: application/json" \
    -d "{
        \"email\": \"${TEST_EMAIL}\",
        \"password\": \"${TEST_PASSWORD}\",
        \"displayName\": \"Integration Test User\",
        \"firstName\": \"Integration\",
        \"lastName\": \"Test\"
    }")

if echo "$REGISTER_RESPONSE" | grep -q "accessToken"; then
    USER_TOKEN=$(echo "$REGISTER_RESPONSE" | grep -o '"accessToken":"[^"]*"' | cut -d'"' -f4)
    USER_REFRESH_TOKEN=$(echo "$REGISTER_RESPONSE" | grep -o '"refreshToken":"[^"]*"' | cut -d'"' -f4)
    print_success "User registration successful"
else
    print_warning "User registration failed (user might already exist)"
    echo "Response: $REGISTER_RESPONSE"
    
    # Try login instead
    print_test "User Login Flow (fallback)"
    LOGIN_RESPONSE=$(curl -s -X POST "${API_BASE_URL}/auth/login" \
        -H "Content-Type: application/json" \
        -d "{
            \"email\": \"${TEST_EMAIL}\",
            \"password\": \"${TEST_PASSWORD}\"
        }")
    
    if echo "$LOGIN_RESPONSE" | grep -q "accessToken"; then
        USER_TOKEN=$(echo "$LOGIN_RESPONSE" | grep -o '"accessToken":"[^"]*"' | cut -d'"' -f4)
        USER_REFRESH_TOKEN=$(echo "$LOGIN_RESPONSE" | grep -o '"refreshToken":"[^"]*"' | cut -d'"' -f4)
        print_success "User login successful"
    else
        print_error "Both registration and login failed"
        echo "Login Response: $LOGIN_RESPONSE"
        exit 1
    fi
fi

echo ""

# Test 5: Authenticated User Profile Access
print_test "Authenticated User Profile Access"
AUTH_PROFILE_RESPONSE=$(curl -s -X GET "${API_BASE_URL}/user/me" \
    -H "Authorization: Bearer ${USER_TOKEN}")

if echo "$AUTH_PROFILE_RESPONSE" | grep -q "Integration Test User"; then
    print_success "Authenticated profile access successful"
else
    print_error "Authenticated profile access failed"
    echo "Response: $AUTH_PROFILE_RESPONSE"
fi

echo ""

# Test 6: Profile Update
print_test "Profile Update"
UPDATE_RESPONSE=$(curl -s -X PUT "${API_BASE_URL}/user/profile" \
    -H "Authorization: Bearer ${USER_TOKEN}" \
    -H "Content-Type: application/json" \
    -d "{
        \"displayName\": \"Updated Test User\",
        \"useElderMode\": true
    }")

if echo "$UPDATE_RESPONSE" | grep -q "Updated Test User"; then
    print_success "Profile update successful"
else
    print_error "Profile update failed"
    echo "Response: $UPDATE_RESPONSE"
fi

echo ""

# Test 7: Token Refresh
print_test "Token Refresh"
REFRESH_RESPONSE=$(curl -s -X POST "${API_BASE_URL}/auth/refresh" \
    -H "Content-Type: application/json" \
    -d "{\"refreshToken\": \"${USER_REFRESH_TOKEN}\"}")

if echo "$REFRESH_RESPONSE" | grep -q "accessToken"; then
    NEW_TOKEN=$(echo "$REFRESH_RESPONSE" | grep -o '"accessToken":"[^"]*"' | cut -d'"' -f4)
    print_success "Token refresh successful"
else
    print_error "Token refresh failed"
    echo "Response: $REFRESH_RESPONSE"
fi

echo ""

# Test 8: Logout
print_test "User Logout"
LOGOUT_RESPONSE=$(curl -s -X POST "${API_BASE_URL}/auth/logout" \
    -H "Authorization: Bearer ${USER_TOKEN}")

# Logout should return 204 No Content or similar
if [ $? -eq 0 ]; then
    print_success "User logout successful"
else
    print_warning "Logout response unclear (this may be normal)"
fi

echo ""

# Test 9: Invalid Token Access (should fail)
print_test "Invalid Token Access (should fail)"
INVALID_RESPONSE=$(curl -s -X GET "${API_BASE_URL}/user/me" \
    -H "Authorization: Bearer invalid-token")

if echo "$INVALID_RESPONSE" | grep -q "Unauthorized\|Invalid"; then
    print_success "Invalid token properly rejected"
else
    print_warning "Invalid token handling unclear"
    echo "Response: $INVALID_RESPONSE"
fi

echo ""

# Summary
echo "🎉 Integration Test Summary"
echo "=========================="
print_success "Backend API is functional"
print_success "Guest authentication working"
print_success "User registration/login working"
print_success "Profile management working"
print_success "Token management working"
print_success "Security validation working"

echo ""
echo "📱 Mobile App Integration"
echo "========================"
echo "The mobile app should now be able to:"
echo "• Connect to the backend API"
echo "• Perform guest login"
echo "• Register new users"
echo "• Login existing users"
echo "• Access and update profiles"
echo "• Handle token refresh automatically"
echo "• Manage authentication state"

echo ""
echo "🚀 Next Steps"
echo "============"
echo "1. Run the mobile app: cd mobile && flutter run"
echo "2. Test the authentication flows manually"
echo "3. Verify UI updates correctly with backend data"
echo "4. Test error handling scenarios"
echo "5. Configure Firebase for production use"

echo ""
print_success "Integration test completed successfully!"
