import 'package:flutter/material.dart';

class DragHandle extends StatelessWidget {
  const DragHandle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 10,
      height: 4,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary.withOpacity(.6),
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}
