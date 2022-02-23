import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'notifier.dart';
import 'state.dart';

final networkProvider = StateNotifierProvider<NetworkNotifier, NetworkState>(
    (ref) => NetworkNotifier(ref));
