import 'package:flutter/material.dart';
import 'package:app/l10n/l10n.dart';
import '../iconfont.dart';

class SearchBox extends StatelessWidget {
  final FocusNode? focusNode;
  final void Function(String)? onChange;
  final TextEditingController? controller;

  const SearchBox({
    Key? key,
    this.onChange,
    this.focusNode,
    this.controller,
  }) : super(key: key);

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
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 0,
                  vertical: 0,
                ),
                hintText: context.l10n.search,
              ),
            ),
          ),
          Icon(
            Iconfont.search_line,
            color: hintStyle?.color,
            size: theme.textTheme.bodyText2?.fontSize,
          )
        ],
      ),
    );
  }
}
