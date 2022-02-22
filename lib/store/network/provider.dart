import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'notifier.dart';
import 'state.dart';

final networkProvider = StateNotifierProvider<NetworkNotifier, NetworkState>(
    (ref) => NetworkNotifier(ref));
