// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

///
class OvOThemeData {
  static const _lightFillColor = Colors.white;
  static const _darkFillColor = Colors.white;

  static final Color _lightFocusColor = Colors.black.withOpacity(0.12);
  static final Color _darkFocusColor = Colors.white.withOpacity(0.12);

  ///
  static ThemeData lightThemeData =
      themeData(lightColorScheme, _lightFocusColor);

  ///
  static ThemeData darkThemeData = themeData(darkColorScheme, _darkFocusColor);

  ///
  static ThemeData themeData(ColorScheme colorScheme, Color focusColor) {
    return ThemeData(
      colorScheme: colorScheme,
      primaryColor: const Color(0xFFFF5CA2),
      textTheme: _textTheme,
      // Matches manifest.json colors and background color.
      // primaryColor: const Color(0xFF030303),
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.background,
        elevation: 0,
        shadowColor: Colors.transparent,
        // iconTheme: IconThemeData(color: colorScheme.primary),
      ),
      // iconTheme: IconThemeData(color: colorScheme.onPrimary),
      canvasColor: colorScheme.background,
      scaffoldBackgroundColor: colorScheme.background,
      highlightColor: Colors.transparent,
      focusColor: focusColor,
      unselectedWidgetColor: colorScheme.primary,
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: TextStyle(
          color: colorScheme.secondary,
          fontSize: _textTheme.bodyText1?.fontSize,
        ),
      ),
      // textSelectionTheme: const TextSelectionThemeData(
      //   cursorColor: Color(0xFFFF5CA2),
      //   selectionColor: Color.fromARGB(66, 250, 101, 148),
      //   selectionHandleColor: Color.fromARGB(192, 250, 101, 148),
      // ),

      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Color.alphaBlend(
          _lightFillColor.withOpacity(0.80),
          _darkFillColor,
        ),
        contentTextStyle: _textTheme.subtitle1!.apply(color: _darkFillColor),
      ),
    );
  }

  ///
  static ColorScheme lightColorScheme = const ColorScheme(
    primary: Color(0xFF1B1B1B),
    // primary: Color(0xFFFA6594),
    primaryContainer: Color(0xFF117378),
    secondary: Color(0xff8c8c8c),
    secondaryContainer: Color(0xFFFAFBFB),

    tertiary: Color(0xfff7f7f7),
    // background: Color(0xFFFBFBFC),
    background: Colors.white,
    surface: Colors.white,
    onBackground: Colors.white,
    // outline: Color.fromRGBO(189, 189, 189, 1),
    outline: Color(0xffd9d9d9),

    error: _lightFillColor,
    onError: _lightFillColor,
    onPrimary: _lightFillColor,
    onSecondary: Color(0xFF322942),
    onSurface: Color(0xFF241E30),
    brightness: Brightness.light,
  );

  ///
  static const ColorScheme darkColorScheme = ColorScheme(
    primary: Color(0xFFFF8383),
    primaryContainer: Color(0xFF1CDEC9),
    secondary: Color(0xFF4D1F7C),
    secondaryContainer: Color(0xFF451B6F),
    background: Color(0xFF241E30),
    surface: Color(0xFF1F1929),
    onBackground: Color(0x0DFFFFFF), // White with 0.05 opacity
    error: _darkFillColor,
    onError: _darkFillColor,
    onPrimary: _darkFillColor,
    onSecondary: _darkFillColor,
    onSurface: _darkFillColor,
    brightness: Brightness.dark,
  );

  static const _regular = FontWeight.w400;
  static const _medium = FontWeight.w500;
  static const _semiBold = FontWeight.w600;
  static const _bold = FontWeight.w700;

  static const TextTheme _textTheme = TextTheme(
    headline5: TextStyle(fontWeight: _semiBold, fontSize: 20),
    headline6: TextStyle(fontWeight: _bold, fontSize: 16),
    subtitle1: TextStyle(fontWeight: _medium, fontSize: 16),
    subtitle2: TextStyle(fontWeight: _medium, fontSize: 14),
    bodyText1: TextStyle(fontWeight: _regular, fontSize: 14),
    bodyText2: TextStyle(fontWeight: _regular, fontSize: 16),
    button: TextStyle(fontWeight: _semiBold, fontSize: 14),
    caption: TextStyle(fontWeight: _regular, fontSize: 12),
    overline: TextStyle(fontWeight: _regular, fontSize: 10),
  );
}
