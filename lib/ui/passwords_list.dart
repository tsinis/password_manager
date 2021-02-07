import 'package:flutter/material.dart';

import '../db_repository.dart';
import '../models/database_model.dart';
import '../models/db_item_model.dart';
import 'detail_dialog.dart';

class PasswordsList extends StatefulWidget {
  const PasswordsList(this.unlockedDB);
  final UnlockedDb unlockedDB;
  @override
  _PasswordsListState createState() => _PasswordsListState();
}

class _PasswordsListState extends State<PasswordsList> {
  late final DbRepository _dbRepository;

  @override
  void initState() {
    _dbRepository = DbRepository(widget.unlockedDB);
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: FutureBuilder<List<DbItem>>(
          future: _dbRepository.read,
          builder: (context, snapshot) => (snapshot.hasData)
              ? ListView.separated(
                  itemCount: snapshot.data!.length,
                  separatorBuilder: (BuildContext context, int index) => const Divider(thickness: 1.6, height: 1.6),
                  itemBuilder: (BuildContext context, int index) {
                    final DbItem existingDbItem = snapshot.data!.elementAt(index);
                    return InkWell(
                      onTap: () => showDialog<DbItem>(
                          context: context,
                          builder: (BuildContext context) => DetailDialog(existingItem: existingDbItem)).then(
                        (updatedDbItem) async {
                          if (updatedDbItem != null) {
                            updatedDbItem.id = existingDbItem.id;
                            await _dbRepository.update(updatedDbItem).whenComplete(() => setState(() {}));
                          }
                        },
                      ),
                      child: Dismissible(
                        confirmDismiss: (_) async => await showDialog<bool>(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            title: const Text('Confirm'),
                            content: const Text('Are you sure you wish to delete this item?'),
                            actions: <Widget>[
                              TextButton(
                                  onPressed: () => Navigator.of(context).pop(false),
                                  child: const Text(
                                    'CANCEL',
                                    style: TextStyle(color: Colors.white),
                                  )),
                              TextButton(
                                  onPressed: () => Navigator.of(context).pop(true),
                                  child: const Text(
                                    'DELETE',
                                    style: TextStyle(color: Colors.red),
                                  )),
                            ],
                          ),
                        ).then((toDeleteItem) async {
                          if (toDeleteItem == true) {
                            await _dbRepository.delete(existingDbItem.id!).whenComplete(() => setState(() {}));
                            return true;
                          } else {
                            return false;
                          }
                        }),
                        secondaryBackground: const RemoveBackground(secondary: true),
                        background: const RemoveBackground(),
                        key: UniqueKey(),
                        child: ListTile(
                          // isThreeLine: true,
                          // ignore: unnecessary_string_interpolations
                          title: Text('${snapshot.data!.elementAt(index).login}'),
                          subtitle: Text('login: ${snapshot.data!.elementAt(index).name}'),
                          horizontalTitleGap: 10,
                        ),
                      ),
                    );
                  },
                )
              : const Center(child: CircularProgressIndicator()),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () =>
              showDialog<DbItem>(context: context, builder: (BuildContext context) => const DetailDialog()).then(
            (newDbItem) async {
              if (newDbItem != null) {
                await _dbRepository.create(newDbItem).whenComplete(() => setState(() {}));
              }
            },
          ),
          child: const Icon(Icons.add),
        ),
      );
}

class RemoveBackground extends StatelessWidget {
  const RemoveBackground({this.secondary = false});
  final bool secondary;
  @override
  Widget build(BuildContext context) => ColoredBox(
        color: Theme.of(context).errorColor,
        child: Align(
          alignment: secondary ? Alignment.centerRight : Alignment.centerLeft,
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Icon(Icons.delete_forever, color: Colors.white70),
          ),
        ),
      );
}
