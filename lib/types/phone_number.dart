import 'package:freezed_annotation/freezed_annotation.dart';

part 'phone_number.g.dart';
part 'phone_number.freezed.dart';

@freezed
class PhoneNumber with _$PhoneNumber {
  const factory PhoneNumber({
    required String prefix,
    required String mobile,
  }) = _PhoneNumber;

  factory PhoneNumber.fromJson(Map<String, dynamic> json) =>
      _$PhoneNumberFromJson(json);
}
