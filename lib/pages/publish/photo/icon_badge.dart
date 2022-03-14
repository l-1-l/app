import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';

class IconBadge extends StatelessWidget {
  const IconBadge(
    this.icon, {
    Key? key,
    this.margin,
    this.focus = false,
    this.onTap,
  }) : super(key: key);

  final IconData icon;
  final EdgeInsets? margin;
  final bool focus;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Bounceable(
      onTap: onTap,
      child: Container(
        margin: margin,
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: focus ? Colors.white.withOpacity(.3) : Colors.transparent,
          ),
          // color:
          color: Colors.grey.withOpacity(.4),
          // color: Theme.of(context).primaryColor,
        ),
        child: Icon(
          icon,
          size: 22,
          color: Colors.white,
        ),
      ),
    );
  }
}
