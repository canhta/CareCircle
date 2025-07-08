# Authentication Integration Testing Guide

This guide provides comprehensive testing procedures for the CareCircle authentication system integration between the mobile app and backend.

## Prerequisites

1. **Backend Setup**
   - Backend server running on `http://localhost:3000`
   - Database migrations completed
   - All authentication endpoints available

2. **Mobile Setup**
   - Flutter dependencies installed
   - Code generation completed
   - Mobile app builds successfully

## Test Scenarios

### 1. Guest Login Flow

**Objective**: Test anonymous user access without registration

**Steps**:
1. Launch mobile app
2. On welcome screen, tap "Continue as Guest"
3. Verify guest user is created in backend
4. Verify navigation to home screen
5. Verify guest status indicators in UI

**Expected Results**:
- ✅ Guest user created with device ID
- ✅ JWT token stored securely
- ✅ Home screen shows guest welcome message
- ✅ "Create Account" button visible for conversion

**Backend Verification**:
```bash
# Check guest user in database
curl -X POST http://localhost:3000/api/v1/auth/guest \
  -H "Content-Type: application/json" \
  -d '{"deviceId": "test-device-123"}'
```

### 2. User Registration Flow

**Objective**: Test new user account creation

**Steps**:
1. From welcome screen, tap "Get Started"
2. Fill registration form:
   - Display Name: "Test User"
   - First Name: "Test"
   - Last Name: "User"
   - Email: "test@example.com"
   - Password: "password123"
   - Confirm Password: "password123"
3. Accept terms and conditions
4. Tap "Create Account"
5. Verify account creation and automatic login

**Expected Results**:
- ✅ Form validation works correctly
- ✅ User account created in backend
- ✅ User profile created with provided information
- ✅ JWT tokens generated and stored
- ✅ Navigation to home screen as authenticated user

**Backend Verification**:
```bash
# Test registration endpoint
curl -X POST http://localhost:3000/api/v1/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@example.com",
    "password": "password123",
    "displayName": "Test User",
    "firstName": "Test",
    "lastName": "User"
  }'
```

### 3. User Login Flow

**Objective**: Test existing user authentication

**Steps**:
1. From welcome screen, tap "Sign In"
2. Enter credentials:
   - Email: "test@example.com"
   - Password: "password123"
3. Tap "Sign In"
4. Verify successful authentication

**Expected Results**:
- ✅ Login validation works
- ✅ Authentication successful
- ✅ User data retrieved from backend
- ✅ Navigation to home screen
- ✅ User profile information displayed

**Backend Verification**:
```bash
# Test login endpoint
curl -X POST http://localhost:3000/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@example.com",
    "password": "password123"
  }'
```

### 4. Token Management

**Objective**: Test JWT token handling and refresh

**Steps**:
1. Login successfully
2. Make authenticated API calls
3. Test token refresh mechanism
4. Test logout functionality

**Expected Results**:
- ✅ Access token attached to API requests
- ✅ Token refresh works automatically
- ✅ Logout clears stored tokens
- ✅ Redirect to welcome screen after logout

**Backend Verification**:
```bash
# Test authenticated endpoint
curl -X GET http://localhost:3000/api/v1/user/me \
  -H "Authorization: Bearer YOUR_JWT_TOKEN"

# Test token refresh
curl -X POST http://localhost:3000/api/v1/auth/refresh \
  -H "Content-Type: application/json" \
  -d '{"refreshToken": "YOUR_REFRESH_TOKEN"}'
```

### 5. Profile Management

**Objective**: Test user profile updates

**Steps**:
1. Login as authenticated user
2. Navigate to profile section
3. Update profile information
4. Save changes
5. Verify updates persist

**Expected Results**:
- ✅ Profile data loads correctly
- ✅ Updates save to backend
- ✅ Changes reflect in UI immediately
- ✅ Data persists after app restart

### 6. Error Handling

**Objective**: Test error scenarios and user feedback

**Test Cases**:
- Invalid email format
- Weak password
- Mismatched password confirmation
- Network connectivity issues
- Invalid credentials
- Expired tokens

**Expected Results**:
- ✅ Clear error messages displayed
- ✅ Form validation prevents submission
- ✅ Network errors handled gracefully
- ✅ User guided to retry or recover

## Integration Test Checklist

### Backend Integration
- [ ] All authentication endpoints responding
- [ ] Database operations working correctly
- [ ] JWT token generation and validation
- [ ] Error responses properly formatted
- [ ] CORS configured for mobile requests

### Mobile Integration
- [ ] API service configured correctly
- [ ] HTTP requests formatted properly
- [ ] Response parsing working
- [ ] Token storage and retrieval
- [ ] Error handling and user feedback
- [ ] Navigation flows working
- [ ] State management functioning

### Security Verification
- [ ] Passwords not stored in plain text
- [ ] JWT tokens stored securely
- [ ] API endpoints properly protected
- [ ] Input validation on both sides
- [ ] HTTPS in production (when deployed)

## Common Issues and Solutions

### 1. Network Connection Errors
**Symptoms**: "Unable to connect to server"
**Solutions**:
- Verify backend is running on correct port
- Check mobile app API base URL configuration
- Ensure CORS is properly configured
- Test with physical device on same network

### 2. Token Validation Errors
**Symptoms**: "Invalid token" or 401 responses
**Solutions**:
- Verify JWT secret configuration
- Check token expiration settings
- Ensure token format is correct
- Verify token storage/retrieval logic

### 3. Form Validation Issues
**Symptoms**: Validation not working or incorrect
**Solutions**:
- Check validation rules match backend requirements
- Verify error message display logic
- Test edge cases and boundary conditions

### 4. State Management Problems
**Symptoms**: UI not updating or incorrect state
**Solutions**:
- Verify Riverpod provider setup
- Check state update logic
- Ensure proper error handling
- Test state persistence

## Performance Testing

### Load Testing
- Test multiple concurrent registrations
- Verify database performance under load
- Check memory usage during extended sessions

### Mobile Performance
- Test on different device types
- Verify smooth animations and transitions
- Check battery usage during authentication flows
- Test offline behavior and recovery

## Deployment Verification

### Production Checklist
- [ ] Firebase credentials configured
- [ ] Database connection secure
- [ ] API endpoints use HTTPS
- [ ] Mobile app points to production API
- [ ] Error logging configured
- [ ] Analytics tracking setup

## Automated Testing

Consider implementing automated tests for:
- API endpoint testing with Postman/Newman
- Mobile UI testing with Flutter integration tests
- End-to-end testing with tools like Detox
- Performance monitoring and alerting

## Documentation Updates

After successful integration testing:
- Update API documentation with examples
- Create user guides for authentication flows
- Document troubleshooting procedures
- Update deployment guides
