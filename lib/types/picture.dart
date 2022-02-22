import 'package:freezed_annotation/freezed_annotation.dart';

part 'picture.freezed.dart';
part 'picture.g.dart';

@freezed
class IPicture with _$IPicture {
  factory IPicture({
    required String url,
    String? blurhash,
  }) = _IPicture;

  factory IPicture.fromJson(Map<String, dynamic> json) =>
      _$IPictureFromJson(json);
}
