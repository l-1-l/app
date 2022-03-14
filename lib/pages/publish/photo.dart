import 'dart:io';

import 'package:app/store/photo_permission.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';

import 'photo/authed_view.dart';
import 'photo/unauthed_view.dart';

class PublishPhotoPage extends ConsumerStatefulWidget {
  const PublishPhotoPage({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PublishPhotoPageState();
}

class _PublishPhotoPageState extends ConsumerState<PublishPhotoPage> {
  @override
  void initState() {
    super.initState();
    PhotoManager.setIgnorePermissionCheck(true);
  }

  Future<bool> isDenied() async {
    if (Platform.isAndroid) return Permission.storage.isDenied;

    final status = await Future.wait([
      Permission.photos.isDenied,
      Permission.photos.isRestricted,
    ]);

    return status[0] || status[1];
  }

  @override
  Widget build(BuildContext context) {
    final permissionStatus = ref.watch(photoPermissionProvider);

    return permissionStatus ? const MPAuthedView() : const MPUnAuthedView();
  }
}
