import 'package:flutter/material.dart';

///
class Link extends StatelessWidget {
  ///
  final TextStyle? style;

  ///
  final String value;

  ///
  final void Function()? onTap;

  ///
  const Link(
    this.value, {
    Key? key,
    this.onTap,
    this.style,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      key: key,
      onTap: onTap,
      child: Text(value, style: style),
    );
  }
}
