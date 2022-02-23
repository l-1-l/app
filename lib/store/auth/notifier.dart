import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../types/otp_receiver.dart';

import 'state.dart';
import 'repo.dart';

final authProvider = StateNotifierProvider<AuthStateNotifier, AuthState>(
  (ref) => AuthStateNotifier(ref.read),
);

class AuthStateNotifier extends StateNotifier<AuthState> {
  final Reader _reader;
  late final AuthRepo _authRepo = _reader(authRepoProvider);

  AuthStateNotifier(this._reader) : super(const AuthState.initial());

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
