// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

//  'name': 'الجزائر',
//   'code': 'DZ',
//   'countryName': 'Algeria',
//   'dialCode': '213'

part 'country_type.freezed.dart';
part 'country_type.g.dart';

@freezed
class ICountry with _$ICountry {
  const factory ICountry({
    required String name,
    required String code,
    @JsonKey(name: 'nativeName') required String nativeName,
    @JsonKey(name: 'countryName') required String countryName,
    @JsonKey(name: 'dialCode') required String dialCode,
  }) = _ICountry;

  factory ICountry.fromJson(Map<String, dynamic> json) =>
      _$ICountryFromJson(json);
}
