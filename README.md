# thai_id_card_numbers

[![pub package](https://img.shields.io/pub/v/thai_id_card_numbers)](https://pub.dev/packages/thai_id_card_numbers)

A Flutter plugin for validating and formatting Thai ID card numbers as users type.

## Usage

To use this plugin, add `thai_id_card_numbers` as a [dependency in your pubspec.yaml file](https://flutter.dev/docs/development/platform-integration/platform-channels).

### Examples

<?code-excerpt "main.dart (example)"?>
```dart
import 'package:flutter/material.dart';

import 'package:thai_id_card_numbers/thai_id_card_numbers.dart';
import 'package:thai_id_card_numbers/thai_id_card_numbers_formatter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _thaiIdCardNumbers = ThaiIdCardNumbers();
  final _formKey = GlobalKey<FormState>();
  final _messengerKey = GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String pattern = "x-xxxx-xxxxx-xx-x";
    String separator = "-";

    return MaterialApp(
      scaffoldMessengerKey: _messengerKey,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Thai ID Card Number Validator Demo'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Text('Enter your Thai ID card numbers')
                ),

                TextFormField(
                  validator: (value) {
                    String? newValue = value?.replaceAll(RegExp('-'), '');
                    if (!_thaiIdCardNumbers.validate(newValue!)) {
                      return "$value is not a valid Thai ID card numbers.";
                    }
                    return null;
                  },
                  inputFormatters: [
                    ThaiIdCardNumbersFormatter(pattern: pattern, delimiter: separator),
                  ],
                  decoration: const InputDecoration(
                      hintText: "1-2345-67891-01-2",
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 1, color: Colors.blueAccent)
                      )
                  ),
                ),

                const SizedBox(height: 10.0),

                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _messengerKey.currentState?.showMaterialBanner(
                          MaterialBanner(
                            content: const Text(
                              "Congratulations, Your Thai ID card numbers is in valid format.",
                              style: TextStyle(
                                color: Colors.green,
                              ),
                            ),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    _messengerKey.currentState?.hideCurrentMaterialBanner();
                                  },
                                  child: const Text("DISMISS")
                              ),
                            ],
                          )
                      );
                    }
                  },
                  child: const Text("Validate"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
```

## Inspiration
This plugin is inspired by [thai-id-validator](https://www.npmjs.com/package/thai-id-validator).

