import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'notifier.dart';
import 'state.dart';

final notifProvider = StateNotifierProvider<NotifNotifier, NotifState>(
  (ref) => NotifNotifier(),
);
