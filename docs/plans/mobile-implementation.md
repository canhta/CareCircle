# Mobile Implementation Plan - Flutter

**Version:** 2.0
**Date:** 2025-07-03

---

## Overview

This document details the mobile app implementation plan for CareCircle AI Health Agent using Flutter. The app provides the primary user interface for health data management, medication tracking, and family care coordination.

---

## Sprint 0: Project Setup & Core Infrastructure ✅ COMPLETED

### Task 0.10: Initialize Flutter Project ✅
- **Status:** COMPLETED - Flutter project structure has been set up
- **Next Steps:** Begin implementing navigation and theming

### Task 0.11: Navigation Setup
- **Status:** Ready for implementation
- **Dependencies to add:**
  ```yaml
  dependencies:
    go_router: ^14.2.7
    flutter_bloc: ^8.1.6
  ```

### Task 0.12: Main App Shell
- **Status:** Ready for implementation
- **Priority:** Should be completed early in Sprint 1

### Task 0.13: Theming
- **Status:** Ready for implementation
- **Priority:** Should be completed alongside app shell

---

## Sprint 1: User Authentication & Profiles

### Task 1.9: Authentication Screens
- **Objective:** Implement login/register flow screens
- **Screens to build:**
  - `SplashScreen` - App loading with logo animation
  - `OnboardingScreen` - Carousel introducing app features
  - `LoginScreen` - Email/password login with SSO options
  - `RegisterScreen` - User registration form
  - `ForgotPasswordScreen` - Password reset flow

- **Implementation Details:**
  ```dart
  // Splash Screen with animation
  class SplashScreen extends StatefulWidget {
    @override
    _SplashScreenState createState() => _SplashScreenState();
  }

  class _SplashScreenState extends State<SplashScreen>
      with SingleTickerProviderStateMixin {
    late AnimationController _controller;
    late Animation<double> _fadeAnimation;

    @override
    void initState() {
      super.initState();
      _controller = AnimationController(
        duration: Duration(seconds: 2),
        vsync: this,
      );
      _fadeAnimation = Tween(begin: 0.0, end: 1.0).animate(_controller);
      _controller.forward();
      _checkAuthStatus();
    }

    void _checkAuthStatus() async {
      await Future.delayed(Duration(seconds: 3));
      final isLoggedIn = await AuthService.isLoggedIn();
      if (isLoggedIn) {
        context.go('/home');
      } else {
        context.go('/onboarding');
      }
    }
  }
  ```

### Task 1.10: Backend Auth Integration
- **Objective:** Connect auth screens to backend APIs
- **Dependencies:**
  ```yaml
  dependencies:
    http: ^1.2.2
    dio: ^5.7.0
    google_sign_in: ^6.2.1
    sign_in_with_apple: ^6.1.2
  ```
- **Implementation:**
  - Create `AuthService` class for API calls
  - Implement email/password authentication
  - Add Google Sign-In integration
  - Add Apple Sign-In integration
  - Handle authentication errors and loading states

### Task 1.11: Secure Token Storage
- **Objective:** Store JWT tokens securely
- **Dependencies:**
  ```yaml
  dependencies:
    flutter_secure_storage: ^9.2.2
  ```
- **Implementation:**
  ```dart
  class SecureStorageService {
    static const _storage = FlutterSecureStorage();
    
    static Future<void> storeToken(String token) async {
      await _storage.write(key: 'auth_token', value: token);
    }
    
    static Future<String?> getToken() async {
      return await _storage.read(key: 'auth_token');
    }
    
    static Future<void> deleteToken() async {
      await _storage.delete(key: 'auth_token');
    }
  }
  ```

### Task 1.12: Profile & Settings Screen
- **Objective:** Build user profile management UI
- **Implementation:**
  - Profile picture upload/display
  - Editable user information fields
  - Settings toggles (notifications, privacy, etc.)
  - Account management options (change password, delete account)
  - Theme selection (light/dark mode)

---

## Sprint 2: Health Data Integration

### Task 2.4: Health Data Integration
- **Objective:** Connect to device health platforms
- **Dependencies:**
  ```yaml
  dependencies:
    health: ^10.2.0
  ```
- **Implementation:**
  ```dart
  class HealthService {
    static final Health _health = Health();
    
    static Future<bool> requestPermissions() async {
      final types = [
        HealthDataType.STEPS,
        HealthDataType.HEART_RATE,
        HealthDataType.SLEEP_IN_BED,
        HealthDataType.WEIGHT,
        HealthDataType.BLOOD_PRESSURE_SYSTOLIC,
        HealthDataType.BLOOD_PRESSURE_DIASTOLIC,
      ];
      
      return await _health.requestAuthorization(types);
    }
    
    static Future<List<HealthDataPoint>> getHealthData({
      required DateTime startDate,
      required DateTime endDate,
    }) async {
      return await _health.getHealthDataFromTypes(
        startDate,
        endDate,
        [HealthDataType.STEPS, HealthDataType.HEART_RATE],
      );
    }
  }
  ```

### Task 2.5: Health Data Sync Logic
- **Objective:** Implement background sync and permission handling
- **Implementation:**
  - Request health permissions on first app launch
  - Implement background sync scheduler
  - Handle permission denied scenarios
  - Batch sync optimization for network efficiency
  - Sync status indicators and error handling

### Task 2.6: Health Metrics Dashboard UI
- **Objective:** Display health data with charts
- **Dependencies:**
  ```yaml
  dependencies:
    fl_chart: ^0.69.0
  ```
- **Implementation:**
  ```dart
  class HealthDashboard extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(title: Text('Health Metrics')),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              _buildStepsCard(),
              SizedBox(height: 16),
              _buildHeartRateCard(),
              SizedBox(height: 16),
              _buildSleepCard(),
              SizedBox(height: 16),
              _buildWeightCard(),
            ],
          ),
        ),
      );
    }

    Widget _buildStepsCard() {
      return Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.directions_walk, color: Colors.blue),
                  SizedBox(width: 8),
                  Text('Steps', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
              SizedBox(height: 16),
              Container(
                height: 200,
                child: LineChart(
                  // Chart configuration for steps data
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
  ```

### Task 2.7: Data Display and Sync Status
- **Objective:** Show synced data on dashboard with status indicators
- **Implementation:**
  - Real-time data display with periodic updates
  - Sync status indicators (last sync time, sync in progress)
  - Pull-to-refresh functionality
  - Offline data handling and caching
  - Data visualization with different time ranges (daily, weekly, monthly)

---

## Sprint 3: Medication Management

### Task 3.5: Medication Management Screen
- **Objective:** Build medication list and management UI
- **Implementation:**
  ```dart
  class MedicationListScreen extends StatefulWidget {
    @override
    _MedicationListScreenState createState() => _MedicationListScreenState();
  }

  class _MedicationListScreenState extends State<MedicationListScreen> {
    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text('My Medications'),
          actions: [
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () => context.push('/medications/add'),
            ),
          ],
        ),
        body: BlocBuilder<MedicationBloc, MedicationState>(
          builder: (context, state) {
            if (state is MedicationLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is MedicationLoaded) {
              return ListView.builder(
                itemCount: state.medications.length,
                itemBuilder: (context, index) {
                  final medication = state.medications[index];
                  return MedicationCard(
                    medication: medication,
                    onTap: () => context.push('/medications/${medication.id}'),
                  );
                },
              );
            } else if (state is MedicationError) {
              return Center(child: Text('Error: ${state.message}'));
            }
            return Container();
          },
        ),
      );
    }
  }
  ```

### Task 3.6: Manual Medication Entry
- **Objective:** Create form for adding medications manually
- **Implementation:**
  - Multi-step form for medication details
  - Input fields: name, dosage, instructions, side effects
  - Schedule configuration (times, days of week)
  - Form validation and error handling
  - Save to local storage and sync to backend

### Task 3.7: OCR Scanner Implementation
- **Objective:** Scan prescription bottles/labels for medication info
- **Dependencies:**
  ```yaml
  dependencies:
    camera: ^0.10.6
    google_mlkit_text_recognition: ^0.13.1
    image_picker: ^1.1.2
  ```
- **Implementation:**
  ```dart
  class OCRScannerScreen extends StatefulWidget {
    @override
    _OCRScannerScreenState createState() => _OCRScannerScreenState();
  }

  class _OCRScannerScreenState extends State<OCRScannerScreen> {
    late CameraController _cameraController;
    final TextRecognizer _textRecognizer = TextRecognizer();

    @override
    void initState() {
      super.initState();
      _initializeCamera();
    }

    void _initializeCamera() async {
      final cameras = await availableCameras();
      _cameraController = CameraController(
        cameras.first,
        ResolutionPreset.high,
      );
      await _cameraController.initialize();
      setState(() {});
    }

    void _captureAndProcessImage() async {
      final XFile image = await _cameraController.takePicture();
      final InputImage inputImage = InputImage.fromFilePath(image.path);
      final RecognizedText recognizedText = await _textRecognizer.processImage(inputImage);
      
      // Send text to backend for parsing
      final parsedMedication = await MedicationService.parseOCRText(recognizedText.text);
      
      // Navigate to review screen
      context.push('/medications/review', extra: parsedMedication);
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(title: Text('Scan Prescription')),
        body: Stack(
          children: [
            if (_cameraController.value.isInitialized)
              CameraPreview(_cameraController),
            Positioned(
              bottom: 50,
              left: 0,
              right: 0,
              child: Center(
                child: FloatingActionButton(
                  onPressed: _captureAndProcessImage,
                  child: Icon(Icons.camera),
                ),
              ),
            ),
          ],
        ),
      );
    }
  }
  ```

### Task 3.8: OCR Review and Confirmation
- **Objective:** Review and edit scanned medication details
- **Implementation:**
  - Display extracted text and parsed medication details
  - Allow user to edit/correct any fields
  - Confidence indicators for parsed data
  - Save confirmed medication to backend
  - Handle parsing errors gracefully

---

## Sprint 4: Reminders & Notifications

### Task 4.5: Push Notification Configuration
- **Objective:** Set up Firebase messaging for notifications
- **Dependencies:**
  ```yaml
  dependencies:
    firebase_core: ^3.6.0
    firebase_messaging: ^15.1.3
    flutter_local_notifications: ^18.0.1
  ```
- **Implementation:**
  ```dart
  class NotificationService {
    static final FlutterLocalNotificationsPlugin _localNotifications =
        FlutterLocalNotificationsPlugin();
    
    static Future<void> initialize() async {
      await Firebase.initializeApp();
      
      const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
      const iosSettings = DarwinInitializationSettings(
        requestSoundPermission: true,
        requestBadgePermission: true,
        requestAlertPermission: true,
      );
      
      await _localNotifications.initialize(
        InitializationSettings(android: androidSettings, iOS: iosSettings),
        onDidReceiveNotificationResponse: _onNotificationTapped,
      );
      
      await FirebaseMessaging.instance.requestPermission();
      FirebaseMessaging.onMessage.listen(_onForegroundMessage);
      FirebaseMessaging.onMessageOpenedApp.listen(_onNotificationTapped);
    }
    
    static void _onForegroundMessage(RemoteMessage message) {
      _showLocalNotification(message);
    }
    
    static void _onNotificationTapped(dynamic payload) {
      // Handle notification tap
    }
  }
  ```

### Task 4.6: Actionable Notification UI
- **Objective:** Handle medication reminder interactions
- **Implementation:**
  - In-app notification banners
  - Action buttons: "Taken", "Snooze", "Skip"
  - Notification history screen
  - Custom notification sounds and vibration patterns
  ```dart
  class MedicationReminderNotification extends StatelessWidget {
    final Medication medication;
    final VoidCallback onTaken;
    final VoidCallback onSnooze;
    final VoidCallback onSkip;

    @override
    Widget build(BuildContext context) {
      return Card(
        margin: EdgeInsets.all(16),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Time for your medication',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                '${medication.name} - ${medication.dosage}',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: onTaken,
                    icon: Icon(Icons.check),
                    label: Text('Taken'),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  ),
                  ElevatedButton.icon(
                    onPressed: onSnooze,
                    icon: Icon(Icons.snooze),
                    label: Text('Snooze'),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                  ),
                  ElevatedButton.icon(
                    onPressed: onSkip,
                    icon: Icon(Icons.close),
                    label: Text('Skip'),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }
  }
  ```

### Task 4.7: Notification Action Handling
- **Objective:** Process user responses to reminders
- **Implementation:**
  - Update local medication status
  - Sync responses to backend
  - Update UI to reflect current status
  - Handle offline scenarios with local storage

### Task 4.8: Today's Medications Widget
- **Objective:** Home dashboard widget showing daily medication schedule
- **Implementation:**
  ```dart
  class TodaysMedicationsWidget extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
      return Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.medication, color: Colors.blue),
                  SizedBox(width: 8),
                  Text(
                    "Today's Medications",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(height: 16),
              BlocBuilder<MedicationBloc, MedicationState>(
                builder: (context, state) {
                  if (state is TodaysMedicationsLoaded) {
                    return Column(
                      children: state.todaysMedications.map((med) {
                        return MedicationScheduleItem(
                          medication: med.medication,
                          schedule: med.schedule,
                          isTaken: med.isTaken,
                          onTaken: () => _markAsTaken(med),
                        );
                      }).toList(),
                    );
                  }
                  return CircularProgressIndicator();
                },
              ),
            ],
          ),
        ),
      );
    }
  }
  ```

---

## Sprint 5: Care Groups & Guided Setup

### Task 5.5: Care Groups Management Screen
- **Objective:** UI for managing family/caregiver connections
- **Implementation:**
  ```dart
  class CareGroupsScreen extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Care Groups'),
          actions: [
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () => _showCreateGroupDialog(context),
            ),
          ],
        ),
        body: BlocBuilder<CareGroupBloc, CareGroupState>(
          builder: (context, state) {
            if (state is CareGroupLoaded) {
              return ListView.builder(
                itemCount: state.groups.length,
                itemBuilder: (context, index) {
                  final group = state.groups[index];
                  return CareGroupCard(
                    group: group,
                    onTap: () => context.push('/care-groups/${group.id}'),
                  );
                },
              );
            }
            return Center(child: CircularProgressIndicator());
          },
        ),
      );
    }

    void _showCreateGroupDialog(BuildContext context) {
      showDialog(
        context: context,
        builder: (context) => CreateCareGroupDialog(),
      );
    }
  }
  ```

### Task 5.6: Invitation Flow Implementation
- **Objective:** Share and join care groups via links
- **Dependencies:**
  ```yaml
  dependencies:
    share_plus: ^10.0.2
    app_links: ^6.3.2
  ```
- **Implementation:**
  - Generate and share invitation links
  - Handle deep links for group joining
  - QR code generation and scanning for invites
  - Invitation status tracking (pending, accepted, declined)

### Task 5.7: Care Group Details Screen
- **Objective:** Display shared member health data
- **Implementation:**
  - Member list with roles (owner, caregiver, member)
  - Shared health data visualization
  - Permission settings for data sharing
  - Member-specific medication adherence tracking
  - Communication shortcuts (call, text, email)

### Task 5.8: Communication Shortcuts
- **Objective:** Quick communication with care group members
- **Dependencies:**
  ```yaml
  dependencies:
    url_launcher: ^6.3.1
  ```
- **Implementation:**
  ```dart
  class CommunicationShortcuts extends StatelessWidget {
    final User member;

    @override
    Widget build(BuildContext context) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            icon: Icon(Icons.phone),
            onPressed: () => _makePhoneCall(member.phoneNumber),
          ),
          IconButton(
            icon: Icon(Icons.message),
            onPressed: () => _sendSMS(member.phoneNumber),
          ),
          IconButton(
            icon: Icon(Icons.email),
            onPressed: () => _sendEmail(member.email),
          ),
        ],
      );
    }

    void _makePhoneCall(String phoneNumber) async {
      final url = 'tel:$phoneNumber';
      if (await canLaunch(url)) {
        await launch(url);
      }
    }

    void _sendSMS(String phoneNumber) async {
      final url = 'sms:$phoneNumber';
      if (await canLaunch(url)) {
        await launch(url);
      }
    }

    void _sendEmail(String email) async {
      final url = 'mailto:$email';
      if (await canLaunch(url)) {
        await launch(url);
      }
    }
  }
  ```

### Task 5.9: Guided Setup Flow
- **Objective:** Onboard new users through app features
- **Implementation:**
  - Multi-step guided tour
  - Feature introduction with interactive elements
  - Permission requests with explanations
  - Initial health data sync setup
  - First medication entry guidance
  - Care group creation/joining assistance

---

## Sprint 6: MVP Polish & Deployment

### Task 6.3: End-to-End Testing
- **Objective:** Comprehensive testing of all features
- **Testing Strategy:**
  - Unit tests for business logic
  - Widget tests for UI components
  - Integration tests for API calls
  - User flow testing (authentication, medication management, etc.)
  - Device-specific testing (iOS/Android)
  - Performance testing on older devices

### Task 6.4: App Store Preparation
- **Objective:** Prepare for App Store and Google Play submission
- **Implementation:**
  - App icons for all required sizes
  - Screenshots for different device sizes
  - App Store descriptions and metadata
  - Privacy policy and terms of service integration
  - App signing and release build configuration
  - Beta testing with TestFlight and Google Play Console

---

## Phase 2: Post-MVP Enhancements

### Sprint 7: Monetization & Premium Features

### Task 7.5: Premium Upgrade Screen
- **Objective:** Subscription management and premium features showcase
- **Dependencies:**
  ```yaml
  dependencies:
    in_app_purchase: ^3.2.0
  ```
- **Implementation:**
  ```dart
  class PremiumUpgradeScreen extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(title: Text('Upgrade to Premium')),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              _buildFeatureComparison(),
              SizedBox(height: 24),
              _buildPricingPlans(),
              SizedBox(height: 24),
              _buildSubscribeButton(),
            ],
          ),
        ),
      );
    }

    Widget _buildFeatureComparison() {
      return Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Text('Premium Features', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 16),
              _buildFeatureRow('AI Health Insights', true),
              _buildFeatureRow('Advanced Analytics', true),
              _buildFeatureRow('Unlimited Care Groups', true),
              _buildFeatureRow('Priority Support', true),
              _buildFeatureRow('Data Export', true),
            ],
          ),
        ),
      );
    }
  }
  ```

### Task 7.6: In-App Purchase Integration
- **Objective:** Handle subscription purchases on mobile platforms
- **Implementation:**
  - Product configuration for different subscription tiers
  - Purchase flow handling
  - Receipt validation with backend
  - Subscription status management
  - Restore purchases functionality

### Task 7.7: Feature Gating
- **Objective:** Lock premium features based on subscription status
- **Implementation:**
  - Feature flag system integration
  - UI indicators for premium features
  - Upgrade prompts for locked features
  - Graceful degradation for expired subscriptions

### Task 7.8: Referral Program UI
- **Objective:** Interface for user referrals
- **Implementation:**
  - Referral code generation and sharing
  - Referral progress tracking
  - Reward display and redemption
  - Social sharing integration

### Sprint 8: AI-Powered Features

### Task 8.4: AI Insights Display
- **Objective:** Show AI-generated health insights
- **Implementation:**
  - Health summary cards with AI insights
  - Medication recommendations based on health data
  - Trend analysis and predictions
  - Personalized health tips and suggestions

### Task 8.5: AI-Powered Medication Summary
- **Objective:** Premium feature for detailed medication analysis
- **Implementation:**
  - Drug interaction checking
  - Side effect monitoring based on health data
  - Adherence pattern analysis
  - Optimization suggestions for medication timing

### Sprint 9: Gamification & Engagement

### Task 9.3: Daily Check-in Feature
- **Objective:** Engage users with daily health check-ins
- **Implementation:**
  ```dart
  class DailyCheckInScreen extends StatefulWidget {
    @override
    _DailyCheckInScreenState createState() => _DailyCheckInScreenState();
  }

  class _DailyCheckInScreenState extends State<DailyCheckInScreen> {
    int _moodRating = 3;
    int _energyLevel = 3;
    int _sleepQuality = 3;
    String _notes = '';

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(title: Text('Daily Check-in')),
        body: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('How are you feeling today?', style: TextStyle(fontSize: 18)),
              SizedBox(height: 16),
              _buildMoodSelector(),
              SizedBox(height: 24),
              _buildEnergyLevelSelector(),
              SizedBox(height: 24),
              _buildSleepQualitySelector(),
              SizedBox(height: 24),
              _buildNotesField(),
              Spacer(),
              _buildSubmitButton(),
            ],
          ),
        ),
      );
    }

    Widget _buildSubmitButton() {
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: _submitCheckIn,
          child: Text('Complete Check-in'),
        ),
      );
    }

    void _submitCheckIn() async {
      final checkIn = DailyCheckIn(
        mood: _moodRating,
        energy: _energyLevel,
        sleep: _sleepQuality,
        notes: _notes,
        date: DateTime.now(),
      );
      
      await CheckInService.submitCheckIn(checkIn);
      Navigator.pop(context);
    }
  }
  ```

### Task 9.4: Gamification UI Elements
- **Objective:** Display points, badges, and achievements
- **Implementation:**
  - Points counter with animations
  - Badge collection screen
  - Achievement notifications
  - Progress tracking for health goals
  - Leaderboard for care group challenges

### Task 9.5: Gamification Notifications
- **Objective:** Notify users of achievements and milestones
- **Implementation:**
  - Achievement unlock animations
  - Weekly/monthly progress summaries
  - Streak maintenance reminders
  - Challenge completion celebrations

### Sprint 10: Advanced Features & Accessibility

### Task 10.3: Elder Mode Implementation
- **Objective:** Accessibility-focused UI for elderly users
- **Implementation:**
  ```dart
  class ElderModeProvider extends ChangeNotifier {
    bool _isElderMode = false;
    
    bool get isElderMode => _isElderMode;
    
    void toggleElderMode() {
      _isElderMode = !_isElderMode;
      notifyListeners();
    }
    
    ThemeData get theme {
      if (_isElderMode) {
        return ThemeData(
          textTheme: TextTheme(
            bodyLarge: TextStyle(fontSize: 20),
            bodyMedium: TextStyle(fontSize: 18),
            headlineLarge: TextStyle(fontSize: 32),
          ),
          iconTheme: IconThemeData(size: 32),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              minimumSize: Size(200, 60),
              textStyle: TextStyle(fontSize: 20),
            ),
          ),
        );
      }
      return AppTheme.lightTheme;
    }
  }

  class ElderModeScreen extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
      return Consumer<ElderModeProvider>(
        builder: (context, elderMode, child) {
          return Scaffold(
            appBar: AppBar(
              title: Text('CareCircle', style: TextStyle(fontSize: 24)),
              backgroundColor: Colors.blue[100],
            ),
            body: Padding(
              padding: EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildLargeButton(
                    'My Medications',
                    Icons.medication,
                    () => context.push('/medications'),
                  ),
                  _buildLargeButton(
                    'Call Family',
                    Icons.phone,
                    () => _showCallOptions(context),
                  ),
                  _buildLargeButton(
                    'Health Summary',
                    Icons.favorite,
                    () => context.push('/health'),
                  ),
                  _buildLargeButton(
                    'Settings',
                    Icons.settings,
                    () => context.push('/settings'),
                  ),
                ],
              ),
            ),
          );
        },
      );
    }

    Widget _buildLargeButton(String title, IconData icon, VoidCallback onPressed) {
      return SizedBox(
        width: double.infinity,
        height: 80,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue[50],
            foregroundColor: Colors.blue[900],
            elevation: 4,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 32),
              SizedBox(width: 16),
              Text(title, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      );
    }
  }
  ```

### Task 10.4: Granular Sharing Controls
- **Objective:** Fine-grained data sharing permissions
- **Implementation:**
  - Permission toggle for each data type
  - Time-limited sharing options
  - Individual member permission settings
  - Consent management interface

### Task 10.5: E-Pharmacy Integration
- **Objective:** Medication refill request flow
- **Implementation:**
  - Partner pharmacy selection
  - Prescription upload and verification
  - Order tracking and status updates
  - Insurance information management

### Task 10.6: PDF Health Summary Export
- **Objective:** Generate and share health reports
- **Dependencies:**
  ```yaml
  dependencies:
    pdf: ^3.11.1
    printing: ^5.13.2
  ```
- **Implementation:**
  - Health data compilation and formatting
  - PDF generation with charts and summaries
  - Share functionality (email, cloud storage)
  - Print preview and direct printing

---

## Implementation Status & Next Steps

### Current Status
- ✅ **Project Setup Complete** - Flutter project initialized with proper structure
- ✅ **Basic Architecture** - Feature-based folder structure established
- ✅ **Development Environment** - Ready for feature implementation

### Immediate Next Steps (Sprint 1)
1. **Setup Navigation** - Implement go_router with bottom navigation
2. **Create App Shell** - Main navigation structure and theming
3. **Authentication Screens** - Login, register, onboarding flows
4. **Backend Integration** - API service and secure token storage
5. **Profile Management** - Basic user profile and settings

### Dependencies to Install First
```yaml
dependencies:
  # Navigation & State Management
  go_router: ^14.2.7
  flutter_bloc: ^8.1.6
  
  # HTTP & Authentication
  http: ^1.2.2
  dio: ^5.7.0
  google_sign_in: ^6.2.1
  sign_in_with_apple: ^6.1.2
  flutter_secure_storage: ^9.2.2
  
  # Health Data Integration
  health: ^10.2.0
  
  # UI & Charts
  fl_chart: ^0.69.0
  
  # Camera & OCR
  camera: ^0.10.6
  google_mlkit_text_recognition: ^0.13.1
  image_picker: ^1.1.2
  
  # Notifications
  firebase_core: ^3.6.0
  firebase_messaging: ^15.1.3
  flutter_local_notifications: ^18.0.1
  
  # Utilities
  share_plus: ^10.0.2
  url_launcher: ^6.3.1
  app_links: ^6.3.2
```

---

## State Management Strategy

### BLoC Pattern Implementation
- **Objective:** Consistent state management across the app
- **Structure:**
  ```
  lib/
    features/
      auth/
        bloc/
          auth_bloc.dart
          auth_event.dart
          auth_state.dart
        data/
          auth_repository.dart
          auth_service.dart
        presentation/
          screens/
          widgets/
      medications/
        bloc/
          medication_bloc.dart
          medication_event.dart
          medication_state.dart
  ```

### Key BLoCs to Implement:
1. **AuthBloc** - User authentication state
2. **MedicationBloc** - Medication management
3. **HealthDataBloc** - Health metrics and sync
4. **CareGroupBloc** - Family connections
5. **NotificationBloc** - Reminder management
6. **ThemeBloc** - App theming and elder mode

---

## Testing Strategy

### Unit Tests
- BLoC logic testing
- Service layer testing
- Utility function testing
- Model validation testing

### Widget Tests
- Screen UI testing
- Component interaction testing
- Navigation flow testing
- State transition testing

### Integration Tests
- API integration testing
- Database operations testing
- Authentication flow testing
- End-to-end user journeys

### Performance Testing
- Memory usage monitoring
- Battery usage optimization
- Network efficiency testing
- UI responsiveness testing

---

## Platform-Specific Considerations

### iOS Implementation
- HealthKit integration specifics
- Apple Sign-In implementation
- APNs configuration
- App Store submission requirements

### Android Implementation
- Google Fit integration
- Google Sign-In setup
- FCM configuration
- Play Store submission requirements

### Responsive Design
- Tablet layout adaptations
- Different screen density support
- Orientation handling
- Accessibility compliance (WCAG guidelines)
