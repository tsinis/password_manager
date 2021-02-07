import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/db_item_model.dart';

class DetailDialog extends StatefulWidget {
  const DetailDialog({this.existingItem});
  final DbItem? existingItem;

  @override
  _DetailDialogState createState() => _DetailDialogState();
}

class _DetailDialogState extends State<DetailDialog> {
  bool get toAddNew => widget.existingItem == null;
  bool toHidePassword = true;
  late final TextEditingController nameField, loginField, passwordField;

  @override
  void initState() {
    nameField = TextEditingController(text: widget.existingItem?.name);
    loginField = TextEditingController(text: widget.existingItem?.login);
    passwordField = TextEditingController(text: widget.existingItem?.password)
      ..addListener(() {
        if (!toAddNew && !toHidePassword) {
          final String selectedPassword = passwordField.text;
          passwordField.value = passwordField.value.copyWith(
            text: selectedPassword,
            selection: TextSelection(baseOffset: 0, extentOffset: selectedPassword.length),
            composing: TextRange.empty,
          );
        }
      });
    super.initState();
  }

  Future<void> _pasteData({bool isLoginField = true}) async {
    final ClipboardData? dataFromClipboard = await Clipboard.getData('text/plain');
    if (dataFromClipboard != null) {
      isLoginField ? loginField.text = dataFromClipboard.text! : nameField.text = dataFromClipboard.text!;
    }
  }

  final _formKey = GlobalKey<FormState>();

  String? validator(String? value) {
    if (value!.isEmpty) {
      return 'Please enter some text';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
        scrollable: true,
        title: toAddNew ? const Text('Add new') : Text('Showing ${nameField.text}'),
        content: Padding(
          padding: const EdgeInsets.all(8),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                TextFormField(
                  validator: validator,
                  maxLength: 255,
                  autofocus: toAddNew,
                  controller: nameField,
                  decoration: InputDecoration(
                    labelText: 'Page/Service',
                    icon: const Icon(Icons.domain),
                    suffixIcon: IconButton(
                      padding: EdgeInsets.zero,
                      icon: Icon(toAddNew ? Icons.paste : Icons.copy),
                      onPressed: () async => toAddNew
                          ? await _pasteData(isLoginField: false)
                          : Clipboard.setData(ClipboardData(text: nameField.text)),
                    ),
                  ),
                ),
                TextFormField(
                  maxLength: 255,
                  validator: validator,
                  controller: loginField,
                  decoration: InputDecoration(
                    labelText: 'Login',
                    icon: const Icon(Icons.account_box),
                    suffixIcon: IconButton(
                      padding: EdgeInsets.zero,
                      icon: Icon(toAddNew ? Icons.paste : Icons.copy),
                      onPressed: () async =>
                          toAddNew ? await _pasteData() : Clipboard.setData(ClipboardData(text: loginField.text)),
                    ),
                  ),
                ),
                TextFormField(
                  maxLength: 255,
                  validator: validator,
                  controller: passwordField,
                  obscureText: toHidePassword,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    icon: const Icon(Icons.vpn_key),
                    suffixIcon: IconButton(
                        padding: EdgeInsets.zero,
                        icon: Icon(toHidePassword ? Icons.visibility_off : Icons.visibility),
                        onPressed: () => setState(() => toHidePassword = !toHidePassword)),
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  Navigator.pop(
                      context, DbItem(name: nameField.text, login: loginField.text, password: passwordField.text));
                }
              },
              child: Text(
                toAddNew ? 'SUBMIT' : 'UPDATE',
                style: const TextStyle(color: Colors.white),
              ))
        ],
      );
}
