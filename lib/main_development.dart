import 'app.dart';
import 'bootstrap.dart';
import 'conf/flavor.dart';

void main() {
  FlavorConfig(
    flavor: Flavor.development,
    values: const FlavorValues(
      // adb reverse tcp:8000 tcp:8000
      baseUrl: 'http://localhost:8000',
    ),
  );

  bootstrap(() => const App());
}
