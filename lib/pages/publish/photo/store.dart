import 'dart:typed_data';
import 'dart:ui';

import 'package:app/store/photo_permission.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:photo_manager/photo_manager.dart';

part 'store.freezed.dart';

final albumProvider = StateNotifierProvider<AlbumNotifier, AlbumState>((ref) {
  final thumbs = IList<AlbumThumb>();
  final medias = IMap<String, AssetEntity>();
  return AlbumNotifier(ref.read, thumbs, medias);
});

class AlbumNotifier extends StateNotifier<AlbumState> {
  AlbumNotifier(
    this._reader,
    IList<AlbumThumb> thumbs,
    IMap<String, AssetEntity> medias,
  ) : super(AlbumState(thumbs: thumbs, medias: medias)) {
    _init();
  }

  final Reader _reader;

  // final _cache = HashMap<String, AlbumMedia>();
  late final double _thumbSize =
      (360 * window.devicePixelRatio).truncateToDouble();
  late final ThumbnailOption _thumbOption = ThumbnailOption.ios(
    size: ThumbnailSize.square(_thumbSize.toInt()),
    quality: 100,
  );

  double get thumbSize => _thumbSize;
  ThumbnailOption get thumbOption => _thumbOption;

  Future<void> _init() async {
    final hasPermission = _reader(photoPermissionProvider);
    if (hasPermission) {
      final paths = await PhotoManager.getAssetPathList(
        type: RequestType.image,
      );

      AssetPathEntity? current;
      IList<AlbumThumb>? thumbs;

      final albums = IMap<String, AssetPathEntity>().unlockLazy;
      final medias = IMap<String, AssetEntity>().unlockLazy;
      final ids = IList<String>().unlockLazy;

      for (final i in paths) {
        if (i.isAll) current = i;
        ids.add(i.id);
        albums[i.id] = i;
      }

      if (current != null) {
        final assets = await current.getAssetListRange(start: 0, end: 24);
        thumbs = await _getThumbsFromAssets(
          assets,
          (asset) => medias[asset.id] = asset,
        );
      }

      state = AlbumState(
        allIds: ids.lock,
        all: albums.lock,
        current: current,
        thumbs: thumbs ?? IList(),
        medias: medias.lock,
        loading: false,
      );
    }
  }

  Future<IList<AlbumThumb>> _getThumbsFromAssets(
    List<AssetEntity> assets, [
    Function(AssetEntity)? cb,
  ]) async {
    final thumbs = IList<AlbumThumb>().unlockLazy;
    final futures = <Future<Uint8List?>>[];

    for (final item in assets) {
      cb?.call(item);
      futures.add(item.thumbnailData);
    }

    // if (preloadAssets.isNotEmpty) {
    final loadedAssets = await Future.wait(futures);

    for (var i = 0; i < loadedAssets.length; i++) {
      final data = loadedAssets[i];
      if (data != null) {
        // final asset = preloadAssets[i];
        final asset = assets[i];
        thumbs.add(
          AlbumThumb(
            id: asset.id,
            type: asset.type,
            data: data,
            duration: asset.duration,
          ),
        );
      }
    }
    // }

    return thumbs.lock;
  }

  void switchAlbum(AssetPathEntity album) {
    state = state.copyWith(
      current: album,
      thumbs: IList(),
    );
  }

  Future<void> loadMore(int lastIndex) async {
    final current = state.current;

    if (!state.loading && current != null) {
      state = state.copyWith(
        loading: true,
      );

      final assets = await current.getAssetListRange(
        start: lastIndex,
        end: lastIndex + 20,
      );

      final thumbs = await _getThumbsFromAssets(assets);

      state = state.copyWith(
        thumbs: state.thumbs.addAll(thumbs),
        loading: false,
      );
    }
  }
}

@freezed
class AlbumThumb with _$AlbumThumb {
  const factory AlbumThumb({
    required String id,
    required AssetType type,
    required Uint8List data,
    @Default(0) int duration,
  }) = _AlbumMedia;
}

@freezed
class AlbumState with _$AlbumState {
  const factory AlbumState({
    AssetPathEntity? current,
    IMap<String, AssetPathEntity>? all,
    IList<String>? allIds,
    required IMap<String, AssetEntity> medias,
    required IList<AlbumThumb> thumbs,
    @Default(true) bool loading,
  }) = _AlbumState;
}
