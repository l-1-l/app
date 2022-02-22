import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class Loader extends StatelessWidget {
  final Color? color;
  final double size;
  const Loader({
    Key? key,
    this.color,
    this.size = 32,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LoadingAnimationWidget.waveDots(
      color: color ?? Theme.of(context).colorScheme.onPrimary,
      size: size,
    );
  }
}
