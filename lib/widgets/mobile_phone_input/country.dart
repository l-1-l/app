import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'country_type.dart';

class Country extends StatelessWidget {
  final ICountry country;
  final void Function(ICountry)? onTap;

  const Country({
    Key? key,
    required this.country,
    required this.onTap,
  }) : super(key: key);

  void _handleTap() {
    onTap?.call(country);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: _handleTap,
      child: Container(
        margin: const EdgeInsets.only(top: 8),
        padding: const EdgeInsets.only(
          bottom: 8,
        ),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: theme.colorScheme.outline,
              width: 0.5,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AutoSizeText(
              country.name,
              style: theme.textTheme.bodyText2,
            ),
            AutoSizeText("+ ${country.dialCode}",
                style: theme.textTheme.bodyText1),
          ],
        ),
      ),
    );
  }
}
