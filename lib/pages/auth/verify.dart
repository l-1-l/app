import 'package:auto_route/auto_route.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pinput/pin_put/pin_put.dart';

import '../../router/router.gr.dart';
import '../../l10n/l10n.dart';
import '../../store/auth.dart';
import '../../types/otp_receiver.dart';

class AuthVerifyPage extends ConsumerStatefulWidget {
  final OtpReciver receiver;
  final bool isNewAccount;

  const AuthVerifyPage({
    Key? key,
    required this.receiver,
    required this.isNewAccount,
  }) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AuthVerifyPageState();
}

class _AuthVerifyPageState extends ConsumerState<AuthVerifyPage> {
  late final TapGestureRecognizer resendRecognizer;
  late final TextEditingController inputController;
  late final FocusNode inputNode;
  // late final

  @override
  void initState() {
    super.initState();
    inputNode = FocusNode();
    inputController = TextEditingController();

    resendRecognizer = TapGestureRecognizer()
      ..onTap = () {
        EasyDebounce.debounce(
          "resendDebouncer",
          const Duration(seconds: 3),
          () {
            final authNotifier = ref.read(authProvider.notifier);
            authNotifier.sendCode(widget.receiver);
          },
        );
      };
  }

  @override
  void dispose() {
    super.dispose();
    inputController.dispose();
    resendRecognizer.dispose();
    EasyDebounce.cancel("resendDebouncer");
  }

  handleSubmit(String v) async {
    final auth = ref.read(authProvider.notifier);

    await auth.signup(widget.receiver, inputController.text);
    context.replaceRoute(const LandingRouter());
  }

  handleChange(String v) {
    if (v.isNotEmpty && int.tryParse(v) == null || v.contains(' ')) {
      var validCode = v.substring(0, v.length - 1);

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

  BoxDecoration get _pinPutDecoration {
    return BoxDecoration(
      border: Border.all(color: Theme.of(context).colorScheme.outline),
      borderRadius: BorderRadius.circular(6),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = context.l10n;

    final textTheme = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;

    final address = widget.receiver.when(
      phoneNumber: (mobile) => "+${mobile.prefix} ${mobile.mobile}",
      email: (v) => v,
    );

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
      ),
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisSize: MainAxisSize.max,
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
                  alignment: Alignment.center,
                  child: PinPut(
                    fieldsCount: 6,
                    autofocus: true,
                    focusNode: inputNode,
                    controller: inputController,
                    keyboardType: TextInputType.number,
                    onChanged: handleChange,
                    pinAnimationType: PinAnimationType.scale,
                    fieldsAlignment: MainAxisAlignment.spaceEvenly,
                    textStyle: const TextStyle(fontSize: 24),
                    eachFieldConstraints: const BoxConstraints(
                      maxHeight: 38,
                      maxWidth: 30,
                    ),
                    submittedFieldDecoration: _pinPutDecoration.copyWith(
                        // borderRadius: BorderRadius.circular(20.0),
                        ),
                    selectedFieldDecoration: _pinPutDecoration.copyWith(
                      border: Border.all(color: cs.primary),
                    ),
                    followingFieldDecoration: _pinPutDecoration.copyWith(
                      border: Border.all(
                        color: cs.outline,
                      ),
                    ),
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
