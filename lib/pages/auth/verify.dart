import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pinput/pinput.dart';

import '../../l10n/l10n.dart';
import '../../router/router.gr.dart';
import '../../store/auth.dart';
import '../../types/otp_receiver.dart';

class AuthVerifyPage extends ConsumerStatefulWidget {
  const AuthVerifyPage({
    Key? key,
    required this.receiver,
    required this.isNewAccount,
  }) : super(key: key);

  final OtpReciver receiver;
  final bool isNewAccount;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AuthVerifyPageState();
}

class _AuthVerifyPageState extends ConsumerState<AuthVerifyPage> {
  late final TapGestureRecognizer resendRecognizer;
  late final TextEditingController inputController;
  late final FocusNode inputNode;

  // late final PinTheme defaultPinTheme;
  // late final PinTheme focusedPinTheme;

  @override
  void initState() {
    super.initState();
    inputNode = FocusNode();
    inputController = TextEditingController();

    resendRecognizer = TapGestureRecognizer()
      ..onTap = () {
        EasyDebounce.debounce(
          'resendDebouncer',
          const Duration(seconds: 3),
          () {
            ref.read(authProvider.notifier).sendCode(widget.receiver);
          },
        );
      };
  }

  @override
  void dispose() {
    super.dispose();
    inputController.dispose();
    resendRecognizer.dispose();
    EasyDebounce.cancel('resendDebouncer');
  }

  Future<void> handleSubmit(String v) async {
    final state = await ref
        .read(authProvider.notifier)
        .signup(widget.receiver, inputController.text);

    state.maybeWhen(
      signed: (current, accounts) {
        context.replaceRoute(const LandingRouter());
      },
      orElse: () {},
    );
  }

  void handleChange(String v) {
    if (v.isNotEmpty && int.tryParse(v) == null || v.contains(' ')) {
      final validCode = v.substring(0, v.length - 1);

      inputController.value = TextEditingValue(
        text: validCode,
        selection: TextSelection.collapsed(offset: validCode.length),
      );
    }

    if (inputController.text.length >= 6) {
      inputNode.unfocus();
      handleSubmit(inputController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = context.l10n;

    final textTheme = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;

    // final defaultPinTheme = PinTheme(
    //   textStyle: const TextStyle(fontSize: 24),
    //   // constraints: const BoxConstraints(
    //   //   maxHeight: 38,
    //   //   maxWidth: 30,
    //   // ),
    //   // decoration: BoxDecoration(
    //   //   border: Border.all(color: cs.outline),
    //   //   borderRadius: BorderRadius.circular(6),
    //   // ),
    // );

    // final focusedPinTheme = defaultPinTheme.copyDecorationWith(
    //   border: Border.all(color: cs.primary),
    // );
    const fillColor = Color.fromRGBO(222, 231, 240, .57);
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 60,
      textStyle: const TextStyle(
        fontSize: 24,
        color: Color.fromRGBO(30, 60, 87, 1),
      ),
      decoration: BoxDecoration(
        color: fillColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.transparent),
      ),
    );

    final address = widget.receiver.when(
      phoneNumber: (mobile) => '+${mobile.prefix} ${mobile.mobile}',
      email: (v) => v,
    );

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            children: [
              Expanded(
                flex: 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    AutoSizeText(
                      t.smsVerifyTitle,
                      style: textTheme.headline5?.copyWith(
                        fontSize: 24,
                      ),
                    ),
                    const SizedBox(height: 8),
                    AutoSizeText(
                      t.smsVerifyTip(address),
                      style: textTheme.caption,
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 3,
                child: Align(
                  child: Pinput(
                    length: 6,
                    autofocus: true,
                    // pinAnimationType: PinAnimationType.fade,
                    focusNode: inputNode,

                    onChanged: handleChange,
                    controller: inputController,
                    // cursor: cursor,
                    defaultPinTheme: defaultPinTheme,
                    // preFilledWidget: preFilledWidget,
                    // followingPinTheme: defaultPinTheme,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    androidSmsAutofillMethod:
                        AndroidSmsAutofillMethod.smsRetrieverApi,
                  ),
                ),
              ),
              Expanded(
                flex: 5,
                child: Align(
                  alignment: Alignment.topCenter,
                  child: AutoSizeText.rich(
                    TextSpan(
                      children: [
                        TextSpan(text: t.smsUnreceived),
                        TextSpan(
                          text: t.smsResend,
                          recognizer: resendRecognizer,
                          style: textTheme.caption?.copyWith(
                            color: cs.primary,
                            decoration: TextDecoration.underline,
                          ),
                        )
                      ],
                    ),
                    style: textTheme.caption,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
