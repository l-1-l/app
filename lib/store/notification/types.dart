enum LocalNotifiType {
  info,
  error,
}

typedef SetLocalNotifiType = Null Function(
  String msg, {
  required bool icon,
  required LocalNotifiType type,
  required bool center,
});
