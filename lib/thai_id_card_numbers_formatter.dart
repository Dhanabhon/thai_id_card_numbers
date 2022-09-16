import 'package:flutter/services.dart';

/*
*  Ref: https://appvesto.medium.com/flutter-formatting-textfield-with-textinputformatter-c73ee2167514
*/
class ThaiIdCardNumbersFormatter extends TextInputFormatter {
  final String pattern;
  final String delimiter;

  ThaiIdCardNumbersFormatter({
    required this.pattern,
    required this.delimiter,
  });

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isNotEmpty) {
      if (newValue.text.length > oldValue.text.length) {
        if (newValue.text.length > pattern.length) {
          return oldValue;
        }
        if (newValue.text.length < pattern.length && pattern[newValue.text.length - 1] == delimiter) {
          return TextEditingValue(
            text: '${oldValue.text}$delimiter${newValue.text.substring(newValue.text.length - 1)}',
            selection: TextSelection.collapsed(offset: newValue.selection.end + 1),
          );
        }
      }
    }
    return newValue;
  }
}