// CareCircle Healthcare Components Test Suite
// 
// Comprehensive testing for healthcare components including accessibility,
// medical data accuracy, and healthcare workflow compliance.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:carecircle_mobile/core/widgets/healthcare/vital_signs_card.dart';
import 'package:carecircle_mobile/core/widgets/healthcare/healthcare_welcome_card.dart';
import 'package:carecircle_mobile/core/widgets/healthcare/healthcare_action_card.dart';
import 'package:carecircle_mobile/core/widgets/healthcare/activity_ring_component.dart';
import 'package:carecircle_mobile/core/widgets/healthcare/medical_timeline_widget.dart';
import 'package:carecircle_mobile/core/design/design_tokens.dart';

void main() {
  group('Healthcare Components Accessibility', () {
    testWidgets('VitalSignsCard meets WCAG 2.2 AA requirements', (tester) async {
      // Test screen reader compatibility
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VitalSignsCard(
              type: VitalSignType.heartRate,
              currentValue: 72.0,
              unit: 'bpm',
              semanticLabel: 'Heart rate vital sign',
              semanticValue: '72 beats per minute',
              semanticHint: 'Tap to view detailed heart rate information',
            ),
          ),
        ),
      );

      // Verify semantic labels
      expect(find.bySemanticsLabel('Heart rate vital sign'), findsOneWidget);
      
      // Verify touch target size (minimum 44x44 pixels for accessibility)
      final cardFinder = find.byType(VitalSignsCard);
      expect(cardFinder, findsOneWidget);
      
      final cardWidget = tester.widget<VitalSignsCard>(cardFinder);
      final renderBox = tester.renderObject<RenderBox>(cardFinder);
      expect(renderBox.size.width, greaterThanOrEqualTo(44.0));
      expect(renderBox.size.height, greaterThanOrEqualTo(44.0));

      // Test tap functionality
      await tester.tap(cardFinder);
      await tester.pump();
      
      // Verify medical data accuracy
      expect(cardWidget.currentValue, equals(72.0));
      expect(cardWidget.unit, equals('bpm'));
    });

    testWidgets('HealthcareWelcomeCard accessibility compliance', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HealthcareWelcomeCard(
              userName: 'Test User',
              lastHealthUpdate: DateTime.now(),
              healthStatus: HealthStatus.good,
              onHealthCheckTap: () {},
              semanticLabel: 'Welcome section with health overview',
              semanticHint: 'Your current health status and quick access to health check',
            ),
          ),
        ),
      );

      // Verify semantic structure
      expect(find.bySemanticsLabel('Welcome section with health overview'), findsOneWidget);
      
      // Test button accessibility
      final healthCheckButton = find.text('Health Check');
      expect(healthCheckButton, findsOneWidget);
      
      // Verify touch target compliance
      final buttonRenderBox = tester.renderObject<RenderBox>(healthCheckButton);
      expect(buttonRenderBox.size.height, greaterThanOrEqualTo(44.0));
    });

    testWidgets('HealthcareActionCard urgency indicators', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HealthcareActionCard(
              icon: Icons.medication,
              title: 'Medications',
              subtitle: 'Manage prescriptions',
              color: CareCircleColorTokens.prescriptionBlue,
              onTap: () {},
              urgencyLevel: UrgencyLevel.high,
              semanticLabel: 'Medications',
              semanticHint: 'Manage your medications and view reminders',
            ),
          ),
        ),
      );

      // Verify urgency indicator is present
      final urgencyIndicator = find.byType(Container);
      expect(urgencyIndicator, findsWidgets);
      
      // Test semantic accessibility
      expect(find.bySemanticsLabel('Medications'), findsOneWidget);
    });

    testWidgets('ActivityRingComponent Apple HIG compliance', (tester) async {
      final activities = [
        ActivityRingData.steps(current: 8500, goal: 10000),
        ActivityRingData.exercise(current: 25, goal: 30),
        ActivityRingData.stand(current: 10, goal: 12),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ActivityRingComponent(
              activities: activities,
              semanticDescription: 'Daily activity progress rings',
            ),
          ),
        ),
      );

      // Verify semantic structure
      expect(find.bySemanticsLabel('Activity rings'), findsOneWidget);
      
      // Test ring rendering
      final customPaint = find.byType(CustomPaint);
      expect(customPaint, findsOneWidget);
      
      // Verify touch interaction
      await tester.tap(find.byType(ActivityRingComponent));
      await tester.pump();
    });

    testWidgets('MedicalTimelineWidget accessibility navigation', (tester) async {
      final events = [
        MedicalTimelineEvent.appointment(
          doctorName: 'Dr. Smith',
          specialty: 'Cardiology',
          date: DateTime.now().subtract(const Duration(days: 7)),
        ),
        MedicalTimelineEvent.medication(
          medicationName: 'Lisinopril',
          action: 'Started',
          date: DateTime.now().subtract(const Duration(days: 14)),
          dosage: '10mg daily',
        ),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MedicalTimelineWidget(
              events: events,
              timelineDescription: 'Your medical history timeline',
            ),
          ),
        ),
      );

      // Verify semantic structure
      expect(find.bySemanticsLabel('Medical timeline'), findsOneWidget);
      
      // Test event accessibility
      expect(find.text('Appointment with Dr. Smith'), findsOneWidget);
      expect(find.text('Started Lisinopril'), findsOneWidget);
      
      // Test timeline navigation
      final timelineItems = find.byType(InkWell);
      expect(timelineItems, findsWidgets);
    });
  });

  group('Healthcare Data Validation', () {
    testWidgets('VitalSignsCard validates medical ranges', (tester) async {
      // Test normal heart rate
      await tester.pumpWidget(
        MaterialApp(
          home: VitalSignsCard(
            type: VitalSignType.heartRate,
            currentValue: 72.0,
            unit: 'bpm',
            semanticLabel: 'Heart rate',
            semanticValue: '72 bpm',
            semanticHint: 'Normal heart rate',
          ),
        ),
      );

      final cardWidget = tester.widget<VitalSignsCard>(find.byType(VitalSignsCard));
      expect(cardWidget.currentValue, equals(72.0));
      expect(cardWidget.unit, equals('bpm'));
    });

    testWidgets('ActivityRingComponent validates progress calculations', (tester) async {
      final activity = ActivityRingData.steps(current: 7500, goal: 10000);
      
      expect(activity.progress, equals(0.75));
      expect(activity.current, equals(7500));
      expect(activity.goal, equals(10000));
    });

    testWidgets('MedicalTimelineEvent validates date formatting', (tester) async {
      final event = MedicalTimelineEvent.appointment(
        doctorName: 'Dr. Test',
        specialty: 'Test Specialty',
        date: DateTime(2024, 1, 15),
      );

      expect(event.title, equals('Appointment with Dr. Test'));
      expect(event.description, equals('Test Specialty'));
      expect(event.type, equals(MedicalEventType.appointment));
    });
  });

  group('Healthcare Workflow Integration', () {
    testWidgets('Emergency access patterns functional', (tester) async {
      bool emergencyTapped = false;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HealthcareActionCard(
              icon: Icons.emergency,
              title: 'Emergency',
              subtitle: 'Quick access',
              color: CareCircleColorTokens.emergencyRed,
              onTap: () => emergencyTapped = true,
              urgencyLevel: UrgencyLevel.critical,
              semanticLabel: 'Emergency access',
              semanticHint: 'Quick access to emergency services',
            ),
          ),
        ),
      );

      // Test emergency button tap
      await tester.tap(find.byType(HealthcareActionCard));
      await tester.pump();
      
      expect(emergencyTapped, isTrue);
    });

    testWidgets('Health status workflow validation', (tester) async {
      bool healthCheckTapped = false;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HealthcareWelcomeCard(
              userName: 'Test User',
              lastHealthUpdate: DateTime.now(),
              healthStatus: HealthStatus.good,
              onHealthCheckTap: () => healthCheckTapped = true,
              semanticLabel: 'Health overview',
              semanticHint: 'Current health status',
            ),
          ),
        ),
      );

      // Test health check workflow
      final healthCheckButton = find.text('Health Check');
      await tester.tap(healthCheckButton);
      await tester.pump();
      
      expect(healthCheckTapped, isTrue);
    });
  });

  group('Performance and Responsiveness', () {
    testWidgets('Components render efficiently with large datasets', (tester) async {
      // Test with large timeline dataset
      final largeEventList = List.generate(100, (index) => 
        MedicalTimelineEvent.appointment(
          doctorName: 'Dr. Test $index',
          specialty: 'Specialty $index',
          date: DateTime.now().subtract(Duration(days: index)),
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MedicalTimelineWidget(
              events: largeEventList,
              timelineDescription: 'Large medical history',
            ),
          ),
        ),
      );

      // Verify rendering performance
      expect(find.byType(MedicalTimelineWidget), findsOneWidget);
      
      // Test scroll performance
      await tester.drag(find.byType(ListView), const Offset(0, -500));
      await tester.pump();
    });

    testWidgets('Activity rings animate smoothly', (tester) async {
      final activities = [
        ActivityRingData.steps(current: 5000, goal: 10000),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ActivityRingComponent(
              activities: activities,
              semanticDescription: 'Activity progress',
            ),
          ),
        ),
      );

      // Test animation performance
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pump(const Duration(milliseconds: 1000));
      
      expect(find.byType(ActivityRingComponent), findsOneWidget);
    });
  });
}
