import 'package:freezed_annotation/freezed_annotation.dart';

import 'phone_number.dart';

part 'otp_receiver.freezed.dart';

@freezed
class OtpReciver with _$OtpReciver {
  const factory OtpReciver.phoneNumber(PhoneNumber phoneNumber) = _PhoneNumber;
  const factory OtpReciver.email(String email) = _Email;
}
