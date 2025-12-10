import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:thai_id_card_numbers/thai_id_card_numbers.dart';

void main() {
  group('ThaiIdValidator', () {
    test('Validates form fields', () {
      final validator = ThaiIdValidator.validate(allowEmpty: true);
      expect(validator(null), isNull);
      expect(validator(''), isNull);
      expect(validator('1234567890121'), isNull);
      expect(validator('123'), isNotNull);
    });
  });
}
