import 'dart:async';
import 'dart:convert';

import 'package:app/store/db.dart';
import 'package:app/types/auth_token.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sembast/sembast.dart';

import '../../net/net.dart';
import '../../types/account.dart';
import '../../types/otp_receiver.dart';

import 'notifier.dart';
import 'state.dart';

enum AuthenticationStatus {
  unknown,
  authenticated,
  unauthenticated,
}

final authRepoProvider = Provider<AuthRepo>(
  (ref) {
    final net = ref.watch(netProvider);
    final db = ref.watch(dbProvider);
    final authState = ref.watch(authProvider);

    return AuthRepo(net, db, authState);
  },
);

class AuthRepo {
  AuthRepo(this.net, this.db, this.authState);

  late final NetClient net;
  late final Database db;
  late final AuthState authState;

  static final StoreRef<String, Map<String, dynamic>> accountsTable =
      stringMapStoreFactory.store('accounts');

  // https://github.com/dart-lang/sdk/issues/31013
  Map<String, dynamic> _receiverToJson(OtpReciver r) => r.when(
        phoneNumber: (mobile) {
          final pn = {'phone_number': mobile.toJson()};
          return pn;
        },
        email: (email) {
          final e = {'email': email};
          return e;
        },
      );

  Future<AuthState> sendCode(
    OtpReciver receiver,
  ) async {
    final payload = _receiverToJson(receiver);

    final res = await net.post<Map<String, dynamic>>(
      API.authCode,
      json.encode(payload),
    );

    return res.when(
      success: (data) {
        final isNewAccount = data['is_new'] as bool;

        return AuthState.sendSmsOk(
          isNewAccount: isNewAccount,
          receiver: receiver,
        );
      },
      error: AuthState.error,
    );
  }

  Future<AuthState> signup({
    required OtpReciver receiver,
    required String code,
  }) async {
    final payload = Map<String, dynamic>.from(
      _receiverToJson(receiver),
    );

    payload['code'] = code;

    final res = await net.post<Map<String, dynamic>>(
      API.signup,
      json.encode(payload),
    );

    return res.when(
      success: (data) async {
        final token =
            AuthToken(accessToken: data['token'] as String, refreshToken: '');
        final account =
            Account.fromJson(data['account'] as Map<String, dynamic>)
              ..copyWith(token: token);

        await accountsTable.record(account.id).put(db, account.toJson());

        return authState.maybeWhen(
          signed: (current, accounts) {
            return AuthState.signed(
              current: current,
              accounts: accounts.add(current),
            );
          },
          orElse: () {
            return AuthState.signed(
              current: account,
              accounts: [account].lock,
            );
          },
        );
      },
      error: AuthState.error,
    );
  }
}
