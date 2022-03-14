import 'package:freezed_annotation/freezed_annotation.dart';

import 'account_status.dart';
import 'auth_token.dart';
import 'phone_number.dart';

part 'account.freezed.dart';
part 'account.g.dart';

@freezed
class Account with _$Account {
  factory Account({
    // ignore: invalid_annotation_target
    required String id,
    String? userId,
    required final PhoneNumber phoneNumber,
    String? email,
    required final AccountStatus status,
    @Default(AuthToken()) AuthToken token,
    @Default(true) bool isCurrent,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _Account;

  factory Account.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$AccountFromJson(json);
}
