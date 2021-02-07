import '../constants.dart';

// ignore_for_file: avoid_as
class DbItem {
  int? id;
  late String name, login, password;

  DbItem({this.name = '', this.login = '', this.password = '', this.id});

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{
      columnName: name,
      columnLogin: login,
      columnPassword: password,
    };
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }

  DbItem.fromMap(Map<String, dynamic> map) {
    //TODO Add type-check.
    id = map[columnId] as int;
    name = map[columnName] as String;
    login = map[columnLogin] as String;
    password = map[columnPassword] as String;
  }
}
