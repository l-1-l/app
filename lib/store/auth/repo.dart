import 'dart:async';
import 'dart:convert';

import 'package:app/store/db.dart';
import 'package:app/types/auth_token.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';

import '../../types/account.dart';
import '../token/repository.dart';
import '../../types/otp_receiver.dart';
import '../../net/net.dart';

import 'state.dart';

enum AuthenticationStatus {
  unknown,
  authenticated,
  unauthenticated,
}

final authRepoProvider = Provider<AuthRepo>(
  (ref) => AuthRepo(ref.read),
);

class AuthRepo {
  late final AuthTokenRepository tokenRepo = AuthTokenRepository();
  late final NetClient net = _reader(netProvider);
  late final Isar isar = _reader(isarProvider);
  final Reader _reader;

  AuthRepo(this._reader);

  Map<String, dynamic> _receiverToJson(OtpReciver r) => r.when(
        phoneNumber: (mobile) => {'phone_number': mobile.toJson()},
        email: (email) => {'email': email},
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
      error: (e) => AuthState.error(e),
    );
  }

  Future<void> signup({
    required OtpReciver receiver,
    required String code,
  }) async {
    var payload = _receiverToJson(receiver);

    payload['code'] = code;

    final res = await net.post<Map<String, dynamic>>(
      API.signup,
      json.encode(payload),
    );
    res.when(
        success: (data) async {
          final account = Account.fromJson(data['account']);
          final token =
              AuthToken(accessToken: data['token'] as String, refreshToken: '');

          await isar.writeTxn((isar) async {
            final id = isar.accounts.put(account);
          });

          tokenRepo.save(token);
        },
        error: (e) {});
  }
}
