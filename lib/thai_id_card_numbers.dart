import 'dart:math';

class ThaiIdCardNumbers {
  final RegExp _thaiIDNumbers = RegExp(r"^([0-9]{13})$");

  bool validate(String strNumbers) {
    strNumbers = strNumbers.trim();

    if (!_thaiIDNumbers.hasMatch(strNumbers)) {
      return false;
    }

    int sum = 0;
    List<String> strSplit =
        List<String>.generate(strNumbers.length, (index) => strNumbers[index]);

    for (int i = 0; i < strSplit.length - 1; i++) {
      sum += int.parse(strSplit[i]) * (13 - i);
    }

    // checksum, compare, return
    return (((11 - sum % 11) % 10) == int.parse(strNumbers[12]));
  }

  String random() {
    String number = "";
    Random rand = Random();

    for (int i = 0; i < 13; i++) {
      number += rand.nextInt(10).toString();
    }

    return number;
  }

  String generate() {
    String number = "";
    while (true) {
      number = random();
      if (validate(number)) {
        break;
      }
    }

    return number;
  }

  String format(String number,
      {String pattern = 'x-xxxx-xxxxx-xx-x', String delimiter = '-'}) {
    String newFormat = "";
    int indexCounter = 0;

    for (int i = 0; i < pattern.length; i++) {
      if (pattern[i] != delimiter) {
        newFormat += number[indexCounter];
        indexCounter++;
      } else {
        newFormat += delimiter;
      }
    }
    return newFormat;
  }
}
