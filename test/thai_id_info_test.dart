import 'package:flutter_test/flutter_test.dart';
import 'package:thai_id_card_numbers/thai_id_card_numbers.dart';

void main() {
  group('ThaiIdInfo', () {
    test('Correctly parses fields', () {
      // 1-2345-67890-12-1
      final info = ThaiIdInfo.parse('1234567890121');
      expect(info.type, '1');
      expect(info.typeDescription, contains('Thai national'));
      expect(info.officeCode, '2345');
      expect(info.group, '67890');
      expect(info.seq, '12');
      expect(info.checkDigit, '1');
    });

    test('Throws on invalid length', () {
      expect(() => ThaiIdInfo.parse('123'), throwsArgumentError);
    });
  });
}
