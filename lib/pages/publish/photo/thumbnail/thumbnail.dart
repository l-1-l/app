import 'package:app/widgets/cache_image_provider.dart';
import 'package:app/widgets/serial_badge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../store.dart';

class Thumbnail extends ConsumerWidget {
  const Thumbnail({
    Key? key,
    this.serial,
    this.onTap,
    this.badgeVisible = false,
    this.focus = false,
    this.disable = false,
    required this.media,
  }) : super(key: key);

  final AlbumThumb media;
  final int? serial;
  final bool badgeVisible;
  final bool focus;
  final void Function(AlbumThumb, bool isBadgeTap)? onTap;
  final bool disable;

  void _handleTap() {
    onTap?.call(media, false);
  }

  void _handleBadgeTap() {
    onTap?.call(media, true);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Bounceable(
      onTap: _handleTap,
      child: Stack(
        children: [
          Positioned.fill(
            child: Image(
              image: CacheImageProvider(media.id, media.data),
              fit: BoxFit.cover,
              gaplessPlayback: true,
            ),
          ),
          Positioned.fill(
            child: AnimatedOpacity(
              opacity: focus || disable ? 1 : 0,
              duration: const Duration(milliseconds: 200),
              child: Container(
                decoration: BoxDecoration(
                  color: disable
                      ? Colors.white.withOpacity(.8)
                      : Colors.black.withOpacity(.5),
                ),
              ),
            ),
          ),
          Positioned(
            right: 4,
            top: 4,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              opacity: badgeVisible ? 1.0 : 0.0,
              child: Bounceable(
                onTap: _handleBadgeTap,
                child: SerialBadge(
                  val: serial,
                  visible: badgeVisible,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
