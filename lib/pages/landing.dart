import 'package:app/router/mod.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../widgets/iconfont.dart';
import '../l10n/l10n.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final t = context.l10n;

    return AutoTabsScaffold(
      routes: const [
        HomeRouter(),
        HomeRouter(),
        HomeRouter(),
        HomeRouter(),
        MessagingRouter(),
      ],
      bottomNavigationBuilder: (_, tabsRouter) {
        print(context.topRouteMatch.name);

        return Theme(
          data: Theme.of(context).copyWith(splashColor: Colors.transparent),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            enableFeedback: true,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            currentIndex: tabsRouter.activeIndex,
            onTap: tabsRouter.setActiveIndex,
            items: [
              BottomNavigationBarItem(
                icon: const Icon(Iconfont.home_line),
                activeIcon: const Icon(Iconfont.home_fill),
                label: t.home,
              ),
              BottomNavigationBarItem(
                label: t.explore,
                icon: const Icon(Iconfont.compass_line),
                activeIcon: const Icon(Iconfont.compass_fill),
              ),
              BottomNavigationBarItem(
                label: t.createPost,
                icon: const Icon(Iconfont.add_box_line, size: 32),
                activeIcon: const Icon(Iconfont.add_box_fill, size: 32),
              ),
              BottomNavigationBarItem(
                label: t.messaging,
                icon: const Icon(Iconfont.message_line),
                activeIcon: const Icon(Iconfont.message_fill),
              ),
              BottomNavigationBarItem(
                label: t.account,
                icon: const Icon(Iconfont.account_circle_line),
                activeIcon: const Icon(Iconfont.account_circle_fill),
              ),
            ],
          ),
        );
      },
    );
  }
}
