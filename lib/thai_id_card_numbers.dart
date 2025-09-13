import 'dart:math';

class ThaiIdCardNumbers {
  // 13 digits only
  static final RegExp _thaiId13Digits = RegExp(r'^\d{13}$');

  /// Normalize a string by removing all non-digit characters.
  String normalize(String input) => input.replaceAll(RegExp(r'\D'), '');

  /// Compute the checksum digit (0-9) for the first 12 digits.
  /// Throws [ArgumentError] if [first12] is not exactly 12 digits.
  int checksum(String first12) {
    final raw = normalize(first12);
    if (raw.length != 12) {
      throw ArgumentError('checksum requires exactly 12 digits');
    }
    var sum = 0;
    for (var i = 0; i < 12; i++) {
      sum += int.parse(raw[i]) * (13 - i);
    }
    return (11 - (sum % 11)) % 10;
  }

  /// Validate a 13-digit Thai ID (digits only).
  bool validate(String strNumbers) {
    final s = strNumbers.trim();
    if (!_thaiId13Digits.hasMatch(s)) return false;
    final expected = checksum(s.substring(0, 12));
    return expected == int.parse(s[12]);
  }

  /// Validate a formatted Thai ID. Accepts any delimiters; digits are normalized.
  bool validateFormatted(String input) => validate(normalize(input));

  /// Generate 13 random digits (not guaranteed valid).
  String random() {
    final rand = Random();
    final buf = StringBuffer();
    for (var i = 0; i < 13; i++) {
      buf.write(rand.nextInt(10));
    }
    return buf.toString();
  }

  /// Generate a valid Thai ID.
  ///
  /// - [firstDigit]: optionally constrain the first digit (0-9).
  /// - [formatted]: if true, returns using [pattern]/[delimiter].
  String generate(
      {int? firstDigit,
      bool formatted = false,
      String pattern = 'x-xxxx-xxxxx-xx-x',
      String delimiter = '-'}) {
    final rand = Random();
    final digits = List<int>.filled(13, 0);
    for (var i = 0; i < 12; i++) {
      digits[i] = rand.nextInt(10);
    }
    if (firstDigit != null) {
      if (firstDigit < 0 || firstDigit > 9) {
        throw ArgumentError('firstDigit must be 0-9');
      }
      digits[0] = firstDigit;
    }
    // compute checksum
    final first12 = digits.take(12).join();
    digits[12] = checksum(first12);
    final raw = digits.join();
    if (!formatted) return raw;
    return format(raw, pattern: pattern, delimiter: delimiter);
  }

  /// Format a digits-only [number] according to [pattern] and [delimiter].
  /// Pattern placeholders should be 'x' characters.
  String format(String number,
      {String pattern = 'x-xxxx-xxxxx-xx-x', String delimiter = '-'}) {
    var out = StringBuffer();
    var idx = 0;
    for (var i = 0; i < pattern.length && idx < number.length; i++) {
      final ch = pattern[i];
      if (ch == delimiter) {
        out.write(delimiter);
      } else {
        out.write(number[idx]);
        idx++;
      }
    }
    return out.toString();
  }

  /// Strict formatter that validates input length against the pattern.
  /// Throws [ArgumentError] if [number] length does not match pattern slots.
  String formatStrict(String number,
      {String pattern = 'x-xxxx-xxxxx-xx-x', String delimiter = '-'}) {
    final slots = pattern.split('').where((c) => c != delimiter).length;
    if (number.length != slots || !RegExp(r'^\d+$').hasMatch(number)) {
      throw ArgumentError('number must be $slots digits for the given pattern');
    }
    return format(number, pattern: pattern, delimiter: delimiter);
  }
}
