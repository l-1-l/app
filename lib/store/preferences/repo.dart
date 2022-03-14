import 'dart:async';

import 'package:app/store/db.dart';
import 'package:app/types/preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sembast/sembast.dart';

final preferencesRepoProvider = Provider(
  (ref) {
    final db = ref.watch(dbProvider);

    return PreferencesRepo(db);
  },
);

class PreferencesRepo {
  PreferencesRepo(this._db);

  late final Database _db;

  late final StoreRef<int, Map<String, dynamic>> _table =
      intMapStoreFactory.store('preferences');

  Future<void> save(Preferences data) async {
    unawaited(_table.record(-1).put(_db, data.toJson()));
  }

  Future<Preferences?> read() async {
    final data = await _table.record(-1).get(_db);
    if (data == null) return null;
    return Preferences.fromJson(data);
  }
}
