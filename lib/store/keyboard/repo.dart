import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../prefs.dart';

final keyboardRepoProvider = Provider<KeyboardRepo>(
  (ref) {
    final prefs = ref.watch(prefsProvider).value;

    return KeyboardRepo(prefs);
  },
);

class KeyboardRepo {
  final SharedPreferences? _prefs;
  const KeyboardRepo(this._prefs);

  double? read() => _prefs?.getDouble('_keyboard_height_');

  save(double height) {
    _prefs?.setDouble('_keyboard_height_', height);
  }
}
