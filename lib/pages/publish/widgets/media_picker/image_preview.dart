import 'dart:io';

import 'package:flutter/material.dart';

class MPImagePreview extends StatefulWidget {
  const MPImagePreview(this.file, {Key? key}) : super(key: key);

  final File file;

  @override
  State<MPImagePreview> createState() => _MPImagePreviewState();
}

class _MPImagePreviewState extends State<MPImagePreview> {
  @override
  Widget build(BuildContext context) {
    return Image.file(
      widget.file,
    );
  }
}
