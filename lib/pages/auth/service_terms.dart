import 'package:app/l10n/l10n.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

final GlobalKey termsCheckboxKey = GlobalKey();

class ServiceTerms extends StatefulWidget {
  const ServiceTerms({
    Key? key,
    this.isAccepted,
    this.onChange,
  }) : super(key: key);

  final bool? isAccepted;
  final void Function(bool?)? onChange;

  @override
  State<ServiceTerms> createState() => _ServiceTermsState();
}

class _ServiceTermsState extends State<ServiceTerms> {
  late final TapGestureRecognizer serviceTermsRecognizer;
  late final TapGestureRecognizer privacyPolicyRecognizer;
  @override
  void initState() {
    super.initState();
    serviceTermsRecognizer = TapGestureRecognizer()
      ..onTap = handleOpenLink('serviceTerms');

    privacyPolicyRecognizer = TapGestureRecognizer()
      ..onTap = handleOpenLink('privacyPolicy');
  }

  void Function() handleOpenLink(String page) => () {
        // TODO: Privacy policy and terms of service
        return;
      };

  @override
  void dispose() {
    super.dispose();
    serviceTermsRecognizer.dispose();
    privacyPolicyRecognizer.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = context.l10n;
    final cs = Theme.of(context).colorScheme;
    return Row(
      children: [
        SizedBox(
          key: termsCheckboxKey,
          child: Transform.scale(
            scale: .6,
            child: Checkbox(
              value: widget.isAccepted,
              activeColor: cs.primary,
              splashRadius: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(2),
              ),
              onChanged: widget.onChange,
            ),
          ),
        ),
        Expanded(
          child: AutoSizeText.rich(
            TextSpan(
              children: [
                TextSpan(text: '${t.authTerms}《'),
                TextSpan(
                  text: t.privacyPolicy,
                  style: TextStyle(
                    color: cs.primary,
                    decoration: TextDecoration.underline,
                  ),
                  recognizer: privacyPolicyRecognizer,
                ),
                TextSpan(text: '》${t.and}《'),
                TextSpan(
                  text: t.serviceTerms,
                  style: TextStyle(
                    color: cs.primary,
                    decoration: TextDecoration.underline,
                  ),
                  recognizer: serviceTermsRecognizer,
                ),
                const TextSpan(text: '》'),
              ],
            ),
            style: Theme.of(context).textTheme.caption,
            maxLines: 2,
          ),
        ),
      ],
    );
  }
}
