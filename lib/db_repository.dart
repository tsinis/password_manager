import 'constants.dart';
import 'models/database_model.dart';
import 'models/db_item_model.dart';

class DbRepository {
  DbRepository(this._unlockedDB);

  final UnlockedDb _unlockedDB;

  Future<List<DbItem>> get read async {
    final dbItems = await _unlockedDB.data.query(dbName, columns: [columnId, columnName, columnLogin, columnPassword]);
    final List<DbItem> _databaseItems = [];
    for (final item in dbItems) {
      final DbItem dbItem = DbItem.fromMap(item);
      _databaseItems.add(dbItem);
    }
    return _databaseItems;
  }

  Future<void> create(DbItem dbItem) async => dbItem.id = await _unlockedDB.data.insert(dbName, dbItem.toMap());

  Future<void> delete(int id) async => await _unlockedDB.data.delete(dbName, where: whereID, whereArgs: [id]);

  Future<void> update(DbItem dbItem) async =>
      await _unlockedDB.data.update(dbName, dbItem.toMap(), where: whereID, whereArgs: [dbItem.id]);
}
