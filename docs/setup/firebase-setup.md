# Firebase Setup Guide

This guide walks you through setting up Firebase Authentication for the CareCircle backend.

## Prerequisites

- Google account
- Access to Firebase Console

## Step 1: Create Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click "Create a project"
3. Enter project name: `carecircle-dev` (or your preferred name)
4. Enable Google Analytics (optional)
5. Click "Create project"

## Step 2: Enable Authentication

1. In your Firebase project, go to "Authentication" in the left sidebar
2. Click "Get started"
3. Go to "Sign-in method" tab
4. Enable the following providers:
   - **Email/Password**: Enable
   - **Anonymous**: Enable (for guest mode)
   - **Google**: Enable (optional, for social login)
   - **Phone**: Enable (optional, for phone authentication)

## Step 3: Create Service Account

1. Go to Project Settings (gear icon) → "Service accounts"
2. Click "Generate new private key"
3. Download the JSON file
4. Keep this file secure - it contains sensitive credentials

## Step 4: Configure Backend Environment

1. Open the downloaded service account JSON file
2. Copy the values to your `backend/.env` file:

```env
# Firebase Configuration
FIREBASE_PROJECT_ID=your-actual-project-id
FIREBASE_PRIVATE_KEY_ID=your-actual-private-key-id
FIREBASE_PRIVATE_KEY="-----BEGIN PRIVATE KEY-----\nYOUR_ACTUAL_PRIVATE_KEY\n-----END PRIVATE KEY-----\n"
FIREBASE_CLIENT_EMAIL=your-actual-service-account@your-project.iam.gserviceaccount.com
FIREBASE_CLIENT_ID=your-actual-client-id
FIREBASE_AUTH_URI=https://accounts.google.com/o/oauth2/auth
FIREBASE_TOKEN_URI=https://oauth2.googleapis.com/token
```

**Important Notes:**
- Replace all `your-actual-*` values with real values from your service account JSON
- The private key should include the full key with `\n` for line breaks
- Keep the quotes around the private key value

## Step 5: Configure Mobile App

1. In Firebase Console, go to Project Settings
2. Add an app:
   - For Android: Add Android app with package name `com.carecircle.app`
   - For iOS: Add iOS app with bundle ID `com.carecircle.app`
3. Download configuration files:
   - Android: `google-services.json` → place in `mobile/android/app/`
   - iOS: `GoogleService-Info.plist` → place in `mobile/ios/Runner/`

## Step 6: Test Configuration

1. Start the backend server:
   ```bash
   cd backend
   npm run start:dev
   ```

2. Check the logs for Firebase initialization success
3. Test authentication endpoints using the API

## Security Best Practices

1. **Never commit** service account files to version control
2. Use environment variables for all sensitive data
3. Restrict service account permissions to minimum required
4. Enable Firebase Security Rules for additional protection
5. Monitor authentication logs in Firebase Console

## Troubleshooting

### Common Issues

1. **"Invalid private key"**: Ensure the private key includes proper line breaks (`\n`)
2. **"Project not found"**: Verify the project ID matches your Firebase project
3. **"Permission denied"**: Check that the service account has the correct roles

### Required Service Account Roles

- Firebase Admin SDK Administrator Service Agent
- Service Account Token Creator (if using custom tokens)

## Next Steps

After Firebase is configured:
1. Test user registration and login
2. Implement mobile authentication screens
3. Set up Firebase Security Rules
4. Configure additional authentication providers as needed

## References

- [Firebase Admin SDK Setup](https://firebase.google.com/docs/admin/setup)
- [Firebase Authentication](https://firebase.google.com/docs/auth)
- [Service Account Keys](https://cloud.google.com/iam/docs/creating-managing-service-account-keys)
