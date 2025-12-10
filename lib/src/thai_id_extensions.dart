import '../thai_id_card_numbers.dart';
import 'thai_id_info.dart';

/// Extension methods for [String] to easily validate and format Thai ID card numbers.
extension ThaiIdStringExtension on String {
  /// Check if the string is a valid Thai ID card number.
  bool get isValidThaiId => ThaiIdCardNumbers().validate(this);

  /// Check if the string is a valid Thai ID card number (formatted).
  bool get isValidThaiIdFormatted =>
      ThaiIdCardNumbers().validateFormatted(this);

  /// Format the string as a Thai ID card number.
  /// Returns the original string if it cannot be formatted (e.g. not enough digits).
  String formatAsThaiId(
      {String pattern = '1-2345-67890-12-3', String delimiter = '-'}) {
    try {
      final digits = ThaiIdCardNumbers().normalize(this);
      if (digits.isEmpty) return this;
      return ThaiIdCardNumbers()
          .format(digits, pattern: pattern, delimiter: delimiter);
    } catch (_) {
      return this;
    }
  }

  /// Parse the Thai ID card number to extract information.
  /// Returns null if the ID is invalid (length check).
  ThaiIdInfo? get thaiIdInfo {
    try {
      return ThaiIdInfo.parse(this);
    } catch (_) {
      return null;
    }
  }
}
