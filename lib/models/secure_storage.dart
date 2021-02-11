import 'dart:math';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  const SecureStorage();

  static const _storage = FlutterSecureStorage();

  Future<String> read(String key) async => await _storage.read(key: key) ?? '';

  Future<String> write(String key) async {
    await _storage.deleteAll();
    final String _encryptedKey = _randomValue;
    await _storage.write(key: key, value: _encryptedKey);
    return _encryptedKey;
  }

  String get _randomValue {
    final rand = Random();
    final codeUnits = List.generate(20, (index) => rand.nextInt(26) + 65);
    return String.fromCharCodes(codeUnits);
  }
}
