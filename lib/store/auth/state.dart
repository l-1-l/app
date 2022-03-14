import 'package:app/net/exception.dart';
import 'package:app/types/otp_receiver.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sembast/sembast.dart';

import '../../types/account.dart';
import 'repo.dart';

part 'state.freezed.dart';

@freezed
class AuthState with _$AuthState {
  const factory AuthState.initial() = _Initial;

  const factory AuthState.sendSmsOk({
    required bool isNewAccount,
    required OtpReciver receiver,
  }) = _SendSmsOk;
  const factory AuthState.signed({
    required Account current,
    required IList<Account> accounts,
  }) = AuthSignedState;

  const factory AuthState.error(
    NetException error,
  ) = _Error;

  static Future<AuthState> fromDb(Database db) async {
    final accounts = await AuthRepo.accountsTable
        .query()
        .onSnapshots(db)
        .map(
          (snapshot) => snapshot
              .map(
                (account) => Account.fromJson(account.value),
              )
              .toList(),
        )
        .first;

    if (accounts.isEmpty) return const AuthState.initial();

    return AuthState.signed(
      current: accounts.firstWhere((account) => account.isCurrent),
      accounts: accounts.lock,
    );
  }
}
