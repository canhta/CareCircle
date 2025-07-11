import 'package:flutter/material.dart';

/// CareCircle Healthcare Icon System
///
/// Provides consistent, healthcare-optimized icons throughout the application.
/// Icons are selected for clarity, medical context, and accessibility.
class CareCircleIcons {
  // Navigation Icons
  /// Home dashboard icon
  static const IconData home = Icons.home_outlined;

  /// Health data icon
  static const IconData healthData = Icons.health_and_safety_outlined;

  /// AI assistant icon
  static const IconData aiAssistant = Icons.psychology_outlined;

  /// Medication icon
  static const IconData medication = Icons.medication_outlined;

  /// Profile icon
  static const IconData profile = Icons.person_outline;

  /// Care circle/community icon
  static const IconData careCircle = Icons.people_outline;

  // Healthcare Action Icons
  /// Health metrics icon
  static const IconData healthMetrics = Icons.monitor_heart_outlined;

  /// Emergency icon
  static const IconData emergency = Icons.emergency_outlined;

  /// Account/settings icon
  static const IconData account = Icons.account_circle_outlined;

  /// Notifications icon
  static const IconData notifications = Icons.notifications_outlined;

  /// Sync icon
  static const IconData sync = Icons.sync_outlined;

  /// Settings icon
  static const IconData settings = Icons.settings_outlined;

  // Vital Signs Icons
  /// Heart rate icon
  static const IconData heartRate = Icons.favorite_outline;

  /// Blood pressure icon
  static const IconData bloodPressure = Icons.monitor_heart_outlined;

  /// Temperature icon
  static const IconData temperature = Icons.thermostat_outlined;

  /// Oxygen saturation icon
  static const IconData oxygenSaturation = Icons.air_outlined;

  /// Respiratory rate icon
  static const IconData respiratoryRate = Icons.air_outlined;

  /// Blood glucose icon
  static const IconData bloodGlucose = Icons.water_drop_outlined;

  /// Weight icon
  static const IconData weight = Icons.scale_outlined;

  /// Steps icon
  static const IconData steps = Icons.directions_walk_outlined;

  /// Sleep icon
  static const IconData sleep = Icons.bedtime_outlined;

  // Medical Icons
  /// Prescription icon
  static const IconData prescription = Icons.receipt_outlined;

  /// Pill/medication icon
  static const IconData pill = Icons.medication_liquid_outlined;

  /// Syringe/injection icon
  static const IconData injection = Icons.vaccines_outlined;

  /// Medical ID icon
  static const IconData medicalId = Icons.badge_outlined;

  /// Allergies icon
  static const IconData allergies = Icons.warning_amber_outlined;

  /// Symptoms icon
  static const IconData symptoms = Icons.sick_outlined;

  // Emergency and Alert Icons
  /// Critical alert icon
  static const IconData criticalAlert = Icons.error_outline;

  /// Warning icon
  static const IconData warning = Icons.warning_outlined;

  /// Info icon
  static const IconData info = Icons.info_outline;

  /// Success icon
  static const IconData success = Icons.check_circle_outline;

  /// Emergency call icon
  static const IconData emergencyCall = Icons.phone_outlined;

  /// Emergency contact icon
  static const IconData emergencyContact = Icons.contact_emergency_outlined;

  /// Medical history icon
  static const IconData medicalHistory = Icons.history_edu;

  /// Appointment icon
  static const IconData appointment = Icons.event;

  /// Lab results icon
  static const IconData labResults = Icons.science;

  /// Surgery icon
  static const IconData surgery = Icons.local_hospital;

  // Data and Chart Icons
  /// Chart/graph icon
  static const IconData chart = Icons.show_chart_outlined;

  /// Trend up icon
  static const IconData trendUp = Icons.trending_up_outlined;

  /// Trend down icon
  static const IconData trendDown = Icons.trending_down_outlined;

  /// Trend flat icon
  static const IconData trendFlat = Icons.trending_flat_outlined;

  /// Calendar icon
  static const IconData calendar = Icons.calendar_today_outlined;

  /// History icon
  static const IconData history = Icons.history_outlined;

  // Form and Input Icons
  /// Add icon
  static const IconData add = Icons.add_outlined;

  /// Edit icon
  static const IconData edit = Icons.edit_outlined;

  /// Delete icon
  static const IconData delete = Icons.delete_outline;

  /// Save icon
  static const IconData save = Icons.save_outlined;

  /// Cancel icon
  static const IconData cancel = Icons.cancel_outlined;

  /// Search icon
  static const IconData search = Icons.search_outlined;

  /// Filter icon
  static const IconData filter = Icons.filter_list_outlined;

  // Status Icons
  /// Normal status icon
  static const IconData normal = Icons.check_circle_outline;

  /// Caution status icon
  static const IconData caution = Icons.warning_amber_outlined;

  /// Danger status icon
  static const IconData danger = Icons.error_outline;

  /// Unknown status icon
  static const IconData unknown = Icons.help_outline;

  /// Pending status icon
  static const IconData pending = Icons.schedule_outlined;

  /// Completed status icon
  static const IconData completed = Icons.check_circle_outline;

  // Accessibility Icons
  /// Accessibility icon
  static const IconData accessibility = Icons.accessibility_outlined;

  /// Voice icon
  static const IconData voice = Icons.mic_outlined;

  /// Text size icon
  static const IconData textSize = Icons.text_fields_outlined;

  /// High contrast icon
  static const IconData highContrast = Icons.contrast_outlined;

  // Device and Sync Icons
  /// Phone icon
  static const IconData phone = Icons.phone_outlined;

  /// Watch icon
  static const IconData watch = Icons.watch_outlined;

  /// Bluetooth icon
  static const IconData bluetooth = Icons.bluetooth_outlined;

  /// WiFi icon
  static const IconData wifi = Icons.wifi_outlined;

  /// Cloud icon
  static const IconData cloud = Icons.cloud_outlined;

  /// Offline icon
  static const IconData offline = Icons.cloud_off_outlined;

  // Helper Methods

  /// Get icon for vital sign type
  static IconData getVitalSignIcon(String vitalSignType) {
    switch (vitalSignType.toLowerCase()) {
      case 'heart_rate':
      case 'heartrate':
        return heartRate;
      case 'blood_pressure':
      case 'bloodpressure':
        return bloodPressure;
      case 'temperature':
        return temperature;
      case 'oxygen_saturation':
      case 'oxygensaturation':
      case 'spo2':
        return oxygenSaturation;
      case 'respiratory_rate':
      case 'respiratoryrate':
        return respiratoryRate;
      case 'blood_glucose':
      case 'bloodglucose':
        return bloodGlucose;
      case 'weight':
        return weight;
      case 'steps':
        return steps;
      case 'sleep':
        return sleep;
      default:
        return healthMetrics;
    }
  }

  /// Get icon for medical status
  static IconData getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'normal':
      case 'good':
      case 'healthy':
        return normal;
      case 'caution':
      case 'warning':
      case 'borderline':
        return caution;
      case 'danger':
      case 'critical':
      case 'emergency':
        return danger;
      case 'unknown':
      case 'missing':
      case 'unavailable':
        return unknown;
      case 'pending':
        return pending;
      case 'completed':
        return completed;
      default:
        return unknown;
    }
  }

  /// Get icon for medication type
  static IconData getMedicationIcon(String medicationType) {
    switch (medicationType.toLowerCase()) {
      case 'prescription':
      case 'rx':
        return prescription;
      case 'pill':
      case 'tablet':
      case 'capsule':
        return pill;
      case 'injection':
      case 'syringe':
      case 'vaccine':
        return injection;
      case 'liquid':
      case 'syrup':
        return Icons.medication_liquid_outlined;
      default:
        return medication;
    }
  }

  /// Get icon for trend direction
  static IconData getTrendIcon(double trendValue) {
    if (trendValue > 0.05) {
      return trendUp;
    } else if (trendValue < -0.05) {
      return trendDown;
    } else {
      return trendFlat;
    }
  }

  /// Get icon for emergency level
  static IconData getEmergencyIcon(String emergencyLevel) {
    switch (emergencyLevel.toLowerCase()) {
      case 'critical':
      case 'emergency':
        return emergency;
      case 'urgent':
        return criticalAlert;
      case 'warning':
        return warning;
      case 'info':
        return info;
      default:
        return info;
    }
  }
}
