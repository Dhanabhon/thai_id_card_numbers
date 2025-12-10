import '../thai_id_card_numbers.dart';

/// Represents extracted information from a Thai ID card number.
class ThaiIdInfo {
  final String raw;

  ThaiIdInfo._(this.raw);

  /// Parse information from a given ID card number string.
  /// Throws [ArgumentError] if the input isn't a 13-digit number (normalized).
  factory ThaiIdInfo.parse(String input) {
    final clean = ThaiIdCardNumbers().normalize(input);
    if (clean.length != 13) {
      throw ArgumentError('Thai ID must be 13 digits.');
    }
    return ThaiIdInfo._(clean);
  }

  /// Digit 1: Category/Type of person.
  String get type => raw[0];

  /// Digits 2-5: Office code (Province + District code).
  String get officeCode => raw.substring(1, 5);

  /// Digits 6-10: Group identifier (Birth volume/Leaflet).
  String get group => raw.substring(5, 10);

  /// Digits 11-12: Sequence number.
  String get seq => raw.substring(10, 12);

  /// Digit 13: Checksum digit.
  String get checkDigit => raw[12];

  /// Get a descriptive label for the category/type (Digit 1).
  String get typeDescription {
    switch (type) {
      case '1':
        return 'Thai national: birth registered within time limit';
      case '2':
        return 'Thai national: birth registered late';
      case '3':
        return 'Thai national/Alien: name in house registration of others';
      case '4':
        return 'Thai national/Alien: moved into house registration (no prev ID)';
      case '5':
        return 'Thai national: allowed to be added to house registration (case of double registration/other mistakes)';
      case '6':
        return 'Temporary resident (alien) / Illegal immigrant with temporary stay';
      case '7':
        return 'Child of type 6 person (born in Thailand)';
      case '8':
        return 'Alien / Other generic types (often used for non-Thai residents)';
      case '0':
        return 'Person without Thai nationality (stateless)'; // Note: historical usage varies
      default:
        return 'Unknown Type';
    }
  }
}
