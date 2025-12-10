import 'package:flutter/services.dart';

/*
*  Formats digits according to a pattern and delimiter while typing.
*  - Accepts paste input (strips non-digits) and rebuilds the text.
*  - Prevents overflow beyond pattern length.
*  - Smarter cursor positioning: maintains cursor implementation relative to the digits.
*/
class ThaiIdCardNumbersFormatter extends TextInputFormatter {
  final String pattern;
  final String delimiter;

  ThaiIdCardNumbersFormatter({
    this.pattern = 'x-xxxx-xxxxx-xx-x',
    this.delimiter = '-',
  });

  String _digitsOnly(String s) => s.replaceAll(RegExp(r'\D'), '');

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // If the text is empty, just return empty
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    }

    // 1. Get the pure digits from the new value
    final newText = newValue.text;
    final newDigits = _digitsOnly(newText);

    // Calculate how many digits allowed by pattern
    final patternDigitCount =
        pattern.replaceAll(RegExp('[^x]'), '').length; // usually 13

    // If we have more digits than allowed, truncate
    final String digits = newDigits.length > patternDigitCount
        ? newDigits.substring(0, patternDigitCount)
        : newDigits;

    // 2. Format the string according to pattern
    final buffer = StringBuffer();
    int digitIndex = 0;

    for (int i = 0; i < pattern.length; i++) {
      // Stop if we ran out of digits
      if (digitIndex >= digits.length) break;

      final patternChar = pattern[i];
      if (patternChar == delimiter) {
        buffer.write(delimiter);
      } else {
        buffer.write(digits[digitIndex]);
        digitIndex++;
      }
    }

    final formattedText = buffer.toString();

    // 3. Calculate new selection (cursor options)
    // We want to map the cursor position from the 'raw input' to the 'formatted output'.
    // A simple heuristic: count how many digits were before the cursor in the new input,
    // and find where that digit lands in the formatted output.

    int initialCursor = newValue.selection.baseOffset;

    // Count digits before cursor in the *newly typed* text
    // Handle edge case where cursor is -1
    if (initialCursor < 0) initialCursor = 0;

    int digitsBeforeCursor = 0;
    for (int i = 0; i < initialCursor && i < newText.length; i++) {
      if (RegExp(r'\d').hasMatch(newText[i])) {
        digitsBeforeCursor++;
      }
    }

    // Now find the position in formatted text that is after 'digitsBeforeCursor' digits
    int newCursorIndex = 0;
    int digitsEncountered = 0;

    for (int i = 0; i < formattedText.length; i++) {
      if (digitsEncountered >= digitsBeforeCursor) {
        break;
      }
      if (RegExp(r'\d').hasMatch(formattedText[i])) {
        digitsEncountered++;
      }
      newCursorIndex++;
    }

    // Correction: If the next char is a delimiter, move cursor past it
    // so the user doesn't get stuck before a dash
    if (newCursorIndex < formattedText.length &&
        formattedText[newCursorIndex] == delimiter) {
      newCursorIndex += 1;
    }

    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: newCursorIndex),
    );
  }
}
