import 'package:freezed_annotation/freezed_annotation.dart';

import '../types/phone_number.dart';
import 'account_status.dart';

part 'account.freezed.dart';
part 'account.g.dart';

@Freezed(
  unionValueCase: FreezedUnionCase.snake,
)
class Account with _$Account {
  const factory Account({
    required int id,
    String? userId,
    required PhoneNumber phoneNumber,
    String? email,
    required AccountStatus status,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _Account;

  factory Account.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$AccountFromJson(json);
}
