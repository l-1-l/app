import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../types/otp_receiver.dart';
import '../../types/account.dart';

import 'state.dart';
import 'repo.dart';

final accountProvider = Provider<Account?>((_) => null);

final authProvider = StateNotifierProvider<AuthStateNotifier, AuthState>(
  (ref) {
    final account = ref.watch(accountProvider);
    return AuthStateNotifier(
      ref.read,
      account == null ? const AuthState.initial() : AuthState.signed(account),
    );
  },
);

class AuthStateNotifier extends StateNotifier<AuthState> {
  final Reader _reader;
  late final AuthRepo _authRepo = _reader(authRepoProvider);

  AuthStateNotifier(this._reader, AuthState initialState) : super(initialState);

  bool get loading => state == const AuthState.loading();

  bool get isAuthenticated => state is AuthSignedState;

  void set(AuthState next) {
    if (state != next) state = next;
  }

  void setLoading() {
    set(const AuthState.loading());
  }

  Future<AuthState> sendCode(OtpReciver reciver) async {
    set(const AuthState.loading());
    state = await _authRepo.sendCode(reciver);
    return state;
  }

  Future<void> signup(
    OtpReciver receiver,
    String code,
  ) async {
    await _authRepo.signup(receiver: receiver, code: code);
  }
}
