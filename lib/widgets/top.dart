import 'package:app/l10n/l10n.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nil/nil.dart';

import '../store/network.dart';
import '../store/notification.dart';
import '../store/preferences.dart';
import 'iconfont.dart';
import 'keyboard_height_observer.dart';

class Top extends ConsumerStatefulWidget {
  const Top(
    this.child,
    this.navigatorKey, {
    Key? key,
  }) : super(key: key);

  final Widget? child;
  final GlobalKey<NavigatorState> navigatorKey;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TopState();
}

class _TopState extends ConsumerState<Top>
    with WidgetsBindingObserver, KeyboardHeightObserver {
  @override
  void onKeyboardOpen(double height) {
    ref.read(preferencesProvider.notifier).setKeyboardHeight(height);
  }

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
                      const Icon(Iconfont.alert_triangle, color: Colors.white),
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
  Widget build(BuildContext context) {
    final notifi = ref.watch(notifProvider.notifier);
    final ctx = widget.navigatorKey.currentContext;

    ref.listen<NotifState>(notifProvider, (previous, next) {
      if (next != previous && ctx != null) {
        next.maybeWhen(
          local: showSnackbar(ctx, (reason) => notifi.idle()),
          orElse: () {},
        );
      }
    });

    // ignore: cascade_invocations
    ref.listen<NetworkState>(networkProvider, (previous, next) {
      if (previous != next && ctx != null) {
        next.maybeWhen(
          off: () {
            notifi.local(ctx.l10n.netError, type: LocalNotifiType.error);
          },
          orElse: () {},
        );
      }
    });

    return widget.child ?? nil;
  }
}
