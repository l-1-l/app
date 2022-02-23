import 'package:app/store/auth/auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'store.freezed.dart';

@freezed
class BootState with _$BootState {
  const factory BootState.initial() = _Initial;
  const factory BootState.unauthenticated() = Unauthenticated;
  const factory BootState.authenticated() = Authenticated;
}

class BootNotifier extends StateNotifier<BootState> {
  BootNotifier(BootState initlizeState) : super(initlizeState) {
    _init();
  }

  Future<void> _init() async {}
}

final bootProvider = StateNotifierProvider<BootNotifier, BootState>((ref) {
  final authState = ref.watch(authProvider);
  final initlizeState = authState.maybeWhen(
    signed: (user) => const BootState.authenticated(),
    orElse: () => const BootState.unauthenticated(),
  );

  return BootNotifier(initlizeState);
});
