import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:thai_id_card_numbers/thai_id_card_numbers.dart';

void main() {
  group('ThaiIdCardNumbers', () {
    final subject = ThaiIdCardNumbers();

    test('validate returns true for a known valid ID', () {
      // 12-digit base: 123456789012 -> checksum computed as 1
      const valid = '1234567890121';
      expect(subject.validate(valid), isTrue);
    });

    test('validate returns false for invalid cases', () {
      expect(subject.validate(''), isFalse); // empty
      expect(subject.validate('123'), isFalse); // too short
      expect(subject.validate('12345678901234'), isFalse); // too long
      expect(subject.validate('1234567890123'), isFalse); // bad checksum
      expect(subject.validate('12345678901a4'), isFalse); // non-numeric
    });

    test('format applies default pattern correctly', () {
      const input = '1234567890121';
      final formatted = subject.format(input);
      expect(formatted, equals('1-2345-67890-12-1'));
    });

    test('format supports custom delimiter and pattern', () {
      const input = '1234567890121';
      final formatted = subject.format(
        input,
        pattern: 'x.xxxx.xxxxx.xx.x',
        delimiter: '.',
      );
      expect(formatted, equals('1.2345.67890.12.1'));
    });

    test('random returns 13 numeric characters', () {
      final r = subject.random();
      expect(r.length, 13);
      expect(RegExp(r'^\d{13}$').hasMatch(r), isTrue);
    });

    test('generate returns valid 13-digit ID', () {
      final g = subject.generate();
      expect(g.length, 13);
      expect(RegExp(r'^\d{13}$').hasMatch(g), isTrue);
      expect(subject.validate(g), isTrue);
    });
  });
}
