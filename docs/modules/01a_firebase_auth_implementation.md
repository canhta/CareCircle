# Firebase Authentication Implementation

> **Note:** This document expands on the high-level authentication flow described in [Firebase Authentication Integration Flow](../details/firebase_auth_integration_flow.md). While that document provides architectural overview and sequence diagrams, this document focuses on detailed implementation code and guidelines.

## Overview

This document provides detailed implementation guidelines for Firebase Authentication in the CareCircle platform, with special focus on guest mode functionality, account linking, and conversion from anonymous to registered users. It supplements the Identity & Access Context module documentation with specific implementation details.

## Authentication Flows

### 1. Guest Authentication Flow

```
┌─────────────────┐     ┌─────────────────┐     ┌─────────────────┐     ┌─────────────────┐
│                 │     │                 │     │                 │     │                 │
│  App Launch     │────▶│  Check Device   │────▶│  Firebase       │────▶│  Create Guest   │
│                 │     │  Storage        │     │  Anonymous Auth │     │  Profile        │
│                 │     │                 │     │                 │     │                 │
└─────────────────┘     └─────────────────┘     └─────────────────┘     └─────────────────┘
                                                                               │
                                                                               ▼
┌─────────────────┐     ┌─────────────────┐     ┌─────────────────┐     ┌─────────────────┐
│                 │     │                 │     │                 │     │                 │
│  Store          │◀────│  Generate       │◀────│  Store Device   │◀────│  Store Auth     │
│  Auth State     │     │  Session Token  │     │  Identifier     │     │  Credentials    │
│                 │     │                 │     │                 │     │                 │
└─────────────────┘     └─────────────────┘     └─────────────────┘     └─────────────────┘
```

#### Implementation Details:

1. **Device Check**

   ```typescript
   async function checkForExistingGuestAccount(): Promise<string | null> {
     try {
       // Check if we have stored an anonymous user ID for this device
       return await secureStorage.get("anonymous_uid");
     } catch (error) {
       console.error("Error checking for existing guest account:", error);
       return null;
     }
   }
   ```

2. **Anonymous Authentication**

   ```typescript
   async function signInAsGuest(): Promise<UserCredential> {
     try {
       // Check for existing anonymous account
       const existingAnonymousUid = await checkForExistingGuestAccount();

       if (existingAnonymousUid) {
         try {
           // Try to sign in with existing anonymous account
           await firebase
             .auth()
             .signInWithCustomToken(
               await getCustomTokenForAnonymous(existingAnonymousUid)
             );
           const currentUser = firebase.auth().currentUser;
           if (currentUser) {
             return {
               user: currentUser,
               credential: null,
               additionalUserInfo: null,
             };
           }
         } catch (error) {
           console.warn(
             "Failed to restore anonymous session, creating new one:",
             error
           );
         }
       }

       // Create new anonymous account
       const credential = await firebase.auth().signInAnonymously();

       // Store anonymous UID for device
       if (credential.user) {
         await secureStorage.set("anonymous_uid", credential.user.uid);
         await storeGuestCredential(credential);
       }

       return credential;
     } catch (error) {
       console.error("Error in guest authentication:", error);
       throw error;
     }
   }
   ```

3. **Guest Profile Creation**

   ```typescript
   async function createGuestProfile(uid: string): Promise<void> {
     try {
       const deviceInfo = await getDeviceInfo();

       // Create a minimal profile for guest user
       await firestore
         .collection("users")
         .doc(uid)
         .set({
           isGuest: true,
           createdAt: firebase.firestore.FieldValue.serverTimestamp(),
           lastActive: firebase.firestore.FieldValue.serverTimestamp(),
           deviceId: deviceInfo.uniqueId,
           deviceInfo: {
             platform: deviceInfo.platform,
             model: deviceInfo.model,
             osVersion: deviceInfo.systemVersion,
           },
         });

       // Set custom claim for guest user via Cloud Function
       await firebase.functions().httpsCallable("setGuestClaim")({ uid });
     } catch (error) {
       console.error("Error creating guest profile:", error);
       throw error;
     }
   }
   ```

4. **Credential Storage**

   ```typescript
   async function storeGuestCredential(
     credential: UserCredential
   ): Promise<void> {
     if (!credential.user) return;

     try {
       // Store refresh token securely
       const token = await credential.user.getIdToken();
       await secureStorage.set("anonymous_refresh_token", token);

       // Store UID
       await secureStorage.set("anonymous_uid", credential.user.uid);
     } catch (error) {
       console.error("Error storing guest credential:", error);
     }
   }
   ```

### 2. Account Linking and Conversion Flow

```
┌─────────────────┐     ┌─────────────────┐     ┌─────────────────┐
│                 │     │                 │     │                 │
│  Guest User     │────▶│  Registration   │────▶│  Auth Method    │
│  Session        │     │  Prompt         │     │  Selection      │
│                 │     │                 │     │                 │
└─────────────────┘     └─────────────────┘     └─────────────────┘
                                                       │
                                                       ▼
┌─────────────────┐     ┌─────────────────┐     ┌─────────────────┐
│                 │     │                 │     │                 │
│  Convert        │◀────│  Link           │◀────│  Authenticate   │
│  User Profile   │     │  Anonymous Auth │     │  With Method    │
│                 │     │                 │     │                 │
└─────────────────┘     └─────────────────┘     └─────────────────┘
```

#### Implementation Details:

1. **Auth Method Selection & Authentication**

   ```typescript
   async function authenticateWithProvider(
     provider: AuthProvider,
     anonymousUser: User
   ): Promise<AuthCredential> {
     try {
       let credential: AuthCredential;

       switch (provider) {
         case AuthProvider.EMAIL: {
           const { email, password } = await collectEmailCredentials();
           credential = EmailAuthProvider.credential(email, password);
           break;
         }
         case AuthProvider.GOOGLE: {
           const googleAuth = await GoogleSignin.signIn();
           credential = GoogleAuthProvider.credential(
             googleAuth.idToken,
             googleAuth.accessToken
           );
           break;
         }
         case AuthProvider.APPLE: {
           const appleAuthResponse = await appleAuth.performRequest({
             requestedOperation: appleAuth.Operation.LOGIN,
             requestedScopes: [
               appleAuth.Scope.EMAIL,
               appleAuth.Scope.FULL_NAME,
             ],
           });
           credential = OAuthProvider("apple.com").credential({
             idToken: appleAuthResponse.identityToken,
             rawNonce: appleAuthResponse.nonce,
           });
           break;
         }
         case AuthProvider.PHONE: {
           const { verificationId, code } = await collectPhoneCredentials();
           credential = PhoneAuthProvider.credential(verificationId, code);
           break;
         }
         default:
           throw new Error(`Unsupported provider: ${provider}`);
       }

       return credential;
     } catch (error) {
       console.error(`Error authenticating with ${provider}:`, error);
       throw error;
     }
   }
   ```

2. **Link Anonymous Auth**

   ```typescript
   async function linkAnonymousWithCredential(
     anonymousUser: User,
     credential: AuthCredential
   ): Promise<UserCredential> {
     try {
       // First, check if the credential is already in use
       try {
         await checkIfCredentialExists(credential);
       } catch (error) {
         if (error.code === "auth/account-exists-with-different-credential") {
           throw new ConversionError(
             "ACCOUNT_EXISTS",
             "An account already exists with this credential"
           );
         }
       }

       // Link anonymous account with the credential
       return await anonymousUser.linkWithCredential(credential);
     } catch (error) {
       console.error("Error linking anonymous account:", error);

       if (error instanceof ConversionError) {
         throw error;
       }

       // Handle specific Firebase errors
       switch (error.code) {
         case "auth/credential-already-in-use":
           throw new ConversionError(
             "CREDENTIAL_IN_USE",
             "This account is already registered"
           );
         case "auth/email-already-in-use":
           throw new ConversionError(
             "EMAIL_IN_USE",
             "This email is already registered"
           );
         case "auth/invalid-credential":
           throw new ConversionError(
             "INVALID_CREDENTIAL",
             "The authentication credential is invalid"
           );
         default:
           throw new ConversionError("UNKNOWN", error.message);
       }
     }
   }
   ```

3. **Convert User Profile**

   ```typescript
   async function convertGuestToRegisteredUser(
     uid: string,
     userInfo: {
       email?: string;
       displayName?: string;
       phoneNumber?: string;
       photoURL?: string;
     }
   ): Promise<void> {
     try {
       // Start a transaction to ensure data consistency
       await firestore.runTransaction(async (transaction) => {
         // Get the current user profile
         const userRef = firestore.collection("users").doc(uid);
         const userDoc = await transaction.get(userRef);

         if (!userDoc.exists) {
           throw new Error("User document not found");
         }

         const userData = userDoc.data() as GuestUserProfile;

         // Update the user profile, preserving all previous data
         transaction.update(userRef, {
           isGuest: false,
           email: userInfo.email || null,
           displayName: userInfo.displayName || null,
           phoneNumber: userInfo.phoneNumber || null,
           photoURL: userInfo.photoURL || null,
           convertedAt: firebase.firestore.FieldValue.serverTimestamp(),
           // Preserve any data the guest user created
           ...userData,
         });

         // Additional collection migrations can be handled here
         // For example, transferring health data, medications, etc.
       });

       // Remove guest claim and add registered user claim via Cloud Function
       await firebase.functions().httpsCallable("convertGuestToRegistered")({
         uid,
       });

       // Clear anonymous credential storage
       await secureStorage.delete("anonymous_uid");
       await secureStorage.delete("anonymous_refresh_token");
     } catch (error) {
       console.error("Error converting guest profile:", error);
       throw error;
     }
   }
   ```

### 3. Direct Registration Flow (Non-Guest)

```
┌─────────────────┐     ┌─────────────────┐     ┌─────────────────┐     ┌─────────────────┐
│                 │     │                 │     │                 │     │                 │
│  Registration   │────▶│  Auth Method    │────▶│  Firebase       │────▶│  Create User    │
│  Form           │     │  Selection      │     │  Authentication │     │  Profile        │
│                 │     │                 │     │                 │     │                 │
└─────────────────┘     └─────────────────┘     └─────────────────┘     └─────────────────┘
```

#### Implementation Details:

1. **Email/Password Registration**

   ```typescript
   async function registerWithEmailAndPassword(
     email: string,
     password: string
   ): Promise<UserCredential> {
     try {
       // Create user with email and password
       const credential = await firebase
         .auth()
         .createUserWithEmailAndPassword(email, password);

       // Send email verification
       if (credential.user) {
         await credential.user.sendEmailVerification();
       }

       return credential;
     } catch (error) {
       console.error("Error registering with email/password:", error);

       // Handle specific Firebase errors
       switch (error.code) {
         case "auth/email-already-in-use":
           throw new RegistrationError(
             "EMAIL_IN_USE",
             "This email is already registered"
           );
         case "auth/invalid-email":
           throw new RegistrationError(
             "INVALID_EMAIL",
             "The email address is invalid"
           );
         case "auth/weak-password":
           throw new RegistrationError(
             "WEAK_PASSWORD",
             "The password is too weak"
           );
         default:
           throw new RegistrationError("UNKNOWN", error.message);
       }
     }
   }
   ```

2. **Social Authentication Registration**

   ```typescript
   async function registerWithSocialProvider(
     provider: AuthProvider
   ): Promise<UserCredential> {
     try {
       let credential: UserCredential;

       switch (provider) {
         case AuthProvider.GOOGLE: {
           // Google sign-in flow
           const googleAuth = await GoogleSignin.signIn();
           const googleCredential = GoogleAuthProvider.credential(
             googleAuth.idToken,
             googleAuth.accessToken
           );
           credential = await firebase
             .auth()
             .signInWithCredential(googleCredential);
           break;
         }
         case AuthProvider.APPLE: {
           // Apple sign-in flow
           const appleAuthResponse = await appleAuth.performRequest({
             requestedOperation: appleAuth.Operation.LOGIN,
             requestedScopes: [
               appleAuth.Scope.EMAIL,
               appleAuth.Scope.FULL_NAME,
             ],
           });

           const { identityToken, nonce } = appleAuthResponse;
           const appleCredential = OAuthProvider("apple.com").credential({
             idToken: identityToken,
             rawNonce: nonce,
           });

           credential = await firebase
             .auth()
             .signInWithCredential(appleCredential);
           break;
         }
         default:
           throw new Error(`Unsupported provider: ${provider}`);
       }

       return credential;
     } catch (error) {
       console.error(`Error registering with ${provider}:`, error);
       throw error;
     }
   }
   ```

## Data Models

### Authentication State

```typescript
interface AuthState {
  user: User | null;
  isGuest: boolean;
  isLoading: boolean;
  error: AuthError | null;
  initialized: boolean;
}

interface User {
  uid: string;
  email: string | null;
  displayName: string | null;
  phoneNumber: string | null;
  photoURL: string | null;
  providerId: string;
  isAnonymous: boolean;
  isEmailVerified: boolean;
  metadata: {
    creationTime: string;
    lastSignInTime: string;
  };
}

interface AuthError {
  code: string;
  message: string;
  nativeErrorMessage?: string;
  nativeErrorCode?: string;
}
```

### User Profile

```typescript
interface UserProfile {
  uid: string;
  email?: string;
  displayName?: string;
  phoneNumber?: string;
  photoURL?: string;
  isGuest: boolean;
  createdAt: Timestamp;
  lastActive: Timestamp;
  convertedAt?: Timestamp;
  deviceId?: string;
  deviceInfo?: DeviceInfo;
  languagePreference?: "en" | "vi";
  useElderMode?: boolean;
}

interface GuestUserProfile {
  isGuest: true;
  createdAt: Timestamp;
  lastActive: Timestamp;
  deviceId: string;
  deviceInfo: DeviceInfo;
}

interface DeviceInfo {
  platform: "ios" | "android" | "web";
  model: string;
  osVersion: string;
  appVersion?: string;
}
```

## Security Rules

### Firestore Security Rules for User Profiles

```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // User profile rules
    match /users/{userId} {
      // Users can read their own profile
      allow read: if request.auth.uid == userId;

      // Allow creation only by authenticated users
      allow create: if request.auth != null &&
                    request.resource.data.uid == request.auth.uid;

      // Allow updates only by the profile owner
      allow update: if request.auth.uid == userId;

      // No deletion allowed through client
      allow delete: if false;

      // Guest user specific rule
      function isGuestUser() {
        return request.auth.token.isGuest == true;
      }

      // Limit what guest users can write
      allow write: if request.auth.uid == userId &&
                    isGuestUser() &&
                    request.resource.data.isGuest == true;
    }
  }
}
```

## Backend Implementation

### Cloud Functions for Guest User Management

```typescript
// Cloud Function to set guest claim
export const setGuestClaim = functions.https.onCall(async (data, context) => {
  // Ensure request is authenticated
  if (!context.auth) {
    throw new functions.https.HttpsError(
      "unauthenticated",
      "Only authenticated users can set claims."
    );
  }

  const uid = data.uid || context.auth.uid;

  // Verify the requester is setting their own claim or is an admin
  if (uid !== context.auth.uid && !context.auth.token.admin) {
    throw new functions.https.HttpsError(
      "permission-denied",
      "You can only set claims for your own account."
    );
  }

  try {
    // Set custom claim
    await admin.auth().setCustomUserClaims(uid, { isGuest: true });

    // Force token refresh
    await admin.firestore().collection("users").doc(uid).update({
      forceRefresh: admin.firestore.FieldValue.serverTimestamp(),
    });

    return { success: true };
  } catch (error) {
    console.error("Error setting guest claim:", error);
    throw new functions.https.HttpsError("internal", error.message);
  }
});

// Cloud Function to convert guest to registered user
export const convertGuestToRegistered = functions.https.onCall(
  async (data, context) => {
    // Ensure request is authenticated
    if (!context.auth) {
      throw new functions.https.HttpsError(
        "unauthenticated",
        "Only authenticated users can convert accounts."
      );
    }

    const uid = data.uid || context.auth.uid;

    // Verify the requester is converting their own account or is an admin
    if (uid !== context.auth.uid && !context.auth.token.admin) {
      throw new functions.https.HttpsError(
        "permission-denied",
        "You can only convert your own account."
      );
    }

    try {
      // Remove guest claim and add registered user claim
      await admin.auth().setCustomUserClaims(uid, {
        isGuest: false,
        isRegistered: true,
      });

      // Force token refresh
      await admin.firestore().collection("users").doc(uid).update({
        forceRefresh: admin.firestore.FieldValue.serverTimestamp(),
      });

      return { success: true };
    } catch (error) {
      console.error("Error converting guest to registered user:", error);
      throw new functions.https.HttpsError("internal", error.message);
    }
  }
);
```

## Mobile Implementation

### Auth Provider Interface

```typescript
// Auth provider interface in mobile app
export interface AuthProvider {
  // Core authentication methods
  signInAnonymously(): Promise<UserCredential>;
  signInWithEmailAndPassword(
    email: string,
    password: string
  ): Promise<UserCredential>;
  createUserWithEmailAndPassword(
    email: string,
    password: string
  ): Promise<UserCredential>;
  signInWithGoogle(): Promise<UserCredential>;
  signInWithApple(): Promise<UserCredential>;
  verifyPhoneNumber(phoneNumber: string): Promise<string>; // Returns verification ID
  confirmPhoneVerification(
    verificationId: string,
    code: string
  ): Promise<UserCredential>;

  // Account management
  linkWithCredential(credential: AuthCredential): Promise<UserCredential>;
  reauthenticate(credential: AuthCredential): Promise<void>;
  sendPasswordResetEmail(email: string): Promise<void>;
  updateEmail(email: string): Promise<void>;
  updatePassword(password: string): Promise<void>;
  sendEmailVerification(): Promise<void>;

  // Session management
  getCurrentUser(): User | null;
  signOut(): Promise<void>;
  onAuthStateChanged(listener: (user: User | null) => void): () => void;
  onIdTokenChanged(listener: (user: User | null) => void): () => void;
  getIdToken(forceRefresh?: boolean): Promise<string>;

  // Guest specific methods
  isGuestUser(): boolean;
  convertGuestToRegistered(credential: AuthCredential): Promise<UserCredential>;
}
```

### Auth Provider Implementation (Flutter)

```dart
class FirebaseAuthProvider implements AuthProvider {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final SecureStorage _secureStorage = SecureStorage();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Anonymous authentication (guest mode)
  @override
  Future<UserCredential> signInAnonymously() async {
    try {
      // Check if we have a stored anonymous user ID
      String? storedAnonymousUid = await _secureStorage.read(key: 'anonymous_uid');

      if (storedAnonymousUid != null) {
        // Try to sign in with the stored anonymous account
        try {
          await _firebaseAuth.signInWithCustomToken(
            await _getCustomTokenForAnonymous(storedAnonymousUid)
          );

          final User? currentUser = _firebaseAuth.currentUser;
          if (currentUser != null) {
            return UserCredential(
              user: currentUser,
              credential: null,
              additionalUserInfo: null
            );
          }
        } catch (e) {
          debugPrint('Failed to restore anonymous session, creating new one: $e');
        }
      }

      // Create new anonymous account
      final credential = await _firebaseAuth.signInAnonymously();

      // Store anonymous UID for device
      if (credential.user != null) {
        await _secureStorage.write(
          key: 'anonymous_uid',
          value: credential.user!.uid
        );
        await _storeGuestCredential(credential);

        // Create guest profile
        await _createGuestProfile(credential.user!.uid);
      }

      return credential;
    } catch (e) {
      throw _handleAuthError(e);
    }
  }

  // Convert guest to registered user
  @override
  Future<UserCredential> convertGuestToRegistered(AuthCredential credential) async {
    try {
      final User? currentUser = _firebaseAuth.currentUser;

      if (currentUser == null) {
        throw AuthError(
          code: 'no-user',
          message: 'No authenticated user found'
        );
      }

      if (!currentUser.isAnonymous) {
        throw AuthError(
          code: 'not-anonymous',
          message: 'Current user is not an anonymous user'
        );
      }

      // Link anonymous account with credential
      final UserCredential userCredential = await currentUser.linkWithCredential(credential);

      // Update user profile
      await _convertGuestToRegisteredUser(
        userCredential.user!.uid,
        {
          'email': userCredential.user!.email,
          'displayName': userCredential.user!.displayName,
          'phoneNumber': userCredential.user!.phoneNumber,
          'photoURL': userCredential.user!.photoURL,
        }
      );

      // Clear anonymous credential storage
      await _secureStorage.delete('anonymous_uid');
      await _secureStorage.delete('anonymous_refresh_token');

      return userCredential;
    } catch (e) {
      throw _handleAuthError(e);
    }
  }

  // Check if current user is guest
  @override
  bool isGuestUser() {
    final User? user = _firebaseAuth.currentUser;
    return user != null && user.isAnonymous;
  }

  // Helper methods
  Future<void> _createGuestProfile(String uid) async {
    try {
      final deviceInfo = await _getDeviceInfo();

      await _firestore.collection('users').doc(uid).set({
        'isGuest': true,
        'createdAt': FieldValue.serverTimestamp(),
        'lastActive': FieldValue.serverTimestamp(),
        'deviceId': deviceInfo['uniqueId'],
        'deviceInfo': {
          'platform': deviceInfo['platform'],
          'model': deviceInfo['model'],
          'osVersion': deviceInfo['systemVersion'],
          'appVersion': deviceInfo['appVersion'],
        }
      });

      // Set custom claim for guest user via Cloud Function
      await FirebaseFunctions.instance
        .httpsCallable('setGuestClaim')
        .call({'uid': uid});
    } catch (e) {
      debugPrint('Error creating guest profile: $e');
      throw AuthError(
        code: 'profile-creation-failed',
        message: 'Failed to create guest profile'
      );
    }
  }

  Future<void> _convertGuestToRegisteredUser(
    String uid,
    Map<String, dynamic> userInfo
  ) async {
    try {
      // Start a transaction to ensure data consistency
      await _firestore.runTransaction((transaction) async {
        final userRef = _firestore.collection('users').doc(uid);
        final userDoc = await transaction.get(userRef);

        if (!userDoc.exists) {
          throw Exception('User document not found');
        }

        final userData = userDoc.data()!;

        // Update the user profile, preserving all previous data
        transaction.update(userRef, {
          'isGuest': false,
          'email': userInfo['email'] ?? null,
          'displayName': userInfo['displayName'] ?? null,
          'phoneNumber': userInfo['phoneNumber'] ?? null,
          'photoURL': userInfo['photoURL'] ?? null,
          'convertedAt': FieldValue.serverTimestamp(),
        });
      });

      // Remove guest claim and add registered user claim via Cloud Function
      await FirebaseFunctions.instance
        .httpsCallable('convertGuestToRegistered')
        .call({'uid': uid});
    } catch (e) {
      debugPrint('Error converting guest profile: $e');
      throw AuthError(
        code: 'profile-conversion-failed',
        message: 'Failed to convert guest profile'
      );
    }
  }

  Future<void> _storeGuestCredential(UserCredential credential) async {
    if (credential.user == null) return;

    try {
      // Store refresh token securely
      final token = await credential.user!.getIdToken();
      await _secureStorage.write(
        key: 'anonymous_refresh_token',
        value: token
      );

      // Store UID
      await _secureStorage.write(
        key: 'anonymous_uid',
        value: credential.user!.uid
      );
    } catch (e) {
      debugPrint('Error storing guest credential: $e');
    }
  }

  // Error handling
  AuthError _handleAuthError(dynamic error) {
    // Convert Firebase auth errors to our custom AuthError format
    if (error is FirebaseAuthException) {
      return AuthError(
        code: error.code,
        message: error.message ?? 'Authentication error',
        nativeErrorCode: error.code,
        nativeErrorMessage: error.message
      );
    }

    return AuthError(
      code: 'unknown',
      message: error.toString()
    );
  }
}
```

## Best Practices

1. **Device Identification**

   - Use secure device identifier storage to recognize returning anonymous users
   - Implement device fingerprinting as a fallback for reinstalls
   - Ensure device identifiers comply with privacy regulations

2. **Guest Account Management**

   - Limit the number of guest accounts per device
   - Implement server-side expiry for inactive guest accounts
   - Apply appropriate resource usage limits for guest accounts

3. **Data Migration**

   - Use transactions when converting guest data to ensure consistency
   - Implement recovery mechanisms for failed conversions
   - Provide clear feedback during the conversion process

4. **Security**

   - Use Firebase Authentication custom claims to manage user types
   - Implement proper Firestore security rules for guest vs registered users
   - Never expose sensitive operations to guest accounts

5. **Error Handling**
   - Implement comprehensive error handling for authentication flows
   - Provide user-friendly error messages for common issues
   - Log authentication errors for monitoring and debugging

## Testing Strategy

1. **Unit Tests**

   - Test individual authentication methods in isolation
   - Mock Firebase responses for different scenarios
   - Verify error handling behaves as expected

2. **Integration Tests**

   - Test complete authentication flows end-to-end
   - Verify data persistence across authentication state changes
   - Test guest to registered user conversion with real Firebase services

3. **Edge Cases**

   - Test account conversion with existing email
   - Test device change scenarios for guest users
   - Test concurrent authentication operations

4. **Security Tests**
   - Verify Firestore rules prevent unauthorized access
   - Test token expiration and refresh behavior
   - Verify proper validation of authentication inputs
