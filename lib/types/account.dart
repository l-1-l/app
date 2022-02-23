import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:isar/isar.dart';

import 'phone_number.dart';
import 'account_status.dart';

part 'account.freezed.dart';
part 'account.g.dart';

@Freezed(
  unionValueCase: FreezedUnionCase.snake,
)
@Collection()
class Account with _$Account {
  factory Account({
    @Id() int? id_,
    required String id,
    String? userId,
    @PhoneNumberConverter() required final PhoneNumber phoneNumber,
    String? email,
    @AccountStatusConverter() required final AccountStatus status,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _Account;

  factory Account.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$AccountFromJson(json);
}
