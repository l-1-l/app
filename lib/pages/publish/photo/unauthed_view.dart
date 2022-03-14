import 'package:app/store/photo_permission.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MPUnAuthedView extends ConsumerWidget {
  const MPUnAuthedView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final spacing = MediaQuery.of(context).size.width / 12;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const AutoSizeText('请授权App照片访问权限'),
          SizedBox(height: spacing),
          const AutoSizeText('只有添加了图库，'),
          SizedBox(height: spacing),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(50),
            ),
            onPressed: () {
              ref.read(photoPermissionProvider.notifier).request();
            },
            child: const AutoSizeText('授权'),
          ),
        ],
      ),
    );
  }
}
