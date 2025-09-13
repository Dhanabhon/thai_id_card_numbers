import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  final _thaiId = ThaiIdCardNumbers();
  final _formKey = GlobalKey<FormState>();
  final _messengerKey = GlobalKey<ScaffoldMessengerState>();
  late final TextEditingController _controller;

  // Demo pattern/delimiter used across formatter and formatting APIs
  static const String _pattern = 'x-xxxx-xxxxx-xx-x';
  static const String _delimiter = '-';

  bool _isValid = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _digitsOnly(String text) {
    // Remove the configured delimiter to get raw 13-digit input
    return text.replaceAll(RegExp(RegExp.escape(_delimiter)), '');
  }

  void _showBanner(String message, {Color? color}) {
    _messengerKey.currentState?.hideCurrentMaterialBanner();
    _messengerKey.currentState?.showMaterialBanner(
      MaterialBanner(
        content: Text(
          message,
          style: TextStyle(color: color ?? Colors.green),
        ),
        actions: [
          TextButton(
            onPressed: () =>
                _messengerKey.currentState?.hideCurrentMaterialBanner(),
            child: const Text('DISMISS'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: _messengerKey,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Thai ID Card Number Demo'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.0),
                  child: Text('Enter your Thai ID card number'),
                ),
                TextFormField(
                  controller: _controller,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                  maxLength: _pattern.length,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (String? value) {
                    final raw = _digitsOnly(value ?? '');
                    if (raw.isEmpty) {
                      _isValid = false;
                      return 'Please enter your Thai ID card number';
                    }
                    final ok = _thaiId.validate(raw);
                    _isValid = ok;
                    return ok ? null : 'Invalid Thai ID card number';
                  },
                  onChanged: (_) => setState(() {
                    // trigger live validity indicator
                    final raw = _digitsOnly(_controller.text);
                    _isValid = _thaiId.validate(raw);
                  }),
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    ThaiIdCardNumbersFormatter(
                        pattern: _pattern, delimiter: _delimiter),
                  ],
                  decoration: const InputDecoration(
                    hintText: '1-2345-67890-12-1',
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(width: 1, color: Colors.blueAccent),
                    ),
                    counterText: '',
                  ),
                ),
                const SizedBox(height: 8.0),
                Row(
                  children: [
                    Icon(
                      _isValid ? Icons.check_circle : Icons.error_outline,
                      color: _isValid ? Colors.green : Colors.redAccent,
                      size: 18,
                    ),
                    const SizedBox(width: 6),
                    Text(_isValid ? 'Valid format' : 'Invalid format'),
                  ],
                ),
                const SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        final generated = _thaiId.generate();
                        _controller.text = _thaiId.format(
                          generated,
                          pattern: _pattern,
                          delimiter: _delimiter,
                        );
                        setState(() => _isValid = true);
                      },
                      icon: const Icon(Icons.autorenew),
                      label: const Text('Generate'),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        if (_formKey.currentState?.validate() ?? false) {
                          _showBanner('Valid Thai ID card number',
                              color: Colors.green);
                        } else {
                          _showBanner('Invalid Thai ID card number',
                              color: Colors.redAccent);
                        }
                      },
                      icon: const Icon(Icons.verified),
                      label: const Text('Validate'),
                    ),
                    ElevatedButton.icon(
                      onPressed: () async {
                        final raw = _digitsOnly(_controller.text);
                        await Clipboard.setData(ClipboardData(text: raw));
                        _showBanner('Copied raw digits to clipboard');
                      },
                      icon: const Icon(Icons.copy),
                      label: const Text('Copy'),
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
