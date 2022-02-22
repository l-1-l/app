import 'package:flutter/material.dart';

class Divider extends StatelessWidget {
  const Divider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      width: double.infinity,
      color: Theme.of(context).colorScheme.outline,
    );
  }
}
