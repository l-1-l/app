// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************
//
// ignore_for_file: type=lint

import 'package:auto_route/auto_route.dart' as _i3;
import 'package:flutter/material.dart' as _i10;

import '../pages/account/account.dart' as _i7;
import '../pages/auth/signin.dart' as _i8;
import '../pages/auth/verify.dart' as _i9;
import '../pages/explore/expore.dart' as _i5;
import '../pages/home/home.dart' as _i4;
import '../pages/landing.dart' as _i1;
import '../pages/messaging/messaging.dart' as _i6;
import '../pages/publish/publish.dart' as _i2;
import '../types/otp_receiver.dart' as _i11;

class AppRouter extends _i3.RootStackRouter {
  AppRouter([_i10.GlobalKey<_i10.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i3.PageFactory> pagesMap = {
    LandingRouter.name: (routeData) {
      return _i3.CustomPage<dynamic>(
          routeData: routeData,
          child: const _i1.LandingPage(),
          transitionsBuilder: _i3.TransitionsBuilders.slideLeft,
          opaque: true,
          barrierDismissible: false);
    },
    PublishRouter.name: (routeData) {
      return _i3.CustomPage<dynamic>(
          routeData: routeData,
          child: const _i2.PublishPage(),
          transitionsBuilder: _i3.TransitionsBuilders.slideRight,
          opaque: true,
          barrierDismissible: false);
    },
    AuthRouter.name: (routeData) {
      return _i3.CustomPage<dynamic>(
          routeData: routeData,
          child: const _i3.EmptyRouterPage(),
          transitionsBuilder: _i3.TransitionsBuilders.slideLeft,
          opaque: true,
          barrierDismissible: false);
    },
    HomeRouter.name: (routeData) {
      return _i3.CustomPage<dynamic>(
          routeData: routeData,
          child: const _i4.HomePage(),
          transitionsBuilder: _i3.TransitionsBuilders.slideLeft,
          opaque: true,
          barrierDismissible: false);
    },
    ExploreRouter.name: (routeData) {
      return _i3.CustomPage<dynamic>(
          routeData: routeData,
          child: const _i5.ExplorePage(),
          transitionsBuilder: _i3.TransitionsBuilders.slideLeft,
          opaque: true,
          barrierDismissible: false);
    },
    MessagingRouter.name: (routeData) {
      return _i3.CustomPage<dynamic>(
          routeData: routeData,
          child: const _i6.MessagingPage(),
          transitionsBuilder: _i3.TransitionsBuilders.slideLeft,
          opaque: true,
          barrierDismissible: false);
    },
    AccountRouter.name: (routeData) {
      return _i3.CustomPage<dynamic>(
          routeData: routeData,
          child: const _i7.AccountPage(),
          transitionsBuilder: _i3.TransitionsBuilders.slideLeft,
          opaque: true,
          barrierDismissible: false);
    },
    SigninRouter.name: (routeData) {
      return _i3.CustomPage<dynamic>(
          routeData: routeData,
          child: const _i8.SigninPage(),
          transitionsBuilder: _i3.TransitionsBuilders.slideLeft,
          opaque: true,
          barrierDismissible: false);
    },
    AuthVerifyRouter.name: (routeData) {
      final args = routeData.argsAs<AuthVerifyRouterArgs>();
      return _i3.CustomPage<dynamic>(
          routeData: routeData,
          child: _i9.AuthVerifyPage(
              key: args.key,
              receiver: args.receiver,
              isNewAccount: args.isNewAccount),
          transitionsBuilder: _i3.TransitionsBuilders.slideLeft,
          opaque: true,
          barrierDismissible: false);
    }
  };

  @override
  List<_i3.RouteConfig> get routes => [
        _i3.RouteConfig(LandingRouter.name, path: '/', children: [
          _i3.RouteConfig(HomeRouter.name,
              path: '', parent: LandingRouter.name),
          _i3.RouteConfig(ExploreRouter.name,
              path: 'explore', parent: LandingRouter.name, usesPathAsKey: true),
          _i3.RouteConfig(MessagingRouter.name,
              path: 'messaging',
              parent: LandingRouter.name,
              usesPathAsKey: true),
          _i3.RouteConfig(AccountRouter.name,
              path: 'account', parent: LandingRouter.name, usesPathAsKey: true)
        ]),
        _i3.RouteConfig(PublishRouter.name,
            path: '/publish', usesPathAsKey: true),
        _i3.RouteConfig(AuthRouter.name, path: '/auth', children: [
          _i3.RouteConfig(SigninRouter.name,
              path: 'signin', parent: AuthRouter.name),
          _i3.RouteConfig(AuthVerifyRouter.name,
              path: 'verify', parent: AuthRouter.name)
        ])
      ];
}

/// generated route for
/// [_i1.LandingPage]
class LandingRouter extends _i3.PageRouteInfo<void> {
  const LandingRouter({List<_i3.PageRouteInfo>? children})
      : super(LandingRouter.name, path: '/', initialChildren: children);

  static const String name = 'LandingRouter';
}

/// generated route for
/// [_i2.PublishPage]
class PublishRouter extends _i3.PageRouteInfo<void> {
  const PublishRouter() : super(PublishRouter.name, path: '/publish');

  static const String name = 'PublishRouter';
}

/// generated route for
/// [_i3.EmptyRouterPage]
class AuthRouter extends _i3.PageRouteInfo<void> {
  const AuthRouter({List<_i3.PageRouteInfo>? children})
      : super(AuthRouter.name, path: '/auth', initialChildren: children);

  static const String name = 'AuthRouter';
}

/// generated route for
/// [_i4.HomePage]
class HomeRouter extends _i3.PageRouteInfo<void> {
  const HomeRouter() : super(HomeRouter.name, path: '');

  static const String name = 'HomeRouter';
}

/// generated route for
/// [_i5.ExplorePage]
class ExploreRouter extends _i3.PageRouteInfo<void> {
  const ExploreRouter() : super(ExploreRouter.name, path: 'explore');

  static const String name = 'ExploreRouter';
}

/// generated route for
/// [_i6.MessagingPage]
class MessagingRouter extends _i3.PageRouteInfo<void> {
  const MessagingRouter() : super(MessagingRouter.name, path: 'messaging');

  static const String name = 'MessagingRouter';
}

/// generated route for
/// [_i7.AccountPage]
class AccountRouter extends _i3.PageRouteInfo<void> {
  const AccountRouter() : super(AccountRouter.name, path: 'account');

  static const String name = 'AccountRouter';
}

/// generated route for
/// [_i8.SigninPage]
class SigninRouter extends _i3.PageRouteInfo<void> {
  const SigninRouter() : super(SigninRouter.name, path: 'signin');

  static const String name = 'SigninRouter';
}

/// generated route for
/// [_i9.AuthVerifyPage]
class AuthVerifyRouter extends _i3.PageRouteInfo<AuthVerifyRouterArgs> {
  AuthVerifyRouter(
      {_i10.Key? key,
      required _i11.OtpReciver receiver,
      required bool isNewAccount})
      : super(AuthVerifyRouter.name,
            path: 'verify',
            args: AuthVerifyRouterArgs(
                key: key, receiver: receiver, isNewAccount: isNewAccount));

  static const String name = 'AuthVerifyRouter';
}

class AuthVerifyRouterArgs {
  const AuthVerifyRouterArgs(
      {this.key, required this.receiver, required this.isNewAccount});

  final _i10.Key? key;

  final _i11.OtpReciver receiver;

  final bool isNewAccount;

  @override
  String toString() {
    return 'AuthVerifyRouterArgs{key: $key, receiver: $receiver, isNewAccount: $isNewAccount}';
  }
}
