import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';

mixin KeyboardHeightObserver<T extends StatefulWidget>
    on State<T>, WidgetsBindingObserver {
  double _height = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    EasyDebounce.cancel('updateKeyboardHeight');
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();

    if (!mounted) return;
    final temp = keyboardHeight;
    if (temp == _height || temp == 0 || temp <= _height) return;

    EasyDebounce.debounce(
        'updateKeyboardHeight', const Duration(milliseconds: 100), () {
      _height = temp;

      onKeyboardOpen(_height);
    });
  }

  void onKeyboardOpen(double _height);

  double get keyboardHeight {
    final window = WidgetsBinding.instance?.window;
    if (window == null) return _height;

    return EdgeInsets.fromWindowPadding(
      window.viewInsets,
      window.devicePixelRatio,
    ).bottom;
  }
}
