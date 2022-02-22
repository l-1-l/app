// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************
//
// ignore_for_file: type=lint

import 'package:auto_route/auto_route.dart' as _i2;
import 'package:flutter/material.dart' as _i8;

import '../pages/auth/signin.dart' as _i4;
import '../pages/auth/verify.dart' as _i5;
import '../pages/boot/page.dart' as _i1;
import '../pages/home/home.dart' as _i6;
import '../pages/landing.dart' as _i3;
import '../pages/messaging/messaging.dart' as _i7;
import '../types/otp_receiver.dart' as _i9;

class AppRouter extends _i2.RootStackRouter {
  AppRouter([_i8.GlobalKey<_i8.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i2.PageFactory> pagesMap = {
    BootRouter.name: (routeData) {
      return _i2.CustomPage<dynamic>(
          routeData: routeData,
          child: const _i1.BootPage(),
          transitionsBuilder: _i2.TransitionsBuilders.slideLeft,
          opaque: true,
          barrierDismissible: false);
    },
    AuthRouter.name: (routeData) {
      return _i2.CustomPage<dynamic>(
          routeData: routeData,
          child: const _i2.EmptyRouterPage(),
          transitionsBuilder: _i2.TransitionsBuilders.slideLeft,
          opaque: true,
          barrierDismissible: false);
    },
    LandingRouter.name: (routeData) {
      return _i2.CustomPage<dynamic>(
          routeData: routeData,
          child: const _i3.LandingPage(),
          transitionsBuilder: _i2.TransitionsBuilders.slideLeft,
          opaque: true,
          barrierDismissible: false);
    },
    SigninRouter.name: (routeData) {
      return _i2.CustomPage<dynamic>(
          routeData: routeData,
          child: const _i4.SigninPage(),
          transitionsBuilder: _i2.TransitionsBuilders.slideLeft,
          opaque: true,
          barrierDismissible: false);
    },
    AuthVerifyRouter.name: (routeData) {
      final args = routeData.argsAs<AuthVerifyRouterArgs>();
      return _i2.CustomPage<dynamic>(
          routeData: routeData,
          child: _i5.AuthVerifyPage(
              key: args.key,
              receiver: args.receiver,
              isNewAccount: args.isNewAccount),
          transitionsBuilder: _i2.TransitionsBuilders.slideLeft,
          opaque: true,
          barrierDismissible: false);
    },
    HomeRouter.name: (routeData) {
      return _i2.CustomPage<dynamic>(
          routeData: routeData,
          child: const _i6.HomePage(),
          transitionsBuilder: _i2.TransitionsBuilders.slideLeft,
          opaque: true,
          barrierDismissible: false);
    },
    MessagingRouter.name: (routeData) {
      return _i2.CustomPage<dynamic>(
          routeData: routeData,
          child: const _i7.MessagingPage(),
          transitionsBuilder: _i2.TransitionsBuilders.slideLeft,
          opaque: true,
          barrierDismissible: false);
    }
  };

  @override
  List<_i2.RouteConfig> get routes => [
        _i2.RouteConfig('/#redirect',
            path: '/', redirectTo: '/boot', fullMatch: true),
        _i2.RouteConfig(BootRouter.name, path: '/boot'),
        _i2.RouteConfig(AuthRouter.name, path: '/auth', children: [
          _i2.RouteConfig(SigninRouter.name,
              path: 'signin', parent: AuthRouter.name),
          _i2.RouteConfig(AuthVerifyRouter.name,
              path: 'verify', parent: AuthRouter.name)
        ]),
        _i2.RouteConfig(LandingRouter.name, path: '/app', children: [
          _i2.RouteConfig(HomeRouter.name,
              path: 'home', parent: LandingRouter.name),
          _i2.RouteConfig(MessagingRouter.name,
              path: 'messaging', parent: LandingRouter.name)
        ])
      ];
}

/// generated route for
/// [_i1.BootPage]
class BootRouter extends _i2.PageRouteInfo<void> {
  const BootRouter() : super(BootRouter.name, path: '/boot');

  static const String name = 'BootRouter';
}

/// generated route for
/// [_i2.EmptyRouterPage]
class AuthRouter extends _i2.PageRouteInfo<void> {
  const AuthRouter({List<_i2.PageRouteInfo>? children})
      : super(AuthRouter.name, path: '/auth', initialChildren: children);

  static const String name = 'AuthRouter';
}

/// generated route for
/// [_i3.LandingPage]
class LandingRouter extends _i2.PageRouteInfo<void> {
  const LandingRouter({List<_i2.PageRouteInfo>? children})
      : super(LandingRouter.name, path: '/app', initialChildren: children);

  static const String name = 'LandingRouter';
}

/// generated route for
/// [_i4.SigninPage]
class SigninRouter extends _i2.PageRouteInfo<void> {
  const SigninRouter() : super(SigninRouter.name, path: 'signin');

  static const String name = 'SigninRouter';
}

/// generated route for
/// [_i5.AuthVerifyPage]
class AuthVerifyRouter extends _i2.PageRouteInfo<AuthVerifyRouterArgs> {
  AuthVerifyRouter(
      {_i8.Key? key,
      required _i9.OtpReciver receiver,
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

  final _i8.Key? key;

  final _i9.OtpReciver receiver;

  final bool isNewAccount;

  @override
  String toString() {
    return 'AuthVerifyRouterArgs{key: $key, receiver: $receiver, isNewAccount: $isNewAccount}';
  }
}

/// generated route for
/// [_i6.HomePage]
class HomeRouter extends _i2.PageRouteInfo<void> {
  const HomeRouter() : super(HomeRouter.name, path: 'home');

  static const String name = 'HomeRouter';
}

/// generated route for
/// [_i7.MessagingPage]
class MessagingRouter extends _i2.PageRouteInfo<void> {
  const MessagingRouter() : super(MessagingRouter.name, path: 'messaging');

  static const String name = 'MessagingRouter';
}
