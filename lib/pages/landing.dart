import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';

import '../l10n/l10n.dart';
import '../router/router.gr.dart';
import '../widgets/iconfont.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  late bool isShowPublish = false;
  @override
  void initState() {
    super.initState();
  }

  // ignore: avoid_positional_boolean_parameters
  void onPublishTap(bool prev) {
    setState(() {
      isShowPublish = !prev;
    });

    if (!prev) {
      context.router.navigate(const PublishRouter());
      // TODO: find a better way.
      Future.delayed(
        const Duration(milliseconds: 200),
        () => setState(() => isShowPublish = false),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = context.l10n;

    return AutoTabsScaffold(
      routes: const [
        HomeRouter(),
        ExploreRouter(),
        MessagingRouter(),
        AccountRouter(),
      ],
      bottomNavigationBuilder: (context, tabsRouter) {
        final cursor = tabsRouter.activeIndex;
        final onTap = tabsRouter.setActiveIndex;

        return BottomAppBar(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              NavBarItem(
                index: 0,
                tip: t.home,
                cursor: cursor,
                icon: Iconfont.home_line,
                activeIcon: Iconfont.home_fill,
                onTap: onTap,
              ),
              NavBarItem(
                index: 1,
                tip: t.explore,
                cursor: cursor,
                icon: Iconfont.compass_line,
                activeIcon: Iconfont.compass_fill,
                onTap: onTap,
              ),
              NavBarItem(
                index: isShowPublish,
                cursor: true,
                tip: t.createPost,
                icon: Iconfont.add_box_line,
                activeIcon: Iconfont.add_box_fill,
                onTap: onPublishTap,
              ),
              NavBarItem(
                index: 2,
                tip: t.messaging,
                cursor: cursor,
                icon: Iconfont.message_line,
                activeIcon: Iconfont.message_fill,
                onTap: onTap,
              ),
              NavBarItem(
                index: 3,
                tip: t.account,
                cursor: cursor,
                onTap: onTap,
                icon: Iconfont.account_circle_line,
                activeIcon: Iconfont.account_circle_fill,
              ),
            ],
          ),
        );
      },
    );
  }
}

class NavBarItem<T1, T2> extends StatelessWidget {
  const NavBarItem({
    Key? key,
    required this.index,
    required this.cursor,
    this.size = 28,
    required this.onTap,
    required this.tip,
    required this.icon,
    required this.activeIcon,
  }) : super(key: key);

  final T1 cursor;
  final T2 index;
  final double? size;
  final String tip;
  final IconData icon;
  final IconData activeIcon;

  final void Function(T2)? onTap;

  void _onTap() {
    onTap?.call(index);
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Tooltip(
        key: ValueKey(tip),
        message: tip,
        child: Bounceable(
          onTap: _onTap,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Icon(
              cursor == index ? activeIcon : icon,
              size: size,
            ),
          ),
        ),
      ),
    );
  }
}
