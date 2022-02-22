import 'package:app/widgets/iconfont.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'country_selector.dart';
import 'country_type.dart';

class MobilePhoneInput extends StatelessWidget {
  const MobilePhoneInput({
    Key? key,
    this.hint,
    this.value,
    this.dialCode,
    this.controller,
    this.focusNode,
    this.onChange,
    this.onDialCodeChange,
  }) : super(key: key);

  final String? value;
  final String? hint;
  final String? dialCode;
  final void Function(String)? onChange;
  final void Function(String)? onDialCodeChange;
  final TextEditingController? controller;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isFocus = MediaQuery.of(context).viewInsets.bottom > 0 &&
        (focusNode?.hasFocus ?? false);

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              flex: 1,
              child: InkWell(
                splashColor: Colors.transparent,
                onTap: () {
                  showCupertinoModalBottomSheet(
                    context: context,
                    expand: true,
                    builder: (context) => CountrySelector(
                      controller: ModalScrollController.of(context),
                      onSelected: (ICountry country) {
                        Navigator.of(context).pop();
                        onDialCodeChange?.call(country.dialCode);
                      },
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      AutoSizeText(
                        '+$dialCode',
                        style: Theme.of(context).textTheme.subtitle1?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      Icon(
                        Iconfont.triangle_down,
                        size: 10,
                        color: cs.primary,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: TextField(
                focusNode: focusNode,
                controller: controller,
                keyboardType: TextInputType.phone,
                onChanged: onChange,
                decoration: InputDecoration(
                  // isDense: true,
                  hintText: hint,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 0,
                    vertical: 0,
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 2,
          child: FractionallySizedBox(
            heightFactor: isFocus ? 1 : 0.5,
            child: Container(
              decoration: BoxDecoration(
                color: isFocus ? cs.primary : cs.outline,
                borderRadius: BorderRadius.circular(isFocus ? 1 : 0.5),
              ),
            ),
          ),
        )
      ],
    );
  }
}
