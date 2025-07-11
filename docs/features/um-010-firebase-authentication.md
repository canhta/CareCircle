# Feature Specification: Firebase Authentication System (UM-010)

## Overview

**Feature ID:** UM-010  
**Feature Name:** Firebase Authentication System  
**User Story:** As a user, I want a seamless and secure authentication experience that allows me to use guest mode, create accounts, sign in with various methods, and convert my guest account to a permanent account without losing my data.

## Detailed Description

The Firebase Authentication System feature implements a comprehensive authentication strategy for the CareCircle platform using Firebase Authentication services. This feature handles user registration, login, guest authentication, account linking, and device-based account management. The implementation addresses the complex challenges of guest-to-permanent account conversion, preventing multiple guest accounts from the same device, and maintaining session persistence across app restarts.

## Business Requirements

1. **Multiple Authentication Methods:** Support email/password, phone number, Google, Facebook, and Apple Sign-In authentication methods.
2. **Guest Mode:** Allow users to access the app without registration through an anonymous authentication flow.
3. **Account Linking:** Enable seamless conversion from guest accounts to permanent accounts without data loss.
4. **Device-Based Account Management:** Prevent creation of multiple guest accounts from the same device.
5. **Session Persistence:** Maintain authentication state across app restarts and device reboots.
6. **Cross-Platform Support:** Ensure consistent authentication experience across iOS, Android, and web platforms.
7. **Secure Access Control:** Implement proper security rules to protect user data based on authentication status.
8. **Offline Support:** Handle authentication gracefully during offline scenarios.
9. **Account Recovery:** Provide mechanisms for password reset and account recovery.

## Technical Specifications

### 1. Authentication Architecture

```
┌─────────────────────┐     ┌─────────────────────┐     ┌─────────────────────┐
│                     │     │                     │     │                     │
│  Mobile Application │────▶│  Firebase Auth SDK  │────▶│  Firebase Auth API  │
│                     │     │                     │     │                     │
└─────────────────────┘     └─────────────────────┘     └─────────────────────┘
          │                                                       │
          │                                                       │
          ▼                                                       ▼
┌─────────────────────┐                             ┌─────────────────────┐
│                     │                             │                     │
│  Local Auth Cache   │                             │  Firestore Database │
│                     │                             │                     │
└─────────────────────┘                             └─────────────────────┘
```

### 2. Authentication Methods Implementation

#### Email/Password Authentication

```dart
// Registration with email/password
Future<UserCredential> registerWithEmailAndPassword(String email, String password) async {
  try {
    final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    // Create user profile in Firestore
    await _createUserProfile(credential.user!.uid, email);

    return credential;
  } on FirebaseAuthException catch (e) {
    // Handle specific Firebase exceptions
    _handleFirebaseAuthException(e);
    rethrow;
  }
}

// Sign in with email/password
Future<UserCredential> signInWithEmailAndPassword(String email, String password) async {
  try {
    return await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  } on FirebaseAuthException catch (e) {
    _handleFirebaseAuthException(e);
    rethrow;
  }
}
```

#### Phone Authentication

```dart
// Request phone verification code
Future<void> verifyPhoneNumber(
  String phoneNumber,
  Function(PhoneAuthCredential) verificationCompleted,
  Function(FirebaseAuthException) verificationFailed,
  Function(String, int?) codeSent,
  Function(String) codeAutoRetrievalTimeout,
) async {
  await FirebaseAuth.instance.verifyPhoneNumber(
    phoneNumber: phoneNumber,
    verificationCompleted: verificationCompleted,
    verificationFailed: verificationFailed,
    codeSent: codeSent,
    codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
    timeout: const Duration(seconds: 60),
  );
}

// Sign in with verification code
Future<UserCredential> signInWithPhoneAuthCredential(PhoneAuthCredential credential) async {
  try {
    final userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

    // If this is a new user, create a profile
    if (userCredential.additionalUserInfo?.isNewUser ?? false) {
      await _createUserProfile(
        userCredential.user!.uid,
        null,
        phoneNumber: userCredential.user!.phoneNumber
      );
    }

    return userCredential;
  } on FirebaseAuthException catch (e) {
    _handleFirebaseAuthException(e);
    rethrow;
  }
}
```

#### Social Authentication

```dart
// Google Sign-In
Future<UserCredential> signInWithGoogle() async {
  try {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    if (googleUser == null) {
      throw FirebaseAuthException(
        code: 'sign_in_canceled',
        message: 'Google sign in was canceled by the user',
      );
    }

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Sign in with the credential
    final userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

    // Handle new user creation
    if (userCredential.additionalUserInfo?.isNewUser ?? false) {
      await _createUserProfile(
        userCredential.user!.uid,
        userCredential.user!.email,
        displayName: userCredential.user!.displayName,
        photoUrl: userCredential.user!.photoURL,
      );
    }

    return userCredential;
  } catch (e) {
    _handleException(e);
    rethrow;
  }
}

// Apple Sign-In (iOS/Web)
Future<UserCredential> signInWithApple() async {
  try {
    // Implement platform-specific Apple Sign-In
    // [Platform-specific code implementation]

    // Create Apple credential
    final AppleAuthProvider appleProvider = AppleAuthProvider();
    appleProvider.addScope('email');
    appleProvider.addScope('name');

    // Sign in
    final userCredential = await FirebaseAuth.instance.signInWithProvider(appleProvider);

    // Handle new user creation
    if (userCredential.additionalUserInfo?.isNewUser ?? false) {
      await _createUserProfile(
        userCredential.user!.uid,
        userCredential.user!.email,
        displayName: userCredential.user!.displayName,
        photoUrl: userCredential.user!.photoURL,
      );
    }

    return userCredential;
  } catch (e) {
    _handleException(e);
    rethrow;
  }
}
```

### 3. Guest Authentication Implementation

```dart
// Sign in anonymously (guest mode)
Future<UserCredential> signInAnonymously() async {
  try {
    // Check if there's a stored anonymous user ID for this device
    final String? storedAnonymousUid = await _secureStorage.read(key: 'anonymous_uid');

    if (storedAnonymousUid != null) {
      // Try to sign in with the stored credentials
      try {
        // This requires having previously saved the anonymous user's credentials
        final credential = await _retrieveStoredCredential(storedAnonymousUid);
        if (credential != null) {
          return await FirebaseAuth.instance.signInWithCredential(credential);
        }
      } catch (e) {
        // If the stored credential is invalid, continue with new anonymous sign-in
        debugPrint('Failed to sign in with stored anonymous credential: $e');
      }
    }

    // Create a new anonymous account
    final userCredential = await FirebaseAuth.instance.signInAnonymously();

    // Store the anonymous UID for this device
    await _secureStorage.write(
      key: 'anonymous_uid',
      value: userCredential.user!.uid
    );

    // Store credential for potential future use
    await _storeAnonymousCredential(userCredential);

    // Create guest profile in Firestore
    await _createGuestProfile(userCredential.user!.uid);

    return userCredential;
  } on FirebaseAuthException catch (e) {
    _handleFirebaseAuthException(e);
    rethrow;
  }
}

// Store anonymous credential
Future<void> _storeAnonymousCredential(UserCredential credential) async {
  // Implementation depends on platform capabilities
  // For security reasons, this might be limited to certain platforms
  // or require additional security measures
}

// Retrieve stored credential
Future<AuthCredential?> _retrieveStoredCredential(String uid) async {
  // Implementation depends on platform capabilities
  // This is a placeholder for the concept
  return null;
}
```

### 4. Account Linking (Guest to Permanent)

```dart
// Link anonymous account with email/password
Future<UserCredential> linkAnonymousAccountWithEmailPassword(
  String email,
  String password
) async {
  try {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      throw Exception('No user is currently signed in');
    }

    if (!user.isAnonymous) {
      throw Exception('Current user is not an anonymous user');
    }

    // Create email credential
    final credential = EmailAuthProvider.credential(
      email: email,
      password: password
    );

    // Link anonymous account with email credential
    final linkedUserCredential = await user.linkWithCredential(credential);

    // Update the user profile in Firestore
    await _updateGuestProfileToPermament(
      user.uid,
      email: email,
    );

    // Remove the stored anonymous UID since it's now a permanent account
    await _secureStorage.delete(key: 'anonymous_uid');

    return linkedUserCredential;
  } on FirebaseAuthException catch (e) {
    // Special handling for "email-already-in-use" error
    if (e.code == 'email-already-in-use') {
      // The email is already in use by another account
      // We need to sign in with that email account and merge the data
      await _handleExistingEmailAccount(email, password);
    }

    _handleFirebaseAuthException(e);
    rethrow;
  }
}

// Link anonymous account with social provider
Future<UserCredential> linkAnonymousAccountWithSocialProvider(
  AuthProvider provider
) async {
  try {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      throw Exception('No user is currently signed in');
    }

    if (!user.isAnonymous) {
      throw Exception('Current user is not an anonymous user');
    }

    // Link with social provider
    final linkedUserCredential = await user.linkWithProvider(provider);

    // Update the user profile in Firestore
    await _updateGuestProfileToPermament(
      user.uid,
      email: linkedUserCredential.user?.email,
      displayName: linkedUserCredential.user?.displayName,
      photoUrl: linkedUserCredential.user?.photoURL,
    );

    // Remove the stored anonymous UID
    await _secureStorage.delete(key: 'anonymous_uid');

    return linkedUserCredential;
  } on FirebaseAuthException catch (e) {
    // Handle "credential-already-in-use" error
    if (e.code == 'credential-already-in-use') {
      // This social account is already linked to another Firebase account
      // Need to implement a data migration strategy
      await _handleExistingSocialAccount(e.credential);
    }

    _handleFirebaseAuthException(e);
    rethrow;
  }
}

// Handle existing email account during linking
Future<void> _handleExistingEmailAccount(String email, String password) async {
  // 1. Get the anonymous user ID and remember it
  final anonymousUser = FirebaseAuth.instance.currentUser;
  if (anonymousUser == null) return;

  final anonymousUid = anonymousUser.uid;

  // 2. Sign out the anonymous user
  await FirebaseAuth.instance.signOut();

  // 3. Sign in with the existing email account
  final userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
    email: email,
    password: password,
  );

  // 4. Migrate data from anonymous account to the email account
  await _migrateUserData(anonymousUid, userCredential.user!.uid);

  // 5. Delete the anonymous user data
  await _deleteUserData(anonymousUid);

  // 6. Remove stored anonymous UID
  await _secureStorage.delete(key: 'anonymous_uid');
}

// Handle existing social account during linking
Future<void> _handleExistingSocialAccount(AuthCredential? credential) async {
  if (credential == null) return;

  // 1. Get the anonymous user ID and remember it
  final anonymousUser = FirebaseAuth.instance.currentUser;
  if (anonymousUser == null) return;

  final anonymousUid = anonymousUser.uid;

  // 2. Sign out the anonymous user
  await FirebaseAuth.instance.signOut();

  // 3. Sign in with the existing social account
  final userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

  // 4. Migrate data from anonymous account to the social account
  await _migrateUserData(anonymousUid, userCredential.user!.uid);

  // 5. Delete the anonymous user data
  await _deleteUserData(anonymousUid);

  // 6. Remove stored anonymous UID
  await _secureStorage.delete(key: 'anonymous_uid');
}

// Migrate user data between accounts
Future<void> _migrateUserData(String sourceUid, String targetUid) async {
  // This function handles copying data from one user account to another
  // It should be implemented as a server function for security reasons
  // Here's a simplified example:

  // 1. Read all data from the source user
  final sourceData = await _getUserData(sourceUid);

  // 2. Merge this data with the target user's data
  await _mergeUserData(targetUid, sourceData);
}
```

### 5. Device-Based Account Management

```dart
// Check for existing user on device
Future<bool> hasExistingUserOnDevice() async {
  // Check secure storage for any user information
  final String? anonymousUid = await _secureStorage.read(key: 'anonymous_uid');
  final String? regularUid = await _secureStorage.read(key: 'regular_uid');

  return anonymousUid != null || regularUid != null;
}

// Get the user type on this device
Future<UserType> getUserTypeOnDevice() async {
  final currentUser = FirebaseAuth.instance.currentUser;

  if (currentUser == null) {
    // No user is signed in, check storage
    final String? anonymousUid = await _secureStorage.read(key: 'anonymous_uid');
    final String? regularUid = await _secureStorage.read(key: 'regular_uid');

    if (regularUid != null) {
      return UserType.regular;
    } else if (anonymousUid != null) {
      return UserType.anonymous;
    } else {
      return UserType.none;
    }
  } else {
    // User is signed in
    return currentUser.isAnonymous ? UserType.anonymous : UserType.regular;
  }
}

// Handle device-specific login logic
Future<UserCredential> signInOnDevice() async {
  final userType = await getUserTypeOnDevice();

  switch (userType) {
    case UserType.regular:
      // Attempt to restore regular user session
      final String? regularUid = await _secureStorage.read(key: 'regular_uid');
      // This would require having stored credentials securely or using persistence
      // In reality, might need to prompt for login again
      return await _restoreRegularUserSession(regularUid);

    case UserType.anonymous:
      // Restore anonymous session
      return await signInAnonymously(); // This checks for stored anonymous UID

    case UserType.none:
    default:
      // No existing user, default to anonymous
      return await signInAnonymously();
  }
}

// Track user authentication changes
void setupAuthStateListener() {
  FirebaseAuth.instance.authStateChanges().listen((User? user) async {
    if (user == null) {
      // User signed out
      // Don't clear stored UIDs here as we want to maintain device association
    } else {
      // User signed in
      if (user.isAnonymous) {
        await _secureStorage.write(key: 'anonymous_uid', value: user.uid);
      } else {
        await _secureStorage.write(key: 'regular_uid', value: user.uid);
        // Remove anonymous UID if we have a regular account
        await _secureStorage.delete(key: 'anonymous_uid');
      }
    }
  });
}
```

### 6. Session Persistence

```dart
// Configure persistence for each platform
Future<void> configurePersistence() async {
  if (kIsWeb) {
    // Web persistence options
    await FirebaseAuth.instance.setPersistence(Persistence.LOCAL);
  } else {
    // Mobile automatically uses persistent storage
    // But we can configure session timeout, etc.
  }
}

// Handle token refresh and session maintenance
Future<void> setupTokenRefresh() async {
  // Set up a periodic job to refresh the token before it expires
  Timer.periodic(const Duration(hours: 1), (timer) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await user.getIdToken(true); // Force refresh
      } catch (e) {
        debugPrint('Token refresh failed: $e');
        // Handle offline scenarios
      }
    }
  });
}
```

### 7. Offline Support

```dart
// Check authentication status during offline mode
Future<bool> isAuthenticatedOffline() async {
  final user = FirebaseAuth.instance.currentUser;

  if (user != null) {
    // User is signed in according to local cache
    return true;
  }

  // Check if we have stored credentials that indicate a previous authentication
  final String? anonymousUid = await _secureStorage.read(key: 'anonymous_uid');
  final String? regularUid = await _secureStorage.read(key: 'regular_uid');

  return anonymousUid != null || regularUid != null;
}

// Queue authentication operations for when online
Future<void> queueAuthOperation(AuthOperation operation) async {
  // Store the operation in local database
  await _localDatabase.insert('auth_queue', operation.toMap());
}

// Process queued operations when back online
Future<void> processQueuedOperations() async {
  final operations = await _localDatabase.query('auth_queue');

  for (final operation in operations) {
    try {
      await _executeAuthOperation(AuthOperation.fromMap(operation));
      await _localDatabase.delete(
        'auth_queue',
        where: 'id = ?',
        whereArgs: [operation['id']]
      );
    } catch (e) {
      debugPrint('Failed to process queued auth operation: $e');
      // Mark as failed or retry later
    }
  }
}
```

### 8. Error Handling

```dart
// Handle Firebase Auth Exceptions
void _handleFirebaseAuthException(FirebaseAuthException e) {
  switch (e.code) {
    case 'user-not-found':
      _showError('No user found with this email.');
      break;
    case 'wrong-password':
      _showError('Incorrect password. Please try again.');
      break;
    case 'email-already-in-use':
      _showError('This email is already registered. Please sign in.');
      break;
    case 'weak-password':
      _showError('Password is too weak. Please use a stronger password.');
      break;
    case 'invalid-email':
      _showError('The email address is not valid.');
      break;
    case 'operation-not-allowed':
      _showError('This authentication method is not enabled.');
      break;
    case 'account-exists-with-different-credential':
      _showError('An account already exists with the same email but different sign-in credentials.');
      break;
    case 'invalid-credential':
      _showError('The authentication credential is malformed or expired.');
      break;
    case 'invalid-verification-code':
      _showError('The verification code is invalid.');
      break;
    case 'invalid-verification-id':
      _showError('The verification ID is invalid.');
      break;
    case 'credential-already-in-use':
      _showError('This credential is already associated with a different user account.');
      break;
    case 'user-disabled':
      _showError('This user account has been disabled.');
      break;
    case 'user-token-expired':
      _showError('User session has expired. Please sign in again.');
      break;
    case 'too-many-requests':
      _showError('Too many attempts. Please try again later.');
      break;
    default:
      _showError('Authentication error: ${e.message}');
  }
}
```

### 9. Security Rules

Firebase Security Rules to control access to data:

```
// Firestore security rules
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Common functions
    function isSignedIn() {
      return request.auth != null;
    }

    function isOwner(userId) {
      return request.auth.uid == userId;
    }

    function isNotAnonymous() {
      return request.auth != null && !request.auth.token.firebase.sign_in_provider.matches('anonymous');
    }

    // User profiles
    match /users/{userId} {
      allow read: if isSignedIn() && (isOwner(userId) || resource.data.careGroups.hasAny(request.auth.token.careGroups));
      allow create: if isSignedIn() && isOwner(userId);
      allow update: if isSignedIn() && isOwner(userId);
      allow delete: if false; // Prevent deletion, use account deletion flow instead

      // Nested collections
      match /privateData/{document=**} {
        allow read, write: if isSignedIn() && isOwner(userId);
      }
    }

    // Care groups - accessible to members
    match /careGroups/{groupId} {
      allow read: if isSignedIn() && (
        resource.data.members[request.auth.uid] != null
      );
      allow create: if isSignedIn() && isNotAnonymous();
      allow update: if isSignedIn() && (
        resource.data.members[request.auth.uid].role == 'admin' ||
        resource.data.members[request.auth.uid].role == 'owner'
      );
      allow delete: if isSignedIn() && resource.data.members[request.auth.uid].role == 'owner';
    }

    // Health data - accessible to user and their care group members
    match /healthData/{dataId} {
      allow read: if isSignedIn() && (
        isOwner(resource.data.userId) ||
        resource.data.sharedWith.hasAny(request.auth.token.careGroups)
      );
      allow create: if isSignedIn();
      allow update: if isSignedIn() && (
        isOwner(resource.data.userId) ||
        resource.data.editors.hasAny([request.auth.uid])
      );
      allow delete: if isSignedIn() && isOwner(resource.data.userId);
    }

    // Public data - accessible to anyone
    match /publicData/{document=**} {
      allow read: if true;
      allow write: if isSignedIn() && isNotAnonymous();
    }
  }
}
```

## Implementation Plan

### Phase 1: Basic Authentication

1. Implement email/password authentication
2. Implement social authentication (Google, Apple)
3. Set up basic security rules
4. Implement session persistence
5. Set up error handling framework

### Phase 2: Guest Mode and Device Management

1. Implement anonymous authentication
2. Create device-based account tracking
3. Prevent multiple guest accounts per device
4. Implement basic guest profile in Firestore
5. Update security rules for guest accounts

### Phase 3: Account Linking and Conversion

1. Implement account linking from anonymous to permanent
2. Create data migration workflows
3. Handle account conflicts during linking
4. Implement secure credential storage
5. Add conflict resolution strategies

### Phase 4: Advanced Features

1. Implement offline authentication support
2. Add token refresh and session management
3. Create account recovery workflows
4. Implement multi-factor authentication
5. Finalize security rules

## Testing Requirements

### Authentication Flow Tests

1. **User Registration Tests**
   - Test email/password registration
   - Test phone number registration
   - Test social authentication registration
   - Verify user profile creation in Firestore

2. **Sign-In Tests**
   - Test all authentication methods
   - Test persistence across app restarts
   - Test error handling for invalid credentials
   - Test sign-in with non-existent account

3. **Guest Mode Tests**
   - Test anonymous authentication
   - Test device tracking of anonymous users
   - Test prevention of multiple anonymous accounts
   - Test guest profile creation in Firestore

4. **Account Linking Tests**
   - Test linking anonymous to email/password
   - Test linking anonymous to social providers
   - Test handling of existing accounts during linking
   - Test data migration between accounts

### Security Tests

1. **Access Control Tests**
   - Test Firebase security rules for different user types
   - Test access to protected resources
   - Test prevention of unauthorized data access
   - Test role-based permissions

2. **Token Management Tests**
   - Test token refresh mechanism
   - Test token expiration handling
   - Test ID token claims
   - Test custom claims for permissions

### Edge Case Tests

1. **Offline Mode Tests**
   - Test authentication during offline mode
   - Test queued operations processing
   - Test synchronization after reconnection
   - Test conflict resolution for offline changes

2. **Error Recovery Tests**
   - Test handling of network errors
   - Test recovery from authentication failures
   - Test invalid token handling
   - Test rate limiting scenarios

3. **Device Management Tests**
   - Test user tracking across multiple devices
   - Test session handling when switching devices
   - Test account recovery across devices
   - Test migration between devices

## UI/UX Considerations

UI/UX specifications for authentication flows will be documented in future updates as part of the design system implementation.

## Dependencies

1. **Firebase Services**
   - Firebase Authentication
   - Cloud Firestore
   - Firebase Functions (for secure account linking)
   - Firebase Hosting (for web authentication)

2. **External Services**
   - Google Sign-In API
   - Apple Sign-In API
   - Facebook Login SDK (if implemented)

3. **System Dependencies**
   - Secure storage for device credentials
   - Local database for offline queue
   - Network connectivity monitoring

## Open Questions / Decisions

1. Should we implement email verification as a requirement before allowing full access to the app?
2. What is our policy on account deletion and data retention?
3. How long should guest accounts be retained before automatic cleanup?
4. Should we implement IP-based restrictions or geolocation verification?
5. What is our approach to handling compromised credentials?

## Related Documents

- [User Management Features](./feature-catalog.md#user-management-um)
- [Backend Authentication Flow](../architecture/backend-architecture.md#authentication-and-authorization)
- [Identity & Access Context](../bounded-contexts/01-identity-access/README.md)
- [Firebase Auth Implementation](../bounded-contexts/01-identity-access/firebase-auth-implementation.md)
