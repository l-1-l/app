import 'package:app/types/phone_number.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'contact_address.g.dart';
part 'contact_address.freezed.dart';

@freezed
class ContactAddress with _$ContactAddress {
  const factory ContactAddress({
    required PhoneNumber phoneNumber,
    String? email,
  }) = _ContactAddress;

  factory ContactAddress.fromJson(Map<String, dynamic> json) =>
      _$ContactAddressFromJson(json);
}
