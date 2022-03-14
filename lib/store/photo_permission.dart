import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';

final photoPermissionProvider =
    StateNotifierProvider<PhotoPermissionNotifier, bool>(
  (_) => PhotoPermissionNotifier(),
);

class PhotoPermissionNotifier extends StateNotifier<bool> {
  PhotoPermissionNotifier() : super(false) {
    check();
  }

  Future<void> check() async {
    if (Platform.isAndroid) {
      state = await Permission.storage.isGranted;
      return;
    }

    state = await Permission.photos.isGranted;
  }

  Future<void> request() async {
    if (Platform.isAndroid) {
      state = await Permission.storage.request() == PermissionStatus.granted;
      return;
    }

    final status = await Permission.photos.request();

    state = status == PermissionStatus.granted ||
        status == PermissionStatus.limited;
  }
}
