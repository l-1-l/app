// ignore_for_file: constant_identifier_names, invalid_annotation_target

// import 'package:freezed_annotation/freezed_annotation.dart';

// @JsonSerializable(fieldRename: FieldRename.pascal)
enum AccountStatus {
  // @JsonValue('DeregisteringBlack')
  DeregisteringBlack,
  // @JsonValue('Deregistering')
  Deregistering,
  // @JsonValue('Frozen')
  Frozen,
  // @JsonValue('Locked')
  Locked,
  // @JsonValue('Stagged')
  Stagged,
  // @JsonValue('ActiveBlack')
  ActiveBlack,
  // @JsonValue('Active')
  Active,
  Empty,
}
