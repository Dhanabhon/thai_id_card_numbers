# thai_id_card_numbers

[![pub package](https://img.shields.io/pub/v/thai_id_card_numbers)](https://pub.dev/packages/thai_id_card_numbers)

A Flutter/Dart package for validating and formatting Thai ID card numbers, including a TextInputFormatter for live masking as users type.

## Install

Add the dependency in `pubspec.yaml` and fetch packages:

```yaml
dependencies:
  thai_id_card_numbers: ^1.4.0
```

```
flutter pub get
```

## Quick start

Validate, format, and generate IDs in Dart code:

```dart
import 'package:thai_id_card_numbers/thai_id_card_numbers.dart';

final id = ThaiIdCardNumbers();

id.validate('1234567890121'); // true if checksum matches
id.format('1234567890121');   // => "1-2345-67890-12-1"
final generated = id.generate(); // valid 13-digit ID

// Helpers
id.validateFormatted('1-2345-67890-12-1'); // true (accepts delimiters)
id.normalize('1-2345-67890-12-1'); // => "1234567890121"
id.checksum('123456789012'); // => 1
```

Use the input formatter in a Flutter `TextFormField`:

```dart
import 'package:thai_id_card_numbers/thai_id_card_numbers_formatter.dart';

const pattern = 'x-xxxx-xxxxx-xx-x';
const delimiter = '-';

TextFormField(
  keyboardType: TextInputType.number,
  inputFormatters: [
    FilteringTextInputFormatter.digitsOnly,
    ThaiIdCardNumbersFormatter(pattern: pattern, delimiter: delimiter),
  ],
  validator: (value) {
    final raw = (value ?? '').replaceAll(RegExp(RegExp.escape(delimiter)), '');
    return ThaiIdCardNumbers().validate(raw) ? null : 'Invalid Thai ID card number';
  },
  decoration: const InputDecoration(hintText: '1-2345-67890-12-1'),
)
```

Customize the pattern/delimiter as needed (e.g., `'.'`):

```dart
ThaiIdCardNumbers().format('1234567890121', pattern: 'x.xxxx.xxxxx.xx.x', delimiter: '.');
// => "1.2345.67890.12.1"
```

## API

- `validate(String)`: Checks 13 digits (no delimiters) against checksum.
- `validateFormatted(String)`: Accepts formatted input; auto-normalizes.
- `format(String, {pattern, delimiter})`: Applies mask to digits.
- `formatStrict(String, {pattern, delimiter})`: Like `format` but throws if length mismatches pattern slots.
- `generate({int? firstDigit, bool formatted = false, String pattern, String delimiter})`: Creates a valid ID; optionally formatted and constrained by first digit.
- `normalize(String)`: Removes all non-digits.
- `checksum(String first12)`: Returns expected check digit for 12-digit prefix.

Checksum rule: sum of digit[i] × (13 − i) for i=0..11, then `(11 − (sum % 11)) % 10` equals the 13th digit.

## Example app

A runnable demo is included under `example/`.

- Run on web: `cd example && flutter run -d chrome`
- Features: live validation indicator, generate button, clipboard copy of raw digits.

## Screenshots

Add media under `docs/` and reference them here:

![Demo](docs/demo.gif)

If images don’t render on pub.dev, open the GitHub README directly.

## Documentation

- Pub.dev package: https://pub.dev/packages/thai_id_card_numbers
- Example app source: `example/lib/main.dart`
- Recording guide: `docs/RECORDING.md`

## Testing

Run the package tests:

```
flutter test
```

## Inspiration

This package is inspired by [thai-id-validator](https://www.npmjs.com/package/thai-id-validator).
