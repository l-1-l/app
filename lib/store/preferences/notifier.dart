import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../types/preferences.dart' show Preferences;
import 'repo.dart';

final preferencesProvider =
    StateNotifierProvider<PreferencesNotifier, Preferences>(
  (ref) => throw UnimplementedError(),
);

final keybaordHeightProvider =
    Provider((ref) => ref.watch(preferencesProvider).keyboardHeight);

class PreferencesNotifier extends StateNotifier<Preferences> {
  PreferencesNotifier(
    this._reader,
    Preferences init,
  ) : super(init);

  late final Reader _reader;
  late final repo = _reader(preferencesRepoProvider);

  double get keyboardHeight => state.keyboardHeight;
  ThemeMode get themeMode => state.themeMode;

  void setThemeMode(ThemeMode themeMode) {
    if (themeMode == state.themeMode) return;
    state = state.copyWith(themeMode: themeMode);
    unawaited(repo.save(state));
  }

  void setKeyboardHeight(double height) {
    if (height == 0 ||
        height == state.keyboardHeight ||
        height <= state.keyboardHeight) return;

    state = state.copyWith(keyboardHeight: height);
    unawaited(repo.save(state));
  }
}
