import 'package:freezed_annotation/freezed_annotation.dart';

part 'exception.freezed.dart';

@freezed
class NetException with _$NetException {
  const factory NetException.cancelled(
    String message,
  ) = NetCancelException;
  const factory NetException.connectivity() = NetConnectivityException;
  const factory NetException.unauthorized() = NetUnauthorizedException;
  const factory NetException.error(
    String message,
    String code,
  ) = _NetException;
  const factory NetException.message(
    String message,
  ) = _NetMessageException;

  const factory NetException.unknown() = _NetUnknownException;
}
