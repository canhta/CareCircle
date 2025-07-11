import 'package:flutter/material.dart';
import '../../../core/design/design_tokens.dart';
import '../../../core/design/care_circle_icons.dart';
import '../../../core/widgets/care_circle_button.dart';
import '../../../core/widgets/healthcare/healthcare_action_card.dart';
import '../../../core/widgets/layout/care_circle_responsive_grid.dart';
import '../../../core/widgets/navigation/care_circle_tab_bar.dart';

/// Modern UI Showcase Screen
///
/// Demonstrates the modernized CareCircle UI components with gradients,
/// glassmorphism, and modern visual effects while maintaining healthcare compliance.
class ModernUIShowcaseScreen extends StatelessWidget {
  const ModernUIShowcaseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Modern UI Showcase'),
        backgroundColor: CareCircleColorTokens.primaryMedicalBlue,
        foregroundColor: Colors.white,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: CareCircleGradientTokens.primaryMedical,
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: CareCircleGradientTokens.softBackground,
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(CareCircleSpacingTokens.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionHeader('Modern Buttons'),
              SizedBox(height: CareCircleSpacingTokens.sm),
              _buildModernButtons(),
              SizedBox(height: CareCircleSpacingTokens.lg),
              
              _buildSectionHeader('AI Assistant Features'),
              SizedBox(height: CareCircleSpacingTokens.sm),
              _buildAIFeatures(),
              SizedBox(height: CareCircleSpacingTokens.lg),
              
              _buildSectionHeader('Healthcare Action Cards'),
              SizedBox(height: CareCircleSpacingTokens.sm),
              _buildHealthcareCards(),
              SizedBox(height: CareCircleSpacingTokens.lg),
              
              _buildSectionHeader('Glassmorphism Effects'),
              SizedBox(height: CareCircleSpacingTokens.sm),
              _buildGlassmorphismDemo(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: CareCircleSpacingTokens.md,
        vertical: CareCircleSpacingTokens.sm,
      ),
      decoration: CareCircleGlassmorphismTokens.lightCardGlass(
        borderRadius: CareCircleModernEffectsTokens.radiusSM,
      ),
      child: Text(
        title,
        style: CareCircleTypographyTokens.healthMetricTitle.copyWith(
          color: CareCircleColorTokens.primaryMedicalBlue,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildModernButtons() {
    return Column(
      children: [
        // Primary gradient button
        CareCircleButton(
          onPressed: () {},
          text: 'Primary Gradient',
          variant: CareCircleButtonVariant.primaryGradient,
          icon: Icons.medical_services,
        ),
        SizedBox(height: CareCircleSpacingTokens.sm),
        
        // AI Assistant button
        CareCircleButton(
          onPressed: () {},
          text: 'AI Health Assistant',
          variant: CareCircleButtonVariant.aiGradient,
          icon: Icons.psychology,
        ),
        SizedBox(height: CareCircleSpacingTokens.sm),
        
        // Emergency gradient button
        CareCircleButton(
          onPressed: () {},
          text: 'Emergency Alert',
          variant: CareCircleButtonVariant.emergencyGradient,
          icon: Icons.emergency,
          isUrgent: true,
        ),
        SizedBox(height: CareCircleSpacingTokens.sm),
        
        // Health gradient button
        CareCircleButton(
          onPressed: () {},
          text: 'Health Metrics',
          variant: CareCircleButtonVariant.healthGradient,
          icon: Icons.favorite,
        ),
        SizedBox(height: CareCircleSpacingTokens.sm),
        
        // Glassmorphism button
        CareCircleButton(
          onPressed: () {},
          text: 'Glassmorphism Style',
          variant: CareCircleButtonVariant.glassmorphism,
          icon: Icons.blur_on,
        ),
      ],
    );
  }

  Widget _buildAIFeatures() {
    return Column(
      children: [
        // AI Chat Interface Preview
        Container(
          padding: EdgeInsets.all(CareCircleSpacingTokens.md),
          decoration: BoxDecoration(
            gradient: CareCircleGradientTokens.aiChat,
            borderRadius: CareCircleModernEffectsTokens.radiusLG,
            boxShadow: CareCircleModernEffectsTokens.aiShadow,
            border: Border.all(
              color: const Color(0x337C4DFF),
              width: 1.5,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(CareCircleSpacingTokens.sm),
                    decoration: BoxDecoration(
                      gradient: CareCircleGradientTokens.aiAssistant,
                      borderRadius: CareCircleModernEffectsTokens.radiusSM,
                    ),
                    child: const Icon(
                      Icons.psychology,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  SizedBox(width: CareCircleSpacingTokens.sm),
                  Text(
                    'AI Health Assistant',
                    style: CareCircleTypographyTokens.healthMetricTitle.copyWith(
                      fontWeight: FontWeight.w600,
                      color: CareCircleColorTokens.primaryMedicalBlue,
                    ),
                  ),
                ],
              ),
              SizedBox(height: CareCircleSpacingTokens.sm),
              Text(
                'Experience personalized healthcare guidance with our AI-powered assistant. Get instant answers to your health questions.',
                style: CareCircleTypographyTokens.medicalNote.copyWith(
                  color: CareCircleColorTokens.primaryMedicalBlue.withValues(alpha: 0.8),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: CareCircleSpacingTokens.md),
        
        // AI Processing Indicator
        Container(
          padding: EdgeInsets.all(CareCircleSpacingTokens.md),
          decoration: CareCircleGlassmorphismTokens.aiGlass(),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  gradient: CareCircleGradientTokens.aiProcessing,
                  borderRadius: CareCircleModernEffectsTokens.radiusPill,
                ),
                child: const Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
              ),
              SizedBox(width: CareCircleSpacingTokens.md),
              Expanded(
                child: Text(
                  'AI is analyzing your health data...',
                  style: CareCircleTypographyTokens.medicalNote.copyWith(
                    color: const Color(0xFF7C4DFF),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHealthcareCards() {
    return CareCircleResponsiveGrid(
      mobileColumns: 2,
      tabletColumns: 3,
      desktopColumns: 4,
      semanticLabel: 'Modern healthcare action cards',
      children: [
        HealthcareActionCard(
          icon: CareCircleIcons.aiAssistant,
          title: 'AI Health Insights',
          subtitle: 'Personalized recommendations',
          color: const Color(0xFF7C4DFF),
          onTap: () {},
          urgencyLevel: UrgencyLevel.medium,
        ),
        HealthcareActionCard(
          icon: CareCircleIcons.healthMetrics,
          title: 'Vital Signs',
          subtitle: 'Real-time monitoring',
          color: CareCircleColorTokens.heartRateRed,
          onTap: () {},
          urgencyLevel: UrgencyLevel.high,
          showProgress: true,
          progressValue: 0.75,
        ),
        HealthcareActionCard(
          icon: CareCircleIcons.medication,
          title: 'Medications',
          subtitle: 'Smart reminders',
          color: CareCircleColorTokens.prescriptionBlue,
          onTap: () {},
          badge: '3',
        ),
        HealthcareActionCard(
          icon: Icons.emergency,
          title: 'Emergency',
          subtitle: 'Quick access',
          color: CareCircleColorTokens.emergencyRed,
          onTap: () {},
          urgencyLevel: UrgencyLevel.critical,
        ),
      ],
    );
  }

  Widget _buildGlassmorphismDemo() {
    return Column(
      children: [
        // Medical glassmorphism card
        CareCircleGlassmorphismTokens.createGlassContainer(
          decoration: CareCircleGlassmorphismTokens.medicalCardGlass(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Medical Data Overview',
                style: CareCircleTypographyTokens.healthMetricTitle.copyWith(
                  color: CareCircleColorTokens.primaryMedicalBlue,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: CareCircleSpacingTokens.sm),
              Text(
                'Glassmorphism provides a modern, professional appearance while maintaining excellent readability for medical data.',
                style: CareCircleTypographyTokens.medicalNote.copyWith(
                  color: CareCircleColorTokens.primaryMedicalBlue.withValues(alpha: 0.8),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: CareCircleSpacingTokens.md),
        
        // Emergency glassmorphism card
        CareCircleGlassmorphismTokens.createGlassContainer(
          decoration: CareCircleGlassmorphismTokens.emergencyGlass(),
          child: Row(
            children: [
              Icon(
                Icons.warning,
                color: CareCircleColorTokens.criticalAlert,
                size: 32,
              ),
              SizedBox(width: CareCircleSpacingTokens.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Critical Alert',
                      style: CareCircleTypographyTokens.emergencyButton.copyWith(
                        color: CareCircleColorTokens.criticalAlert,
                      ),
                    ),
                    Text(
                      'Emergency glassmorphism for urgent notifications',
                      style: CareCircleTypographyTokens.medicalNote.copyWith(
                        color: CareCircleColorTokens.criticalAlert.withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
