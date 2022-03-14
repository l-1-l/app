import 'dart:async';
import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast_io.dart';

import 'store/auth.dart';
import 'store/db.dart';
import 'store/preferences.dart';
import 'types/preferences.dart' show Preferences;

class AppProviderObserver extends ProviderObserver {
  @override
  void providerDidFail(
    ProviderBase provider,
    Object error,
    StackTrace stackTrace,
    ProviderContainer container,
  ) {
    log(
      '[${provider.name ?? provider.runtimeType}] error: $error, $stackTrace',
    );
  }

  @override
  void didUpdateProvider(
    ProviderBase provider,
    Object? previousValue,
    Object? newValue,
    ProviderContainer container,
  ) {
    if (newValue is StateController<int>) {
      log(
        '[${provider.name ?? provider.runtimeType}] value: ${newValue.state}',
      );
    }
  }
}

Future<void> bootstrap(FutureOr<Widget> Function() builder) async {
  WidgetsFlutterBinding.ensureInitialized();

  final dir = await getApplicationDocumentsDirectory();
  await dir.create(recursive: true);
  final dbPath = join(dir.path, 'sweets_databae.db');
  final db = await databaseFactoryIo.openDatabase(dbPath);
  final preferencesRepo = PreferencesRepo(db);

  final authState = await AuthState.fromDb(db);
  final preferences = await preferencesRepo.read();

  unawaited(
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]),
  );

  FlutterError.onError = (details) {
    log(
      details.exceptionAsString(),
      stackTrace: details.stack,
    );
  };

  await runZonedGuarded(
    () async {
      runApp(
        ProviderScope(
          observers: [AppProviderObserver()],
          overrides: [
            dbProvider.overrideWithValue(db),
            authProvider.overrideWithProvider(
              StateNotifierProvider(
                (ref) => AuthStateNotifier(
                  ref.read,
                  authState,
                ),
              ),
            ),
            preferencesProvider.overrideWithProvider(
              StateNotifierProvider(
                (ref) => PreferencesNotifier(
                  ref.read,
                  preferences ?? const Preferences(),
                ),
              ),
            ),
          ],
          child: await builder(),
        ),
      );
    },
    (error, stackTrace) => log(error.toString(), stackTrace: stackTrace),
  );
}
