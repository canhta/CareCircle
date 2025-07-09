import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../config/app_config.dart';
import '../design/design_tokens.dart';
import '../logging/logging.dart';
import '../logging/error_tracker.dart';
import '../logging/performance_monitor.dart';
import '../network/performance_dio_interceptor.dart';

/// Development debugging screen for CareCircle mobile app
///
/// This screen provides comprehensive debugging tools for developers,
/// including log viewing, performance monitoring, and error tracking.
class DebugScreen extends StatefulWidget {
  const DebugScreen({super.key});

  @override
  State<DebugScreen> createState() => _DebugScreenState();
}

class _DebugScreenState extends State<DebugScreen> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Only show in debug mode
    if (!kDebugMode) {
      return Scaffold(
        appBar: AppBar(title: const Text('Debug Tools')),
        body: const Center(child: Text('Debug tools are only available in debug mode', style: TextStyle(fontSize: 16))),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('CareCircle Debug Tools'),
        backgroundColor: CareCircleDesignTokens.primaryMedicalBlue,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          isScrollable: true,
          tabs: const [
            Tab(text: 'Logs', icon: Icon(Icons.list_alt)),
            Tab(text: 'Performance', icon: Icon(Icons.speed)),
            Tab(text: 'Errors', icon: Icon(Icons.error_outline)),
            Tab(text: 'System', icon: Icon(Icons.info_outline)),
            Tab(text: 'Tools', icon: Icon(Icons.build)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [_buildLogsTab(), _buildPerformanceTab(), _buildErrorsTab(), _buildSystemTab(), _buildToolsTab()],
      ),
    );
  }

  /// Build logs tab with Talker integration
  Widget _buildLogsTab() {
    return TalkerScreen(
      talker: AppLogger.instance,
      theme: TalkerScreenTheme(
        backgroundColor: Colors.white,
        textColor: Colors.black87,
        logColors: {
          TalkerLogType.error.key: CareCircleDesignTokens.criticalAlert,
          TalkerLogType.warning.key: Colors.orange,
          TalkerLogType.info.key: CareCircleDesignTokens.primaryMedicalBlue,
          TalkerLogType.debug.key: Colors.grey[600]!,
          TalkerLogType.verbose.key: Colors.grey[400]!,
        },
      ),
    );
  }

  /// Build performance monitoring tab
  Widget _buildPerformanceTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Performance Overview'),
          _buildPerformanceOverview(),
          const SizedBox(height: 24),
          _buildSectionHeader('Healthcare API Performance'),
          _buildHealthcareApiPerformance(),
          const SizedBox(height: 24),
          _buildSectionHeader('Performance Actions'),
          _buildPerformanceActions(),
        ],
      ),
    );
  }

  /// Build errors tab
  Widget _buildErrorsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Error Tracking Status'),
          _buildErrorTrackingStatus(),
          const SizedBox(height: 24),
          _buildSectionHeader('Error Actions'),
          _buildErrorActions(),
          const SizedBox(height: 24),
          _buildSectionHeader('Recent Errors'),
          _buildRecentErrors(),
        ],
      ),
    );
  }

  /// Build system information tab
  Widget _buildSystemTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('App Configuration'),
          _buildAppConfiguration(),
          const SizedBox(height: 24),
          _buildSectionHeader('Logging Configuration'),
          _buildLoggingConfiguration(),
          const SizedBox(height: 24),
          _buildSectionHeader('Context Loggers'),
          _buildContextLoggers(),
        ],
      ),
    );
  }

  /// Build development tools tab
  Widget _buildToolsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Development Tools'),
          _buildDevelopmentTools(),
          const SizedBox(height: 24),
          _buildSectionHeader('Test Actions'),
          _buildTestActions(),
          const SizedBox(height: 24),
          _buildSectionHeader('Log Management'),
          _buildLogManagement(),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: CareCircleDesignTokens.primaryMedicalBlue,
        ),
      ),
    );
  }

  Widget _buildPerformanceOverview() {
    return FutureBuilder<Map<String, dynamic>>(
      future: Future.value(PerformanceMonitor.getAllStats()),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const CircularProgressIndicator();
        }

        final stats = snapshot.data!;
        final totalOperations = stats['totalOperations'] as int;

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Total Operations: $totalOperations'),
                const SizedBox(height: 8),
                Text('Last Updated: ${DateTime.now().toString()}'),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHealthcareApiPerformance() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton(
              onPressed: () {
                HealthcareApiPerformanceAnalyzer.analyzeHealthcareApiPerformance();
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('Healthcare API analysis completed - check logs')));
              },
              child: const Text('Analyze Healthcare APIs'),
            ),
            const SizedBox(height: 12),
            FutureBuilder<Map<String, dynamic>>(
              future: Future.value(HealthcareApiPerformanceAnalyzer.generateHealthcarePerformanceReport()),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const SizedBox();

                final report = snapshot.data!;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Status: ${report['status']}'),
                    if (report['overallAverageMs'] != null) Text('Overall Average: ${report['overallAverageMs']}ms'),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPerformanceActions() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            ElevatedButton(
              onPressed: () {
                PerformanceMonitor.startOperation('test_operation');
                Future.delayed(const Duration(milliseconds: 500), () {
                  PerformanceMonitor.endOperation('test_operation');
                });
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Test operation logged')));
              },
              child: const Text('Test Performance Logging'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorTrackingStatus() {
    final status = ErrorTracker.getStatus();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStatusRow('Initialized', status['initialized']),
            _buildStatusRow('Crashlytics Enabled', status['crashlyticsEnabled']),
            _buildStatusRow('Flutter Error Handler', status['flutterErrorHandlerActive']),
            _buildStatusRow('Platform Error Handler', status['platformErrorHandlerActive']),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusRow(String label, bool status) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(status ? Icons.check_circle : Icons.error, color: status ? Colors.green : Colors.red, size: 16),
          const SizedBox(width: 8),
          Text('$label: ${status ? 'Active' : 'Inactive'}'),
        ],
      ),
    );
  }

  Widget _buildErrorActions() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            ElevatedButton(
              onPressed: () async {
                await ErrorTracker.testCrash();
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Test crash recorded')));
                }
              },
              child: const Text('Test Crash Reporting'),
            ),
            ElevatedButton(
              onPressed: () async {
                await ErrorTracker.recordError(
                  Exception('Test error from debug screen'),
                  StackTrace.current,
                  reason: 'Debug test',
                  context: {'source': 'debug_screen'},
                );
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Test error recorded')));
                }
              },
              child: const Text('Test Error Recording'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentErrors() {
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Text('Recent errors are logged to the Logs tab and Firebase Crashlytics'),
      ),
    );
  }

  Widget _buildAppConfiguration() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('App Name: ${AppConfig.appName}'),
            Text('Environment: ${AppConfig.environment}'),
            Text('API Base URL: ${AppConfig.apiBaseUrl}'),
            Text('Logging Enabled: ${AppConfig.enableLogging}'),
            Text('Debug Mode: $kDebugMode'),
          ],
        ),
      ),
    );
  }

  Widget _buildLoggingConfiguration() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Log Level: ${LogConfig.logLevel.name}'),
            Text('File Logging: ${LogConfig.enableFileLogging}'),
            Text('Console Colors: ${LogConfig.enableConsoleColors}'),
            Text('Max History: ${LogConfig.maxHistoryItems}'),
            Text('Error Alerts: ${LogConfig.enableErrorAlerts}'),
          ],
        ),
      ),
    );
  }

  Widget _buildContextLoggers() {
    final contexts = BoundedContextLoggers.getAllContexts();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Active Context Loggers: ${contexts.length}'),
            const SizedBox(height: 8),
            ...contexts.keys.map(
              (context) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Row(
                  children: [
                    const Icon(Icons.circle, size: 8, color: Colors.green),
                    const SizedBox(width: 8),
                    Text(context),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDevelopmentTools() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Development utilities for debugging and testing'),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                Clipboard.setData(ClipboardData(text: AppLogger.getHistory().toString()));
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('Log history copied to clipboard')));
              },
              child: const Text('Copy Logs to Clipboard'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTestActions() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            ElevatedButton(
              onPressed: () {
                BoundedContextLoggers.auth.info('Test auth log from debug screen');
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Test auth log created')));
              },
              child: const Text('Test Auth Log'),
            ),
            ElevatedButton(
              onPressed: () {
                BoundedContextLoggers.healthData.info('Test health data log from debug screen');
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('Test health data log created')));
              },
              child: const Text('Test Health Data Log'),
            ),
            ElevatedButton(
              onPressed: () {
                BoundedContextLoggers.aiAssistant.info('Test AI assistant log from debug screen');
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('Test AI assistant log created')));
              },
              child: const Text('Test AI Assistant Log'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogManagement() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            ElevatedButton(
              onPressed: () {
                AppLogger.clearHistory();
                BoundedContextLoggers.clearAllHistory();
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('All logs cleared')));
              },
              child: const Text('Clear All Logs'),
            ),
            ElevatedButton(
              onPressed: () {
                final stats = PerformanceMonitor.getAllStats();
                AppLogger.info('Performance stats requested from debug screen', stats);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Performance stats logged')));
              },
              child: const Text('Log Performance Stats'),
            ),
          ],
        ),
      ),
    );
  }
}
