import 'package:flutter/widgets.dart';
import '../thai_id_card_numbers.dart';

/// Ready-to-use [FormFieldValidator]s for Thai ID Card input fields.
class ThaiIdValidator {
  /// Validates that the input is a valid Thai ID Card Number.
  ///
  /// [errorText]: The error message to display if invalid. Default is 'Invalid Thai ID Card Number'.
  /// [allowEmpty]: If true, empty input is considered valid (useful for optional fields). Default is false.
  static FormFieldValidator<String> validate({
    String errorText = 'Invalid Thai ID Card Number',
    bool allowEmpty = false,
  }) {
    return (String? value) {
      if (value == null || value.isEmpty) {
        return allowEmpty ? null : errorText;
      }
      // Normalize and validate
      final isValid = ThaiIdCardNumbers().validateFormatted(value);
      return isValid ? null : errorText;
    };
  }

  /// Helper to check if a single string is valid (proxy to main class).
  static bool isStrictValid(String value) {
    final isValid = ThaiIdCardNumbers().validateFormatted(value);
    if (!isValid) return false;
    // Add strict checks here if desired, e.g. first digit != 9
    // For now, relies on checksum validity.
    return true;
  }
}
