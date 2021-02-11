import 'package:sqflite_sqlcipher/sqflite.dart';
import 'package:path/path.dart';

import '../constants.dart';
// ignore_for_file: missing_whitespace_between_adjacent_strings

class UnlockedDb {
  late Database _database;

  Database get data => _database;

  Future<bool> open({required String password, bool asNew = false}) async {
    final String dbPath = await getDatabasesPath();
    if (asNew) {
      await deleteDatabase(join(dbPath, '$dbName.db'));
    }
    try {
      _database = await openDatabase(
        join(dbPath, '$dbName.db'),
        version: 1,
        password: password,
        onCreate: (Database database, int _) async {
          await database.execute(
            'CREATE TABLE $dbName ('
            '$columnId INTEGER PRIMARY KEY,'
            '$columnName $dbTextType,'
            '$columnLogin $dbTextType,'
            '$columnPassword $dbTextType'
            ')',
          );
        },
      );
      // ignore: avoid_catches_without_on_clauses
    } catch (error) {
      // ignore: avoid_print
      print('Error: $error');
      return false;
    }
    return _database.isOpen;
  }

  // Future<bool> get _emptyCheck async {
  //   final firstItem = await _database.query(dbName, where: whereID, whereArgs: [0]);
  //   return firstItem.isEmpty;
  // }
}
