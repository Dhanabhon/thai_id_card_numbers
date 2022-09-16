import 'thai_id_card_numbers_formatter.dart';

class ThaiIdCardNumbers {
  final RegExp _thaiIDNumbers = RegExp(r"^([0-9]{13})$");

  bool validate(String strNumbers) {

    strNumbers = strNumbers.trim();

    if (!_thaiIDNumbers.hasMatch(strNumbers)) {
      return false;
    }

    int sum = 0;
    List<String> strSplit = List<String>.generate(strNumbers.length, (index) => strNumbers[index]);

    for(int i = 0; i < strSplit.length - 1; i++) {
      sum += int.parse(strSplit[i]) * (13 - i);
    }

    // checksum, compare, return
    return (((11 - sum % 11) % 10) == int.parse(strNumbers[12]));
  }
}
