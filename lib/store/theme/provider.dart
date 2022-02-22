import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'repository.dart';

final themeProvider =
    StateNotifierProvider<ThemeNotifier, ThemeMode>((ref) => ThemeNotifier());

class ThemeNotifier extends StateNotifier<ThemeMode> {
  late final ThemeRepo _themeRepo = ThemeRepo();

  ThemeNotifier() : super(ThemeMode.light);

  void setMode(ThemeMode mode) async {
    _themeRepo.setMode(mode);
    state = mode;
  }
}
