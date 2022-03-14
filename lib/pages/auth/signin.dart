import 'package:auto_route/auto_route.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:bubble_box/bubble_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phone_numbers_parser/phone_numbers_parser.dart' as mp_parser;

import '../../l10n/l10n.dart';
import '../../router/router.gr.dart';
import '../../store/auth.dart';
import '../../types/otp_receiver.dart';
import '../../types/phone_number.dart';
import '../../widgets/loading.dart';
import '../../widgets/mobile_phone_input/mobile_phone_input.dart';
import 'service_terms.dart';

class SigninPage extends ConsumerStatefulWidget {
  const SigninPage({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SigninState();
}

class _SigninState extends ConsumerState<SigninPage> {
  late final FocusNode _inputNode = FocusNode();
  late final TextEditingController _inputController = TextEditingController();

  late Offset _checkboxPosition = Offset.zero;

  late String dialCode = '86';
  late String phoneNumber = '';

  late bool isValidMobile = false;
  late bool? isAcceptedTerms = false;
  late bool isShowTermsTip = false;
  late bool isShowTermsPleaseTip = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance?.addPostFrameCallback((_) {
      _checkboxPosition = _getCheckboxPosition();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
    _inputController.dispose();
    _inputNode.dispose();
  }

  Offset _getCheckboxPosition() {
    final r = termsCheckboxKey.currentContext?.findRenderObject() as RenderBox?;
    if (r == null) return Offset.zero;
    final position = r.localToGlobal(Offset.zero);
    return Offset(position.dx, position.dy + r.size.height * 0.7);
  }

  void _setIsAcceptedTerms(bool? val) {
    final v = val ?? false;
    setState(() {
      isAcceptedTerms = v;

      if (v) {
        isShowTermsTip = false;
        isShowTermsPleaseTip = false;
        return;
      }

      if (!v && !isShowTermsTip) {
        isShowTermsTip = true;
        isShowTermsPleaseTip = true;
      }
    });
  }

  void _handlePhoneNumberChange(String val) {
    final bottomViewInset = MediaQuery.of(context).viewInsets.bottom;

    if (bottomViewInset > 0) {}

    setState(() {
      phoneNumber = val;
    });
  }

  void _handleSubmit() {
    final isValid = mp_parser.PhoneNumber.fromCountryCode(
      dialCode,
      phoneNumber,
    ).validate(type: mp_parser.PhoneNumberType.mobile);

    if (isAcceptedTerms == null || !isAcceptedTerms!) {
      // _notifNotifier.local('劳驾需要您同意服务条款', icon: false);
      setState(() {
        isShowTermsTip = true;
      });
      return;
    }

    if (!isValid) {
      setState(() {
        isValidMobile = true;
      });
      Future.delayed(const Duration(milliseconds: 300), () {
        setState(() {
          isValidMobile = false;
        });
      });
      return;
    }

    ref
        .read(authProvider.notifier)
        .sendCode(
          OtpReciver.phoneNumber(
            PhoneNumber(prefix: dialCode, mobile: phoneNumber),
          ),
        )
        .then(
      (value) {
        value.maybeWhen(
          sendSmsOk: (isNewAccount, receiver) {
            context.pushRoute(
              AuthVerifyRouter(
                receiver: receiver,
                isNewAccount: isNewAccount,
              ),
            );
          },
          orElse: () {},
        );
      },
    );
  }

  void _handleDialCodeChange(String val) {
    setState(() {
      dialCode = val;
    });
  }

  void _handlePageTap(PointerDownEvent e) {
    if (_inputNode.hasFocus) _inputNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final t = context.l10n;
    final authNotifier = ref.watch(authProvider.notifier);

    return Stack(
      children: [
        Listener(
          onPointerDown: _handlePageTap,
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 3,
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: AutoSizeText(
                          t.authTitle,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AutoSizeText(
                              t.phoneNumber,
                              style: Theme.of(context).textTheme.subtitle2,
                            ),
                            MobilePhoneInput(
                              focusNode: _inputNode,
                              controller: _inputController,
                              dialCode: dialCode,
                              onChange: _handlePhoneNumberChange,
                              onDialCodeChange: _handleDialCodeChange,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: Column(
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Theme.of(context).colorScheme.primary,
                              minimumSize: const Size.fromHeight(48),
                            ),
                            onPressed: _handleSubmit,
                            child: authNotifier.loading || isValidMobile
                                ? const Loader()
                                : AutoSizeText(t.authVerifyCode),
                          ),
                          ServiceTerms(
                            isAccepted: isAcceptedTerms,
                            onChange: _setIsAcceptedTerms,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Positioned(
          top: _checkboxPosition.dy,
          left: _checkboxPosition.dx,
          child: BubbleBox(
            shape: BubbleShapeBorder(
              direction: BubbleDirection.top,
              position: const BubblePosition.start(18),
              arrowQuadraticBezierLength: 2,
            ),
            backgroundColor: isShowTermsTip
                ? Theme.of(context).colorScheme.primary
                : Colors.transparent,
            child: AutoSizeText(
              isShowTermsPleaseTip ? t.needViewTermsPlease : t.needViewTerms,
              style: Theme.of(context).textTheme.caption?.copyWith(
                    color: isShowTermsTip
                        ? Theme.of(context).colorScheme.onPrimary
                        : Colors.transparent,
                  ),
            ),
          ),
        ),
      ],
    );
  }
}
