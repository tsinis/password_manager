import 'package:flutter/material.dart';
import 'package:pin_input_text_field/pin_input_text_field.dart';

import '../models/secure_storage.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen();

  static const SecureStorage _storage = SecureStorage();

  @override
  Widget build(BuildContext context) {
    final TextEditingController pinController = TextEditingController();
    return SafeArea(
      child: Material(
        child: FractionallySizedBox(
          widthFactor: 0.9,
          child: Wrap(
            alignment: WrapAlignment.center,
            children: [
              const Padding(padding: EdgeInsets.only(top: 20, bottom: 30), child: Text('Please enter your PIN')),
              SizedBox(
                height: 80,
                child: PinInputTextField(
                  controller: pinController,
                  pinLength: 4,
                  autoFocus: true,
                  textInputAction: TextInputAction.go,
                  onSubmit: (pin) async {
                    String encryptedKey = await _storage.read(pin);
                    final bool noPinExists = encryptedKey.isEmpty;
                    if (noPinExists) {
                      final bool? toCreateNew = await showDialog<bool>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: const Text('No data exists with this PIN'),
                          content: const Padding(
                              padding: EdgeInsets.all(8), child: Text('Would you like to create new database?')),
                          actions: [
                            TextButton(
                                onPressed: () => Navigator.pop(context, false), child: const Text('NO, TRY AGAIN')),
                            TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('YES, CREATE'))
                          ],
                        ),
                      );
                      if (toCreateNew == true) {
                        encryptedKey = await _storage.write(pin);
                      } else {
                        pinController.clear();
                        return;
                      }
                    }
                    print('key is $encryptedKey, pin exists: $noPinExists');
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
