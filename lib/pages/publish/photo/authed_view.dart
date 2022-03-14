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

  bool isMultiple = false;
  _WorkMode _mode = _WorkMode.initial;

  String? current;
  IList<String> selected = IList();
  late String? _text;

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
      if (isMultiple) {
        selected = IList();
      } else if (current != null) {
        selected = selected.add(current!);
      }

      isMultiple = !isMultiple;
    });
  }

  void _setWorkMode(_WorkMode mode) {
    // if (mode == _WorkMode.text) {
    //   _textEditorNode.requestFocus();
    // } else if (_textEditorNode.hasFocus) {
    //   _textEditorNode.unfocus();
    // }

    setState(() {
      _mode = mode;
    });
  }

  void _handleThumbnailTap(AlbumThumb media, bool isBdgeTap) {
    // final isFocusing = currentMedia != null && currentMedia!.id == media.id;
    final isFocusing = current != null && current == media.id;

    if (!isMultiple) {
      if (isFocusing) return;

      return setState(() {
        current = media.id;
      });
    }
    final tempSelected = selected.unlockLazy;

    final idx = tempSelected.indexWhere((element) => element == media.id);

    setState(() {
      if (idx > -1) {
        if (isFocusing || isBdgeTap) {
          tempSelected.removeAt(idx);
          current = tempSelected.length > 1 ? tempSelected.last : null;
          selected = tempSelected.lock;
          return;
        }

        current = media.id;
        return;
      }

      if (tempSelected.length >= 10) return;

      tempSelected.add(media.id);
      selected = tempSelected.lock;
      current = media.id;
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
        appBar: AppBar(
          centerTitle: true,
          // backgroundColor: Colors.transparent,
          toolbarHeight: 40,
          title: const AutoSizeText('新帖子'),
          leading: const Icon(Iconfont.close_outline),
          actions: [
            InkWell(
              child: Container(
                padding: const EdgeInsets.only(right: 16),
                alignment: Alignment.centerLeft,
                child: const AutoSizeText(
                  '发布',
                ),
              ),
            ),
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Builder(
              builder: (context) {
                if (_mode == _WorkMode.initial || _mode == _WorkMode.photo) {
                  if (current == null) {
                    return Expanded(
                      // aspectRatio: 1,
                      child: _TextEditor(
                        key: const ValueKey('IdleTextEditor'),
                        keyboardType: TextInputType.none,
                        onTap: _handleTextEditorTap,
                        onChange: _handleTextEditorChange,
                      ),
                    );
                  }

                  return Expanded(
                    // aspectRatio: 1,
                    child: _PhotoEditor(
                      key: const ValueKey('PhotoEditor'),
                      cropKey: _cropKey,
                      media: state.medias.get(current!),
                    ),
                  );
                }

                return Expanded(
                  // aspectRatio: 1,
                  child: _TextEditor(
                    key: const ValueKey('TextEditor'),
                    focusNode: _textEditorNode,
                    onChange: _handleTextEditorChange,
                  ),
                );
              },
              // ),
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
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _Icon(
                    Iconfont.photo,
                    data: _WorkMode.photo,
                    onDataTap: _setWorkMode,
                  ),
                  _Icon(
                    Iconfont.note_pencil,
                    data: _WorkMode.text,
                    onDataTap: _setWorkMode,
                  ),
                  AnimatedOpacity(
                    opacity:
                        _mode == _WorkMode.initial || _mode == _WorkMode.photo
                            ? 1
                            : 0,
                    duration: const Duration(milliseconds: 300),
                    child: _Icon<dynamic>(
                      Iconfont.box_multiple,
                      onTap: _setIsMultiple,
                    ),
                  ),
                ],
              ),
            ),
            if (_mode == _WorkMode.initial || _mode == _WorkMode.photo)
              Expanded(
                child: GridView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: state.thumbs.length,
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    mainAxisSpacing: 1,
                    crossAxisSpacing: 1,
                  ),
                  itemBuilder: (context, idx) {
                    if (state.thumbs.isEmpty) return nil;
                    final media = state.thumbs[idx];
                    final serial =
                        selected.indexWhere((element) => element == media.id);

                    final disabled = isMultiple &&
                        selected.length >= 10 &&
                        !selected.any((element) => element == media.id);

                    return Thumbnail(
                      key: ValueKey(media.id),
                      badgeVisible: isMultiple,
                      media: media,
                      focus: media.id == current,
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
    );
  }
}

class _PhotoEditor extends ConsumerStatefulWidget {
  const _PhotoEditor({
    Key? key,
    this.media,
    this.cropKey,
    this.isShowRatioBar = false,
  }) : super(key: key);

  final AssetEntity? media;
  final bool isShowRatioBar;
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
    this.controller,
    this.focusNode,
    this.onChange,
    this.onTap,
    this.readOnly = false,
    this.autofocus = true,
    this.keyboardType,
  }) : super(key: key);

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final void Function(String)? onChange;
  final void Function()? onTap;
  final bool readOnly;
  final bool autofocus;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xff1c1c1e),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextField(
        keyboardType: keyboardType,
        showCursor: true,
        autofocus: autofocus,
        readOnly: readOnly,
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
