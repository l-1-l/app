import 'package:app/l10n/l10n.dart';
import 'package:flutter/material.dart';

import '../iconfont.dart';

class SearchBox extends StatelessWidget {
  const SearchBox({
    Key? key,
    this.onChange,
    this.focusNode,
    this.controller,
  }) : super(key: key);

  final FocusNode? focusNode;
  final void Function(String)? onChange;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final hintStyle = theme.inputDecorationTheme.hintStyle;
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: cs.tertiary,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChange,
              focusNode: focusNode,
              style: theme.textTheme.bodyText1,
              decoration: InputDecoration(
                isDense: true,
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
                hintText: context.l10n.search,
              ),
            ),
          ),
          Icon(
            Iconfont.search,
            color: hintStyle?.color,
            size: theme.textTheme.bodyText2?.fontSize,
          )
        ],
      ),
    );
  }
}
