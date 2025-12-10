## 1.5.0

* **New Features**:
  * Added `ThaiIdStringExtension` for easier usage (e.g., `'...'.isValidThaiId`, `'...'.thaiIdInfo`).
  * Added `ThaiIdInfo` class for extracting metadata (type, office code, group, sequence) from an ID number.
  * Added `ThaiIdValidator.validate()` for easy integration with Flutter's `TextFormField`.
* **Improvements**:
  * Enhanced `ThaiIdCardNumbersFormatter` with smarter cursor positioning logic for better UX.

## 1.4.0

* Add helper APIs: `normalize`, `validateFormatted`, `checksum`.
* Enhance `generate` with options: `firstDigit`, `formatted`, `pattern`, `delimiter`.
* Add `formatStrict` for pattern-validated formatting.
* Improve `ThaiIdCardNumbersFormatter` to handle paste/cleanup and prevent overflow.
* Update example app and README; add recording guide under `docs/`.

## 1.3.0

* Supports Web platform
* Upgrade to the new version of the dependencies.

## 1.2.1

* Upgrade to the new version of the dependencies.

## 1.2.0

* Add new features for Thai ID card number generating and formatting.
