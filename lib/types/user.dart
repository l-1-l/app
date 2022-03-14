import 'package:app/types/user_status.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
class IUser with _$IUser {
  const factory IUser({
    required int id,
    required String name,
    String? bio,
    required String gender,
    required String avatar,
    required UserStatus status,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _IUser;

  factory IUser.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$IUserFromJson(json);
}
