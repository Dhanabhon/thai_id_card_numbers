import 'package:flutter/services.dart';

/*
*  Formats digits according to a pattern and delimiter while typing.
*  - Accepts paste input (strips non-digits) and rebuilds the text.
*  - Prevents overflow beyond pattern length.
*/
class ThaiIdCardNumbersFormatter extends TextInputFormatter {
  final String pattern;
  final String delimiter;

  ThaiIdCardNumbersFormatter({
    required this.pattern,
    required this.delimiter,
  });

  String _digitsOnly(String s) => s.replaceAll(RegExp(r'\D'), '');

  String _applyPattern(String digits) {
    final buf = StringBuffer();
    var iDigit = 0;
    for (var i = 0; i < pattern.length && iDigit < digits.length; i++) {
      final ch = pattern[i];
      if (ch == delimiter) {
        // Only add delimiter if there are still digits to place.
        if (iDigit < digits.length) {
          buf.write(delimiter);
        }
      } else {
        buf.write(digits[iDigit]);
        iDigit++;
      }
    }
    return buf.toString();
  }

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // Normalize to digits and re-apply pattern. This allows paste and filters noise.
    final raw = _digitsOnly(newValue.text);
    if (raw.isEmpty) {
      return const TextEditingValue(text: '', selection: TextSelection.collapsed(offset: 0));
    }

    final formatted = _applyPattern(raw);
    // Prevent overflow beyond pattern length implicitly by truncation in _applyPattern.
    final selectionIndex = formatted.length > pattern.length
        ? pattern.length
        : formatted.length;
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }
}
