import 'package:app/net/exception.dart';
import 'package:app/types/otp_receiver.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../types/account.dart';

part 'state.freezed.dart';

// 验证手机
// 登录
//

@freezed
class AuthState with _$AuthState {
  const factory AuthState.initial() = _Initial;

  const factory AuthState.loading() = _Loading;
  const factory AuthState.sendSmsOk({
    required bool isNewAccount,
    required OtpReciver receiver,
  }) = _SendSmsOk;
  const factory AuthState.signed(Account account) = AuthSignedState;

  const factory AuthState.error(
    NetException error,
  ) = _Error;
}
