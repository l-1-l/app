import 'package:app/store/preferences/notifier.dart';
import 'package:app/widgets/iconfont.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_crop/image_crop.dart';
import 'package:nil/nil.dart';
import 'package:photo_manager/photo_manager.dart';

import 'store.dart';
import 'thumbnail/thumbnail.dart';

enum _WorkMode { text, photo, initial }

class MPAuthedView extends ConsumerStatefulWidget {
  const MPAuthedView({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MPAuthedViewState();
}

class _MPAuthedViewState extends ConsumerState<MPAuthedView> {
  final GlobalKey _cropKey = GlobalKey();
  final FocusNode _textEditorNode = FocusNode();

  bool _isMultiple = false;
  _WorkMode _mode = _WorkMode.initial;
  late double _keyboardHeight;

  String? _currentMedia;
  IList<String> _selectedMedias = IList();

  late String? _text;

  @override
  void initState() {
    _keyboardHeight = ref.read(keybaordHeightProvider);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _handleTextEditorChange(String val) {
    setState(() {
      _text = val;
    });
  }

  void _handleTextEditorTap() {
    setState(() {
      _mode = _WorkMode.text;
    });
  }

  void _setIsMultiple() {
    setState(() {
      if (_isMultiple) {
        _selectedMedias = IList();
      } else if (_currentMedia != null) {
        _selectedMedias = _selectedMedias.add(_currentMedia!);
      }

      _isMultiple = !_isMultiple;
    });
  }

  void _setWorkMode(_WorkMode mode) {
    setState(() {
      _mode = mode;
    });
  }

  void _handleThumbnailTap(AlbumThumb media, bool isBdgeTap) {
    final isFocusing = _currentMedia != null && _currentMedia == media.id;

    if (!_isMultiple) {
      if (isFocusing) return;

      return setState(() {
        _mode = _WorkMode.photo;
        _currentMedia = media.id;
      });
    }
    final tempSelected = _selectedMedias.unlockLazy;

    final idx = tempSelected.indexWhere((element) => element == media.id);

    setState(() {
      _mode = _WorkMode.photo;
      if (idx > -1) {
        if (isFocusing || isBdgeTap) {
          tempSelected.removeAt(idx);
          _currentMedia = tempSelected.length > 1 ? tempSelected.last : null;
          _selectedMedias = tempSelected.lock;
          return;
        }

        _currentMedia = media.id;
        return;
      }

      if (tempSelected.length >= 10) return;

      tempSelected.add(media.id);
      _selectedMedias = tempSelected.lock;
      _currentMedia = media.id;
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(albumProvider);

    return Theme(
      data: Theme.of(context).copyWith(
        scaffoldBackgroundColor: const Color(0xff1d1d1d),
        appBarTheme: AppBarTheme(
          backgroundColor: const Color(0xff1d1d1d),
          systemOverlayStyle: SystemUiOverlayStyle.light.copyWith(
            statusBarColor: const Color(0xff1d1d1d),
          ),
        ),
      ),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          centerTitle: true,
          toolbarHeight: 38,
          title: const AutoSizeText(
            '新帖子',
          ),
        ),
        body: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: Builder(
                        builder: (context) {
                          if (_mode == _WorkMode.initial ||
                              _mode == _WorkMode.photo) {
                            if (_currentMedia == null) {
                              return _TextEditor(
                                key: const ValueKey('IdleTextEditor'),
                                keyboardType: TextInputType.none,
                                onTap: _handleTextEditorTap,
                                onChange: _handleTextEditorChange,
                              );
                            }

                            return _PhotoEditor(
                              key: const ValueKey('PhotoEditor'),
                              cropKey: _cropKey,
                              media: state.medias.get(_currentMedia!),
                            );
                          }

                          return _TextEditor(
                            key: const ValueKey('TextEditor'),
                            focusNode: _textEditorNode,
                            onChange: _handleTextEditorChange,
                          );
                        },
                        // ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(
                            color: Colors.grey.withOpacity(.3),
                            width: 0.1,
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          _Icon(
                            Iconfont.photo,
                            data: _WorkMode.photo,
                            onDataTap: _setWorkMode,
                          ),
                          _Icon<dynamic>(
                            Iconfont.box_multiple,
                            onTap: _setIsMultiple,
                          ),
                          const Expanded(child: SizedBox()),
                          _Icon(
                            Iconfont.note_pencil,
                            data: _WorkMode.text,
                            onDataTap: _setWorkMode,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: _keyboardHeight,
                      child: GridView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: state.thumbs.length,
                        shrinkWrap: true,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          mainAxisSpacing: 1,
                          crossAxisSpacing: 1,
                        ),
                        itemBuilder: (context, idx) {
                          if (state.thumbs.isEmpty) return nil;
                          final media = state.thumbs[idx];
                          final serial = _selectedMedias
                              .indexWhere((element) => element == media.id);

                          final disabled = _isMultiple &&
                              _selectedMedias.length >= 10 &&
                              !_selectedMedias
                                  .any((element) => element == media.id);

                          return Thumbnail(
                            key: ValueKey(media.id),
                            badgeVisible: _isMultiple,
                            media: media,
                            focus: media.id == _currentMedia,
                            serial: serial > -1 ? serial + 1 : null,
                            disable: disabled,
                            onTap: _handleThumbnailTap,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PhotoEditor extends ConsumerStatefulWidget {
  const _PhotoEditor({
    Key? key,
    this.media,
    this.cropKey,
    // this.isShowRatioBar = false,
  }) : super(key: key);

  final AssetEntity? media;
  // final bool isShowRatioBar;
  final GlobalKey? cropKey;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MediaCropState();
}

class _MediaCropState extends ConsumerState<_PhotoEditor> {
  Size? aspectRatio;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didUpdateWidget(_PhotoEditor oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.media == null) return nil;
    // final dpr = MediaQuery.of(context).devicePixelRatio;
    // 11 169 43  32

    return Crop(
      key: widget.cropKey,
      aspectRatio: 1,
      fixed: true,
      image: AssetEntityImageProvider(
        widget.media!,
        thumbnailSize: ThumbnailSize(
          (widget.media!.orientatedWidth),
          (widget.media!.orientatedHeight),
        ),
      )..evict(),
    );
  }
}

class _TextEditor extends StatelessWidget {
  const _TextEditor({
    Key? key,
    this.focusNode,
    this.onChange,
    this.onTap,
    this.keyboardType,
  }) : super(key: key);

  final FocusNode? focusNode;
  final void Function(String)? onChange;
  final void Function()? onTap;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xff1c1c1e),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextField(
        keyboardType: keyboardType,
        showCursor: true,
        autofocus: true,
        focusNode: focusNode,
        onTap: onTap,
        onChanged: onChange,
        cursorRadius: const Radius.circular(2),
        expands: true,
        maxLines: null,
        scrollPhysics: const BouncingScrollPhysics(),
        decoration: const InputDecoration(
          border: InputBorder.none,
        ),
        style: const TextStyle(
          color: Color(0xffcfcfcf),
        ),
        cursorColor: Theme.of(context).primaryColor,
      ),
    );
  }
}

class _Icon<T> extends StatelessWidget {
  const _Icon(
    this.icon, {
    Key? key,
    this.onDataTap,
    this.onTap,
    this.data,
    this.focus = false,
  }) : super(key: key);

  final IconData icon;
  final T? data;
  final void Function(T)? onDataTap;
  final void Function()? onTap;
  final bool focus;

  // ignore: null_check_on_nullable_type_parameter
  void _onTap() => data == null ? onTap?.call() : onDataTap?.call(data!);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _onTap,
      splashColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.only(left: 8, top: 8, bottom: 8),
        child: Icon(
          icon,
          color:
              focus ? Theme.of(context).primaryColor : const Color(0xffcfcfcf),
          size: 28,
        ),
      ),
    );
  }
}
