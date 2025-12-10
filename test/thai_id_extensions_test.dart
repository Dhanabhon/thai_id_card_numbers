import 'package:flutter_test/flutter_test.dart';
import 'package:thai_id_card_numbers/src/thai_id_extensions.dart';

void main() {
  group('String Extensions', () {
    test('isValidThaiId returns proper boolean', () {
      expect('1234567890121'.isValidThaiId, isTrue); // Correct checksum
      expect('1234567890123'.isValidThaiId, isFalse); // Incorrect
    });

    test('formatAsThaiId formats correctly', () {
      expect('1234567890121'.formatAsThaiId(), '1-2345-67890-12-1');
      expect('invalid'.formatAsThaiId(), 'invalid');
    });

    test('thaiIdInfo extracts data', () {
      final info = '1234567890121'.thaiIdInfo;
      expect(info, isNotNull);
      expect(info!.type, '1');
      expect(info.officeCode, '2345');
    });
  });
}
