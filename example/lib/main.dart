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
  late TextEditingController _textEditingController;

  @override
  void initState() {
    super.initState();

    _textEditingController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _textEditingController.dispose();
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
                    child: Text('Enter your Thai ID card numbers')),
                TextFormField(
                  controller: _textEditingController,
                  validator: (String? value) {
                    String? newValue = value?.replaceAll(RegExp('-'), '');
                    if (!_thaiIdCardNumbers.validate(newValue!)) {
                      return "$value is not a valid Thai ID card numbers.";
                    }
                    return null;
                  },
                  inputFormatters: [
                    ThaiIdCardNumbersFormatter(
                        pattern: pattern, delimiter: separator),
                  ],
                  decoration: const InputDecoration(
                      hintText: "1-2345-67891-01-2",
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 1, color: Colors.blueAccent))),
                ),
                const SizedBox(height: 10.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        _textEditingController.clear();
                        _textEditingController.text = _thaiIdCardNumbers
                            .format(_thaiIdCardNumbers.generate());
                      },
                      child: const Text("Generate"),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _messengerKey.currentState
                              ?.showMaterialBanner(MaterialBanner(
                            content: const Text(
                              "Congratulations, Your Thai ID card numbers is in valid format.",
                              style: TextStyle(
                                color: Colors.green,
                              ),
                            ),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    _messengerKey.currentState
                                        ?.hideCurrentMaterialBanner();
                                  },
                                  child: const Text("DISMISS")),
                            ],
                          ));
                        }
                      },
                      child: const Text("Validate"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
