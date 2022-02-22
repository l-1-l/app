import 'package:freezed_annotation/freezed_annotation.dart';

import 'exception.dart';

part 'response.freezed.dart';

@freezed
class NetResponse<T> with _$NetResponse<T> {
  const factory NetResponse.success(T data) = NetSuccess<T>;

  const factory NetResponse.error(
    NetException error,
  ) = NetError;
}
