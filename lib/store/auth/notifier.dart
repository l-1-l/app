import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../types/account.dart';
import '../../types/otp_receiver.dart';

import 'repo.dart';
import 'state.dart';

final authProvider = StateNotifierProvider<AuthStateNotifier, AuthState>(
  (ref) => throw UnimplementedError(),
);

class AuthStateNotifier extends StateNotifier<AuthState> {
  AuthStateNotifier(this._reader, AuthState initialState) : super(initialState);

  bool _loading = false;

  final Reader _reader;
  late final AuthRepo _authRepo = _reader(authRepoProvider);

  bool get loading => _loading;

  bool get isAuthenticated => state is AuthSignedState;

  void set(AuthState next) {
    if (state != next) state = next;
  }

  Future<AuthState> sendCode(OtpReciver reciver) async {
    _loading = true;
    state = await _authRepo.sendCode(reciver);
    _loading = false;
    return state;
  }

  Future<AuthState> signup(
    OtpReciver receiver,
    String code,
  ) async {
    return state = await _authRepo.signup(receiver: receiver, code: code);
  }

  void switchAccount(Account account) {
    state.maybeWhen(
      signed: (_, accounts) {
        state = AuthState.signed(current: account, accounts: accounts);
      },
      orElse: () {},
    );
  }
}
