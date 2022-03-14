import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:nil/nil.dart';

class SerialBadge extends StatelessWidget {
  const SerialBadge({
    Key? key,
    this.size = 22,
    this.color,
    this.focusColor,
    this.borderColor,
    this.val,
    this.textStyle,
    this.visible = true,
  }) : super(key: key);

  final double size;
  final Color? color;
  final Color? focusColor;
  final Color? borderColor;
  final bool visible;

  final int? val;
  final TextStyle? textStyle;
  @override
  Widget build(BuildContext context) {
    const _defaultColor = Colors.black;

    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: visible
            ? val == null
                ? color ?? _defaultColor.withOpacity(.3)
                : focusColor ?? _defaultColor.withOpacity(.8)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(size / 2),
        border: Border.all(
          color: visible ? borderColor ?? Colors.white : Colors.transparent,
        ),
      ),
      child: val == null
          ? nil
          : AutoSizeText(
              val.toString(),
              style: textStyle ??
                  const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
            ),
    );
  }
}
