/// Extension methods for String class
extension StringExtensions on String {
  /// Check if string is null or empty
  bool get isNullOrEmpty => isEmpty;

  /// Check if string is null, empty, or whitespace
  bool get isNullOrWhitespace => trim().isEmpty;

  /// Capitalize first letter
  String get capitalize {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
  }

  /// Capitalize each word
  String get capitalizeWords {
    if (isEmpty) return this;
    return split(' ').map((word) => word.capitalize).join(' ');
  }

  /// Convert to camelCase
  String get camelCase {
    if (isEmpty) return this;
    final words = split(RegExp(r'[_\s]+'));
    if (words.isEmpty) return this;

    final firstWord = words.first.toLowerCase();
    final restWords = words.skip(1).map((word) => word.capitalize);

    return firstWord + restWords.join('');
  }

  /// Convert to snake_case
  String get snakeCase {
    return replaceAllMapped(
      RegExp(r'[A-Z]'),
      (match) => '_${match.group(0)!.toLowerCase()}',
    );
  }

  /// Convert to kebab-case
  String get kebabCase {
    return replaceAllMapped(
      RegExp(r'[A-Z]'),
      (match) => '-${match.group(0)!.toLowerCase()}',
    );
  }

  /// Remove HTML tags
  String get stripHtml {
    final exp = RegExp(r'<[^>]*>', multiLine: true, caseSensitive: false);
    return replaceAll(exp, '');
  }

  /// Truncate string with ellipsis
  String truncate(int maxLength, {String ellipsis = '...'}) {
    if (length <= maxLength) return this;
    return '${substring(0, maxLength - ellipsis.length)}$ellipsis';
  }

  /// Check if string is a valid email
  bool get isValidEmail {
    final emailRegex =
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return emailRegex.hasMatch(this);
  }

  /// Check if string is a valid phone number
  bool get isValidPhoneNumber {
    final phoneRegex = RegExp(r'^\+?[\d\s\-\(\)]{10,}$');
    return phoneRegex.hasMatch(this);
  }

  /// Check if string is a valid URL
  bool get isValidUrl {
    final urlRegex = RegExp(
      r'^(https?|ftp)://[^\s/$.?#].[^\s]*$',
      caseSensitive: false,
    );
    return urlRegex.hasMatch(this);
  }

  /// Check if string contains only digits
  bool get isNumeric {
    return RegExp(r'^[0-9]+$').hasMatch(this);
  }

  /// Check if string contains only alphabetic characters
  bool get isAlphabetic {
    return RegExp(r'^[a-zA-Z]+$').hasMatch(this);
  }

  /// Check if string contains only alphanumeric characters
  bool get isAlphanumeric {
    return RegExp(r'^[a-zA-Z0-9]+$').hasMatch(this);
  }

  /// Convert string to integer
  int? get toInt {
    return int.tryParse(this);
  }

  /// Convert string to double
  double? get toDouble {
    return double.tryParse(this);
  }

  /// Convert string to DateTime
  DateTime? get toDateTime {
    return DateTime.tryParse(this);
  }

  /// Reverse string
  String get reverse {
    return split('').reversed.join('');
  }

  /// Count occurrences of substring
  int countOccurrences(String substring) {
    return split(substring).length - 1;
  }

  /// Replace multiple substrings
  String replaceMultiple(Map<String, String> replacements) {
    String result = this;
    replacements.forEach((key, value) {
      result = result.replaceAll(key, value);
    });
    return result;
  }

  /// Extract numbers from string
  List<int> get extractNumbers {
    final regex = RegExp(r'\d+');
    return regex
        .allMatches(this)
        .map((match) => int.parse(match.group(0)!))
        .toList();
  }

  /// Remove extra whitespace
  String get removeExtraWhitespace {
    return replaceAll(RegExp(r'\s+'), ' ').trim();
  }

  /// Check if string is palindrome
  bool get isPalindrome {
    final normalized = toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '');
    return normalized == normalized.split('').reversed.join('');
  }

  /// Generate initials from name
  String get initials {
    return split(' ')
        .where((word) => word.isNotEmpty)
        .map((word) => word[0].toUpperCase())
        .join('');
  }

  /// Mask sensitive information
  String maskSensitive(
      {int visibleStart = 2, int visibleEnd = 2, String maskChar = '*'}) {
    if (length <= visibleStart + visibleEnd) return this;

    final start = substring(0, visibleStart);
    final end = substring(length - visibleEnd);
    final masked = maskChar * (length - visibleStart - visibleEnd);

    return start + masked + end;
  }
}
