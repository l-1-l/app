import 'dart:async';
import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'state.dart';

class NetworkNotifier extends StateNotifier<NetworkState> {
  final StateNotifierProviderRef<NetworkNotifier, NetworkState> ref;
  final Connectivity _connectivity = Connectivity();

  NetworkNotifier(this.ref) : super(const NetworkState.initial()) {
    _initConnectivity();

    StreamSubscription<ConnectivityResult> _subscription =
        _connectivity.onConnectivityChanged.listen(_handleConnectivityChange);

    ref.onDispose(() {
      _subscription.cancel();
    });
  }

  Future<void> _initConnectivity() async {
    late ConnectivityResult result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      log('Couldn\'t check connectivity status', error: e);
      return;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return Future.value(null);
    }

    return _handleConnectivityChange(result);
  }

  _handleConnectivityChange(ConnectivityResult event) {
    NetworkState newState;
    switch (event) {
      case ConnectivityResult.mobile:
      case ConnectivityResult.wifi:
      case ConnectivityResult.bluetooth:
      case ConnectivityResult.ethernet:
        final isMobile = event == ConnectivityResult.mobile;
        newState = NetworkState.on(isMobile: isMobile);
        break;
      case ConnectivityResult.none:
        newState = const NetworkState.off();
        break;
    }

    if (newState != state) {
      state = newState;
    }
  }

  void off() {
    state = const NetworkState.off();
  }
}
