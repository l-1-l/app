import 'package:freezed_annotation/freezed_annotation.dart';
import 'types.dart';

part 'state.freezed.dart';

@freezed
class NotifState with _$NotifState {
  const factory NotifState.idle() = _Idle;
  const factory NotifState.local(
    String msg, {
    required LocalNotifiType type,
    required bool icon,
    required bool center,
  }) = _Local;
}
