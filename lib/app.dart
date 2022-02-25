import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ovo_ui/mod.dart';

import 'router/router.gr.dart';
import 'store/auth/notifier.dart';
import 'store/theme/theme.dart';
import 'l10n/l10n.dart';
import 'widgets/top.dart';

class App extends ConsumerStatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AppState();
}

class _AppState extends ConsumerState<App> {
  late final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();
  late final router = AppRouter(navigatorKey);

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeProvider);
    final authState = ref.watch(authProvider);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      themeMode: themeMode,
      theme: OvOThemeData.lightThemeData,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      routerDelegate: router.delegate(
        initialRoutes: [
          authState.maybeMap(
            signed: (account) => const LandingRouter(),
            orElse: () => const AuthRouter(
              children: [SigninRouter()],
            ),
          )
        ],
      ),
      routeInformationParser: router.defaultRouteParser(),
      builder: (context, child) => Top(child, navigatorKey),
    );
  }
}
