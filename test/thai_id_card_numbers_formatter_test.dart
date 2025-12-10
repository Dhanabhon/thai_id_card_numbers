import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:thai_id_card_numbers/thai_id_card_numbers_formatter.dart';

void main() {
  group('ThaiIdCardNumbersFormatter', () {
    const pattern = 'x-xxxx-xxxxx-xx-x';
    const delimiter = '-';
    final formatter =
        ThaiIdCardNumbersFormatter(pattern: pattern, delimiter: delimiter);

    TextEditingValue tev(String text, [int? offset]) => TextEditingValue(
          text: text,
          selection: TextSelection.collapsed(offset: offset ?? text.length),
        );

    test('inserts delimiter when typing past boundary', () {
      final oldValue = tev('1');
      final newValue = tev('12');
      final out = formatter.formatEditUpdate(oldValue, newValue);
      expect(out.text, '1-2');
      expect(out.selection.baseOffset, 3);
    });

    test('passes through normal character additions', () {
      final oldValue = tev('1-2');
      final newValue = tev('1-23');
      final out = formatter.formatEditUpdate(oldValue, newValue);
      expect(out.text, '1-23');
    });

    test('allows deletions unchanged', () {
      final oldValue = tev('1-23');
      final newValue = tev('1-2');
      final out = formatter.formatEditUpdate(oldValue, newValue);
      expect(out.text, '1-2');
    });

    test('prevents overflow beyond pattern length', () {
      const full = '1-2345-67890-12-4';
      final oldValue = tev(full);
      final newValue = tev('$full' '0');
      final out = formatter.formatEditUpdate(oldValue, newValue);
      expect(out.text, full);
    });

    // Smart Cursor tests

    test('Cursor stays after inserted char when formatting kicks in', () {
      // Old: '1' (cursor 1)
      // New: '12' (cursor 2) -> '1-2' (cursor 3)
      final res = formatter.formatEditUpdate(tev('1', 1), tev('12', 2));
      expect(res.text, '1-2');
      expect(res.selection.baseOffset, 3);
    });

    test('Cursor works when inserting in middle', () {
      // Old: '1-234' (cursor 2, after 1)
      // Type '9': New '19-234' (cursor 2) -> digits '19234'
      // Formatted: '1-9234'

      final res = formatter.formatEditUpdate(tev('1-234', 2), tev('1-9234', 3));

      expect(res.text, '1-9234');
      expect(res.selection.baseOffset, 3);
    });

    test('Cursor works when deleting dash', () {
      // Deleting dash generally causes cursor to jump back.
      // Current implementation heuristic handles it reasonably.
      final res = formatter.formatEditUpdate(tev('1-23', 2), tev('123', 1));
      expect(res.text, '1-23');
      expect(res.selection.baseOffset, 2);
    });
  });
}
