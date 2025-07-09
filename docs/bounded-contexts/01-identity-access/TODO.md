# Identity & Access Context TODO List

## Module Information
- **Module**: Identity & Access Context (IAC)
- **Context**: Authentication, Authorization, User Management
- **Implementation Order**: 1
- **Dependencies**: None (foundational module)

## Current Sprint

### ✅ Completed
- [x] **Authentication System Refactoring** - Refactored to use only Firebase authentication
  - Removed custom JWT implementation and JwtAuthGuard
  - Updated all controllers to use FirebaseAuthGuard exclusively
  - Removed username/password login endpoints (now Firebase-only)
  - Simplified AuthService by removing JWT token generation
  - Updated AuthResponseDto to remove JWT token fields
  - Removed JWT dependencies (@nestjs/jwt, passport-jwt, etc.)
  - **Status**: All authentication now uses Firebase tokens exclusively

### In Progress
- [ ] Setup Firebase Authentication project and configure settings

### Ready for Implementation
- [ ] Implement Firebase Admin SDK integration in NestJS
- [ ] Create user repository and domain services

## Backlog

### Backend Tasks
- [ ] Build role-based access control system with custom Firebase claims
- [ ] Implement authentication middleware for API protection
- [ ] Develop guest mode authentication flow with device tracking
- [ ] Create multi-factor authentication implementation
- [ ] Build account recovery mechanisms with secure token handling
- [ ] Implement session management with Redis for token storage
- [ ] Create audit logging service for authentication events
- [ ] Develop health check endpoints for authentication services
- [ ] Implement rate limiting for authentication endpoints

### Mobile Tasks
- [ ] Integrate Firebase Authentication SDK
- [ ] Implement secure credential storage using platform security features
- [ ] Create login/registration screens with form validation
- [ ] Build biometric authentication integration
- [ ] Implement social login options (Google, Apple)
- [ ] Create profile management UI with photo upload capability
- [ ] Develop permission request UI for sensitive operations
- [ ] Build token management and refresh system
- [ ] Implement offline authentication mechanisms
- [ ] Create account recovery flow with verification
- [ ] Develop Elder Mode UI adaptations for authentication screens
- [ ] Create guest mode experience with conversion prompts

## Completed
- [x] Initial project structure setup
- [x] Firebase project configuration

## Dependencies Status
- Firebase Authentication: READY - Project configured
- NestJS Framework: READY - Backend structure in place
- Flutter Framework: READY - Mobile structure in place

## References
- [Identity & Access Context Documentation](./README.md)
- [Firebase Auth Implementation Guide](./firebase-auth-implementation.md)
- [Firebase Auth Integration Flow](./firebase_auth_integration_flow.md)
