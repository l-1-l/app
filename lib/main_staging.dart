import 'app.dart';
import 'bootstrap.dart';
import 'conf/flavor.dart';

void main() {
  FlavorConfig(
    flavor: Flavor.development,
    values: const FlavorValues(
      baseUrl: 'http://localhost:8000',
    ),
  );

  bootstrap(() => const App());
}
