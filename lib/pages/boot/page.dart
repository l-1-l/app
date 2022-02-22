import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../l10n/l10n.dart';
import '../../pages/auth/signin.dart';
import '../../pages/landing.dart';
import '../../store/network/provider.dart';
import '../../store/network/state.dart';
import '../../store/notification/notification.dart';
import '../../widgets/iconfont.dart';
import '../../widgets/loading.dart';

import 'store.dart';

class BootPage extends HookConsumerWidget {
  const BootPage({Key? key}) : super(key: key);

  Null Function(
    String msg,
    LocalNotifiType type,
    bool icon,
    bool center,
  ) showSnackbar(
    BuildContext context,
    void Function(SnackBarClosedReason) onClosed,
  ) =>
      (msg, type, icon, center) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..removeCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              duration: const Duration(milliseconds: 3000),
              backgroundColor: type == LocalNotifiType.info
                  ? Theme.of(context).colorScheme.primary.withOpacity(.9)
                  : const Color(0xFFFF3351),
              content: WillPopScope(
                onWillPop: () async {
                  ScaffoldMessenger.of(context).removeCurrentSnackBar();
                  return true;
                },
                child: Row(
                  mainAxisAlignment: center
                      ? MainAxisAlignment.center
                      : MainAxisAlignment.start,
                  children: [
                    if (icon)
                      const Icon(Iconfont.waring_line, color: Colors.white),
                    if (icon) const SizedBox(width: 12),
                    AutoSizeText(
                      msg,
                      style: Theme.of(context).textTheme.bodyText1?.copyWith(
                            color: Colors.white,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ).closed.then(onClosed);
      };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.l10n;
    final boot = ref.watch(bootProvider);
    final notifi = ref.read(notifProvider.notifier);

    final showSnackbarCallback =
        useCallback(showSnackbar(context, (reason) => notifi.idle()), []);

    ref.listen<NotifState>(notifProvider, (previous, next) {
      if (next != previous) {
        next.maybeWhen(local: showSnackbarCallback, orElse: () {});
      }
    });

    ref.listen<NetworkState>(networkProvider, (previous, next) {
      next.maybeWhen(
        off: () {
          notifi.local(t.netError, type: LocalNotifiType.error);
        },
        orElse: () {},
      );
    });

    return boot.maybeWhen(
      authenticated: () => const LandingPage(),
      unauthenticated: () => const SigninPage(),
      orElse: () => const Loader(
        color: Colors.black,
      ),
    );
  }
}
