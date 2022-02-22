import 'package:auto_route/auto_route.dart';
// import 'package:flutter/cupertino.dart';

import '../pages/auth/verify.dart';
import '../pages/boot/page.dart';
import '../pages/auth/signin.dart';
import '../pages/home/home.dart';
import '../pages/messaging/messaging.dart';
import '../pages/landing.dart';

@CustomAutoRouter(
  transitionsBuilder: TransitionsBuilders.slideLeft,
  replaceInRouteName: 'Page,Router',
  routes: <AutoRoute>[
    AutoRoute(
      initial: true,
      path: '/boot',
      page: BootPage,
    ),
    AutoRoute(
      path: '/auth',
      name: 'AuthRouter',
      page: EmptyRouterPage,
      children: [
        AutoRoute(
          path: 'signin',
          page: SigninPage,
          // customRouteBuilder: TransitionsBuilders.fadeIn,
        ),
        AutoRoute(
          path: 'verify',
          page: AuthVerifyPage,
        ),
      ],
    ),
    AutoRoute(
      path: '/app',
      initial: true,
      page: LandingPage,
      name: 'LandingRouter',
      children: <AutoRoute>[
        AutoRoute(
          path: 'home',
          name: 'HomeRouter',
          page: HomePage,
        ),
        AutoRoute(
          path: 'messaging',
          name: 'MessagingRouter',
          page: MessagingPage,
        ),
      ],
    ),
  ],
)
class $AppRouter {}
