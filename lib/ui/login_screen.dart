import 'package:flutter/material.dart';
import 'package:pin_input_text_field/pin_input_text_field.dart';

import '../models/secure_storage.dart';
import 'main_screen.dart';
import 'wrong_pin_dialog.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen();

  static const SecureStorage _storage = SecureStorage();

  @override
  Widget build(BuildContext context) {
    final TextEditingController pinController = TextEditingController();
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const Text('Please enter your PIN'), centerTitle: true),
        body: Center(
          child: FractionallySizedBox(
            widthFactor: 0.9,
            child: SizedBox(
              height: 80,
              child: PinInputTextField(
                decoration: BoxLooseDecoration(
                  strokeColorBuilder: PinListenColorBuilder(Colors.cyan, Colors.grey),
                  // obscureStyle: ObscureStyle(isTextObscure: true),
                ),
                controller: pinController,
                pinLength: 4,
                autoFocus: true,
                textInputAction: TextInputAction.go,
                onSubmit: (pin) async {
                  String encryptedKey = await _storage.read(pin);
                  final bool noPinExists = encryptedKey.isEmpty;
                  if (noPinExists) {
                    final bool? toCreateNew = await showDialog<bool>(
                        context: context, builder: (BuildContext context) => const WrongPinDialog());
                    if (toCreateNew == true) {
                      encryptedKey = await _storage.write(pin);
                    } else {
                      pinController.clear();
                      return;
                    }
                  }
                  // SchedulerBinding.instance?.addPostFrameCallback((_) async {
                  await Navigator.pushReplacement<void, void>(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MainScreen(encryptedKey: encryptedKey, isNewDB: noPinExists),
                    ),
                  );
                  // });
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
