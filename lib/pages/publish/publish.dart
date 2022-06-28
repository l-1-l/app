import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_tab_bar/library.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'article.dart';
import 'photo.dart';
import 'sound.dart';

class PublishPage extends ConsumerStatefulWidget {
  const PublishPage({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PublishPageState();
}

class _PublishPageState extends ConsumerState<PublishPage> {
  final controller = PageController();
  final CustomTabBarController tabBarController = CustomTabBarController();

  int cursor = 0;

  final pages = [
    const PublishPhotoPage(),
    // const PublishVideoPage(),
    const PublishSoundPage(),
    const PublishArticlePage(),
  ];

  void handlePageChange(int page) {
    controller.jumpToPage(page);
    setState(() {
      cursor = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: controller,
        children: pages,
        // itemBuilder: (BuildContext context, int index) => pages[index],
      ),
    );
  }
}

class Item<T> extends StatelessWidget {
  const Item(
    this.val, {
    Key? key,
    this.onTap,
    this.cursor = 0,
    required this.data,
  }) : super(key: key);

  final String val;
  final int cursor;
  final T data;
  final void Function(T)? onTap;
  void _onTap() {
    onTap?.call(data);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _onTap,
      child: AutoSizeText(
        val,
        style: TextStyle(
          fontSize: 14,
          color: cursor == data ? Colors.white : Colors.grey,
        ),
      ),
    );
  }
}
