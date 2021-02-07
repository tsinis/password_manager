import 'package:flutter/material.dart';
import '../models/database_model.dart';
import 'passwords_list.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({required this.encryptedKey, required this.isNewDB});
  final String encryptedKey;
  final bool isNewDB;

  static final UnlockedDb _unlockedDB = UnlockedDb();

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Password Manager'), centerTitle: true),
        body: FutureBuilder<bool>(
            future: _unlockedDB.open(password: encryptedKey, asNew: isNewDB),
            builder: (context, snapshot) => (snapshot.data == true)
                ? PasswordsList(_unlockedDB)
                : const Center(child: CircularProgressIndicator())),
      );
}
