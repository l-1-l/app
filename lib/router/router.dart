import 'package:auto_route/auto_route.dart';

import '../pages/account/account.dart';
import '../pages/auth/verify.dart';
import '../pages/auth/signin.dart';
import '../pages/home/home.dart';
import '../pages/messaging/messaging.dart';
import '../pages/landing.dart';
import '../pages/explore/expore.dart';
import '../pages/publish/publish.dart';

@CustomAutoRouter(
  transitionsBuilder: TransitionsBuilders.slideLeft,
  replaceInRouteName: 'Page,Router',
  routes: <AutoRoute>[
    AutoRoute(
      path: '/',
      page: LandingPage,
      children: [
        AutoRoute(
          path: '',
          name: 'HomeRouter',
          page: HomePage,
        ),
        AutoRoute(
          path: 'explore',
          usesPathAsKey: true,
          page: ExplorePage,
        ),
        AutoRoute(
          path: 'messaging',
          usesPathAsKey: true,
          page: MessagingPage,
        ),
        AutoRoute(
          path: 'account',
          usesPathAsKey: true,
          page: AccountPage,
        ),
      ],
    ),
    CustomRoute(
      path: '/publish',
      usesPathAsKey: true,
      page: PublishPage,
      transitionsBuilder: TransitionsBuilders.slideRight,
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
