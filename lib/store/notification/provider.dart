import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'notifier.dart';
import 'state.dart';

final notifProvider = StateNotifierProvider<NotifNotifier, NotifState>(
  (ref) => NotifNotifier(),
);
