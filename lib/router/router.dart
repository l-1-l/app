import 'package:auto_route/auto_route.dart';

import '../pages/auth/verify.dart';
import '../pages/auth/signin.dart';
import '../pages/home/home.dart';
import '../pages/messaging/messaging.dart';
import '../pages/landing.dart';

@CustomAutoRouter(
  transitionsBuilder: TransitionsBuilders.slideLeft,
  replaceInRouteName: 'Page,Router',
  routes: <AutoRoute>[
    AutoRoute(
      path: '/',
      page: LandingPage,
      children: [
        AutoRoute(
          initial: true,
          path: '',
          name: 'HomeRouter',
          usesPathAsKey: true,
          page: HomePage,
        ),
        AutoRoute(
          initial: true,
          path: 'explore',
          name: 'ExploreRouter',
          usesPathAsKey: true,
          page: HomePage,
        ),
        AutoRoute(
          path: 'messaging',
          name: 'MessagingRouter',
          usesPathAsKey: true,
          page: MessagingPage,
        ),
        AutoRoute(
          path: 'account',
          name: 'AccountRouter',
          usesPathAsKey: true,
          page: MessagingPage,
        ),
      ],
    ),
    AutoRoute(
      path: '/auth',
      name: 'AuthRouter',
      page: EmptyRouterPage,
      children: [
        AutoRoute(
          path: 'signin',
          page: SigninPage,
        ),
        AutoRoute(
          path: 'verify',
          page: AuthVerifyPage,
        ),
      ],
    ),
  ],
)
class $AppRouter {}
