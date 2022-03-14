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
      // SwipeableBar(
      //   bottom: 20,
      //   children: [
      //     Item("帖子",
      //         key: const ValueKey('posts'),
      //         data: 0,
      //         cursor: cursor,
      //         onTap: handlePageChange),
      //     Item("快拍",
      //         key: const ValueKey('reels'),
      //         data: 1,
      //         cursor: cursor,
      //         onTap: handlePageChange),
      //     Item("文章",
      //         key: const ValueKey('articles'),
      //         data: 2,
      //         cursor: cursor,
      //         onTap: handlePageChange),
      //   ],
      // ),
    );
  }
}

// class SwipeableBar extends StatefulWidget {
//   final double? bottom;
//   final List<Widget> children;

//   const SwipeableBar({
//     Key? key,
//     this.bottom,
//     required this.children,
//   }) : super(key: key);

//   @override
//   State<SwipeableBar> createState() => _SwipeableBarState();
// }

// class _SwipeableBarState extends State<SwipeableBar>
//     with SingleTickerProviderStateMixin {
//   late final AnimationController controller = AnimationController(
//     vsync: this,
//     duration: const Duration(milliseconds: 200),
//   );

//   late double position = 0;
//   double startX = 0;

//   double get tabWidth => (MediaQuery.of(context).size.width * 0.45 - 16) / 3;

//   handleHorizontalDown(DragDownDetails details) {}

//   handleHorizontalUpdate(DragUpdateDetails details) {
//     setState(() {
//       position = details.localPosition.dx;
//     });
//   }

//   void handleMoveStart(MoveEvent event) {
//     setState(() {
//       startX = event.localPos.dx;
//     });
//   }

//   void handleMoveUpdate(MoveEvent event) {
//     final dx = event.localPos.dx;

//     final threshold = tabWidth / 2;
//     var panDx = startX - dx;

//     // right
//     if (dx > startX) {
//       if (panDx >= threshold) {
//         return setState(() {
//           position -= tabWidth;
//         });
//       }
//       return setState(() {
//         position -= panDx;
//       });
//     }

//     // left
//     panDx = dx - startX;
//     if (panDx >= threshold) {
//       return setState(() {
//         position += tabWidth;
//       });
//     }

//     setState(() {
//       position = panDx;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final w = MediaQuery.of(context).size.width;

//     return Positioned(
//       bottom: 20,
//       right: 20,
//       child: Transform.translate(
//         offset: Offset(position, 0),
//         child: XGestureDetector(
//           // onHorizontalDragDown: handleHorizontalDown,
//           onMoveStart: handleMoveStart,
//           onMoveUpdate: handleMoveUpdate,
//           child: Container(
//             width: w * 0.45,
//             padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
//             decoration: BoxDecoration(
//               color: Colors.black.withOpacity(.6),
//               borderRadius: BorderRadius.circular(30),
//             ),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: widget.children,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

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
