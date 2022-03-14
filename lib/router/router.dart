import 'package:auto_route/auto_route.dart';

import '../pages/account/account.dart';
import '../pages/auth/signin.dart';
import '../pages/auth/verify.dart';
import '../pages/explore/expore.dart';
import '../pages/home/home.dart';
import '../pages/landing.dart';
import '../pages/messaging/messaging.dart';
import '../pages/publish/publish.dart';

@CupertinoAutoRouter(
  replaceInRouteName: 'Page,Router',
  routes: <AutoRoute>[
    AutoRoute<dynamic>(
      path: '/',
      page: LandingPage,
      children: [
        AutoRoute<dynamic>(
          path: '',
          name: 'HomeRouter',
          page: HomePage,
        ),
        AutoRoute<dynamic>(
          path: 'explore',
          usesPathAsKey: true,
          page: ExplorePage,
        ),
        AutoRoute<dynamic>(
          path: 'messaging',
          usesPathAsKey: true,
          page: MessagingPage,
        ),
        AutoRoute<dynamic>(
          path: 'account',
          usesPathAsKey: true,
          page: AccountPage,
        ),
      ],
    ),
    CustomRoute<dynamic>(
      path: '/publish',
      usesPathAsKey: true,
      page: PublishPage,
      transitionsBuilder: TransitionsBuilders.slideBottom,
    ),
    AutoRoute<dynamic>(
      path: '/auth',
      name: 'AuthRouter',
      page: EmptyRouterPage,
      children: [
        AutoRoute<dynamic>(
          path: 'signin',
          page: SigninPage,
        ),
        AutoRoute<dynamic>(
          path: 'verify',
          page: AuthVerifyPage,
        ),
      ],
    ),
  ],
)
class $AppRouter {}
