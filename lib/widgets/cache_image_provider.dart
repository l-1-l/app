import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// @reference https://stackoverflow.com/a/65950055

@immutable
class CacheImageProvider extends ImageProvider<CacheImageProvider> {
  const CacheImageProvider(this.tag, this.img);

  final String tag; //the cache id use to get cache
  final Uint8List img; //the bytes of image to cache

  @override
  ImageStreamCompleter load(CacheImageProvider key, DecoderCallback decode) {
    return MultiFrameImageStreamCompleter(
      codec: _loadAsync(decode),
      scale: 1,
      debugLabel: tag,
      informationCollector: () sync* {
        yield ErrorDescription('Tag: $tag');
      },
    );
  }

  Future<Codec> _loadAsync(DecoderCallback decode) async {
    // the DefaultCacheManager() encapsulation, it get cache from local storage.
    final bytes = img;

    if (bytes.lengthInBytes == 0) {
      // The file may become available later.
      PaintingBinding.instance?.imageCache?.evict(this);
      throw StateError('$tag is empty and cannot be loaded as an image.');
    }

    return decode(bytes);
  }

  @override
  Future<CacheImageProvider> obtainKey(ImageConfiguration configuration) {
    return SynchronousFuture<CacheImageProvider>(this);
  }

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) return false;
    final res = other is CacheImageProvider && other.tag == tag;
    return res;
  }

  @override
  int get hashCode => tag.hashCode;

  @override
  String toString() =>
      '${objectRuntimeType(this, 'CacheImageProvider')}("$tag")';
}