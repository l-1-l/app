import 'package:app/l10n/l10n.dart';
import 'package:app/store/auth/auth.dart';
import 'package:app/types/otp_receiver.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../widgets/loading.dart';

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
  late final AuthStateNotifier authNotifier;
  late final TapGestureRecognizer resendRecognizer;
  late bool isInvalidCode;

  @override
  void initState() {
    super.initState();
    isInvalidCode = false;
    authNotifier = ref.read(authProvider.notifier);
    resendRecognizer = TapGestureRecognizer()
      ..onTap = () {
        EasyDebounce.debounce(
          "resendDebouncer",
          const Duration(seconds: 3),
          () => authNotifier.sendCode(widget.receiver),
        );
      };
  }

  @override
  void dispose() {
    super.dispose();
    resendRecognizer.dispose();
    EasyDebounce.cancel("resendDebouncer");
  }

  handleSubmit(String v) {
    if (int.tryParse(v) == null) {
      setState(() {
        isInvalidCode = true;
      });
      Future.delayed(const Duration(milliseconds: 600), () {
        setState(() {
          isInvalidCode = false;
        });
      });
    }
  }

  handleChange(String v) {}

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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PinCodeTextField(
                      length: 6,
                      autoFocus: true,
                      appContext: context,
                      showCursor: false,
                      useHapticFeedback: true,
                      textStyle: const TextStyle(fontSize: 24),
                      animationCurve: Curves.easeInOut,
                      animationType: AnimationType.scale,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      pinTheme: PinTheme(
                        shape: PinCodeFieldShape.box,
                        borderWidth: 1,
                        borderRadius: BorderRadius.circular(4),
                        fieldHeight: 38,
                        fieldWidth: 30,
                        selectedFillColor: cs.outline,
                        selectedColor: cs.primary.withOpacity(.6),
                        inactiveFillColor: cs.outline,
                        inactiveColor: cs.outline,
                        activeFillColor: cs.outline,
                        activeColor: cs.outline,
                      ),
                      keyboardType: TextInputType.number,
                      onCompleted: handleSubmit,
                      onChanged: handleChange,
                    ),
                    AutoSizeText.rich(
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
                  ],
                ),
              ),
              Expanded(
                flex: 5,
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Loader(
                    color: authNotifier.loading || isInvalidCode
                        ? cs.primary
                        : Colors.transparent,
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
