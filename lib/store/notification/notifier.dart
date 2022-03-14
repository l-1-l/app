import 'package:app/store/notification/state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'types.dart';

final notifProvider = StateNotifierProvider<NotifNotifier, NotifState>(
  (ref) => NotifNotifier(),
);

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
    set(
      NotifState.local(
        msg,
        type: type,
        icon: icon,
        center: center,
      ),
    );
  }
}
