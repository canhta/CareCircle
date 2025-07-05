import 'package:flutter/services.dart' show rootBundle;
import '../common/logging/app_logger.dart';

/// Utility class for loading and accessing markdown content from assets
class MarkdownLoader {
  static final AppLogger _logger = AppLogger('MarkdownLoader');

  /// Load markdown content from asset file
  static Future<String> loadMarkdownAsset(String assetPath) async {
    try {
      return await rootBundle.loadString(assetPath);
    } catch (e) {
      _logger.error('Error loading markdown asset', error: e);
      return 'Failed to load content. Please try again later.';
    }
  }

  /// Get path to privacy policy markdown
  static String get privacyPolicyPath => 'lib/assets/privacy_policy.md';

  /// Get path to terms of service markdown
  static String get termsOfServicePath => 'lib/assets/terms_of_service.md';

  /// Load privacy policy markdown
  static Future<String> getPrivacyPolicy() async {
    return await loadMarkdownAsset(privacyPolicyPath);
  }

  /// Load terms of service markdown
  static Future<String> getTermsOfService() async {
    return await loadMarkdownAsset(termsOfServicePath);
  }
}
