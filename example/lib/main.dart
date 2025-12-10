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

  static const String _pattern = 'x-xxxx-xxxxx-xx-x';
  static const String _delimiter = '-';

  bool _isValid = false;
  ThaiIdInfo? _extractedInfo;

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

  void _updateState() {
    // CLEANER CODE: Use extension .isValidThaiIdFormatted
    final isValid = _controller.text.isValidThaiIdFormatted;

    // CLEANER CODE: Use extension .thaiIdInfo
    final info = _controller.text.thaiIdInfo; // returns null if invalid length

    setState(() {
      _isValid = isValid;
      _extractedInfo = info;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: _messengerKey,
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Thai ID Card Number v1.5.0'),
          centerTitle: true,
        ),
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Scrollbar(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: _formKey,
                  child: ListView(
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12.0),
                        child: Text(
                          'Enter your Thai ID card number',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      TextFormField(
                        controller: _controller,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.done,
                        autovalidateMode: AutovalidateMode.onUserInteraction,

                        // NEW: Use Ready-to-use Form Validator
                        validator: ThaiIdValidator.validate(
                          errorText: 'Invalid ID Format',
                          allowEmpty: false,
                        ),

                        onChanged: (_) => _updateState(),

                        // Support Enter key to submit
                        onFieldSubmitted: (_) {
                          if (_formKey.currentState?.validate() ?? false) {
                            _showBanner('Valid Thai ID!', color: Colors.green);
                          } else {
                            _showBanner('Invalid!', color: Colors.redAccent);
                          }
                        },

                        // UPDATED: Use Smart Input Formatter
                        inputFormatters: [
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
                            size: 20,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            _isValid ? 'Valid Format' : 'Invalid Format',
                            style: TextStyle(
                              color: _isValid ? Colors.green : Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16.0),

                      // NEW: Show Extracted Info
                      if (_extractedInfo != null) ...[
                        Card(
                          color: Colors.grey.shade100,
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('📄 Extracted Info:',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                const Divider(),
                                Text(
                                    'Type: ${_extractedInfo!.typeDescription}'),
                                Text(
                                    'Office Code: ${_extractedInfo!.officeCode}'),
                                Text('Group: ${_extractedInfo!.group}'),
                                Text('Seq: ${_extractedInfo!.seq}'),
                                Text(
                                    'Check Digit: ${_extractedInfo!.checkDigit}'),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],

                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        alignment: WrapAlignment.center,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () {
                              // NEW: Generate formatted directly
                              final generated =
                                  _thaiId.generate(formatted: true);
                              _controller.text = generated;
                              _updateState();
                            },
                            icon: const Icon(Icons.autorenew),
                            label: const Text('Generate'),
                          ),
                          ElevatedButton.icon(
                            onPressed: () {
                              if (_formKey.currentState?.validate() ?? false) {
                                _showBanner('Valid Thai ID!',
                                    color: Colors.green);
                              } else {
                                _showBanner('Invalid!',
                                    color: Colors.redAccent);
                              }
                            },
                            icon: const Icon(Icons.verified),
                            label: const Text('Submit'),
                          ),
                          OutlinedButton.icon(
                            onPressed: () async {
                              // CLEANER: Normalize extension
                              final raw = _thaiId.normalize(_controller.text);
                              await Clipboard.setData(ClipboardData(text: raw));
                              _showBanner('Copied digits: $raw');
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
          ),
        ),
      ),
    );
  }
}
