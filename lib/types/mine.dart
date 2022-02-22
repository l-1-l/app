import 'package:freezed_annotation/freezed_annotation.dart';

import 'account.dart';
import 'user.dart';

part 'mine.freezed.dart';
part 'mine.g.dart';

@freezed
class Mine with _$Mine {
  const factory Mine({
    required IUser profile,
    required Account account,
    // @Id() int? id,
  }) = _Mine;

  factory Mine.fromJson(Map<String, dynamic> json) => _$MineFromJson(json);
}
