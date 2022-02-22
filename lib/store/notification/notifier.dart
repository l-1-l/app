import 'package:app/store/notification/state.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'types.dart';

class NotifNotifier extends StateNotifier<NotifState> {
  NotifNotifier() : super(const NotifState.idle());

  void set(NotifState next) {
    if (state != next) state = next;
  }

  void idle() {
    set(const NotifState.idle());
  }

  void local(
    String msg, {
    LocalNotifiType type = LocalNotifiType.info,
    bool icon = true,
    bool center = false,
  }) {
    set(NotifState.local(
      msg,
      type: type,
      icon: icon,
      center: center,
    ));
  }
}
