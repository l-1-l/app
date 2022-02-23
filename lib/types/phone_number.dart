import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:isar/isar.dart';

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

class PhoneNumberConverter extends TypeConverter<PhoneNumber, String> {
  const PhoneNumberConverter();

  @override
  fromIsar(String object) =>
      PhoneNumber.fromJson(object as Map<String, dynamic>);

  @override
  toIsar(object) => json.encode(object.toJson());
}
