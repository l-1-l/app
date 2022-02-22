import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeRepo {
  Future<String> _getFromLocal() async {
    final db = await SharedPreferences.getInstance();
    return db.getString("themeMode") ?? '';
  }

  Future<bool> setMode(ThemeMode themeMode) async {
    final db = await SharedPreferences.getInstance();

    return db.setString(
      "themeMode",
      themeMode.toString(),
    );
  }

  Future<ThemeMode> getMode() async {
    final mode = await _getFromLocal();
    switch (mode) {
      case 'dark':
        return ThemeMode.dark;
      case 'light':
        return ThemeMode.light;
      default:
        return ThemeMode.system;
    }
  }

  ThemeRepo._internal();
  factory ThemeRepo() => _instance;

  static late final ThemeRepo _instance = ThemeRepo._internal();
}
