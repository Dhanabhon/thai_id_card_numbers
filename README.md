# Thai ID Card Numbers

[![pub package](https://img.shields.io/pub/v/thai_id_card_numbers)](https://pub.dev/packages/thai_id_card_numbers)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

A powerful Flutter/Dart package for validating, formatting, and generating Thai ID card numbers. 
Now features **Smart Input Formatter** for better UX and **Data Extraction** tools.
<br>

<p align="center">
  <img src="docs/demo.gif" alt="Thai ID Card Numbers Demo" width="300" />
</p>

---

## Features

- **Validation**: Verify 13-digit Thai ID checksums.
- **Formatting**: Auto-format strings (e.g., `1-2345-67890-12-1`).
- **Smart Input Formatter**: A `TextInputFormatter` for Flutter that handles cursor positioning intelligently as you type or edit.
- **Extensions**: Clean and readable Dart extensions (e.g., `'...'.isValidThaiId`).
- **Data Extraction**: Parse metadata like **Person Type**, **Office Code**, and **Group** from an ID.
- **Form Validator**: Ready-to-use `FormFieldValidator` for `TextFormField`.

## Installation

Add the dependency in `pubspec.yaml`:

```yaml
dependencies:
  thai_id_card_numbers: ^1.5.0
```

Run `flutter pub get` to install.

## Usage Guide

### 1. Basic Validation & Formatting (Dart/Console)

```dart
import 'package:thai_id_card_numbers/thai_id_card_numbers.dart';

final id = ThaiIdCardNumbers();

// Validate
bool isValid = id.validate('1234567890121'); // true if checksum matches

// Format
String formatted = id.format('1234567890121'); // "1-2345-67890-12-1"

// Generate random valid ID
String generated = id.generate(formatted: true); 
```

### 2. String Extensions (Recommended)

Write cleaner code using Dart extensions:

```dart
import 'package:thai_id_card_numbers/thai_id_card_numbers.dart';

String raw = '1234567890121';

if (raw.isValidThaiId) {
  print('Passes Checksum!');
}

print(raw.formatAsThaiId()); // "1-2345-67890-12-1"
```

### 3. Flutter Form Integration

#### Smart Input Formatter
Use `ThaiIdCardNumbersFormatter` in your `TextField`. It automatically formats input and keeps the cursor in the right place even during editing.

```dart
import 'package:thai_id_card_numbers/thai_id_card_numbers_formatter.dart';

TextFormField(
  keyboardType: TextInputType.number,
  inputFormatters: [
    ThaiIdCardNumbersFormatter(delimiter: '-'), // Pattern defaults to x-xxxx-xxxxx-xx-x
  ],
)
```

#### Form Validator
Validate the field easily:

```dart
TextFormField(
  validator: ThaiIdValidator.validate(
    errorText: 'Please enter a valid ID',
    allowEmpty: false,
  ),
)
```

### 4. Data Extraction (Metadata)

Extract hidden information from a valid Thai ID:

```dart
final info = '1-2345-67890-12-1'.thaiIdInfo;

if (info != null) {
  print('Type: ${info.typeDescription}'); // e.g., "Thai national: birth registered within..."
  print('Province/District Code: ${info.officeCode}');
  print('Group/Volume: ${info.group}');
}
```

---

## Contributing

We welcome contributions! Whether it's reporting a bug, suggesting an enhancement, or submitting a Pull Request.

### Development Setup

1.  **Clone the repo**:
    ```bash
    git clone https://github.com/Dhanabhon/thai_id_card_numbers.git
    ```
2.  **Install dependencies**:
    ```bash
    flutter pub get
    ```
3.  **Run Tests**:
    We have a comprehensive test suite in the `test/` directory, broken down by feature.
    ```bash
    flutter test
    ```

### Project Structure

*   `lib/thai_id_card_numbers.dart`: Core logic validation/formatting.
*   `lib/thai_id_card_numbers_formatter.dart`: Flutter input formatter logic.
*   `lib/src/`: Internal implementation and helper classes (`Extensions`, `ThaiIdInfo`).
*   `test/`: Unit tests corresponding to each feature.

---

## Links

*   **Pub.dev**: [pub.dev/packages/thai_id_card_numbers](https://pub.dev/packages/thai_id_card_numbers)
*   **Documentation**: [dartdocs](https://pub.dev/documentation/thai_id_card_numbers/latest/)

## Inspiration

Inspired by [thai-id-validator](https://www.npmjs.com/package/thai-id-validator).
