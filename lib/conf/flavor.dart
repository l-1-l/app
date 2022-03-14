enum Flavor {
  development,
  staging,
  production,
}

class FlavorConfig {
  factory FlavorConfig({
    required Flavor flavor,
    required FlavorValues values,
  }) {
    _instance ??= FlavorConfig._internal(
      flavor,
      values,
    );

    return _instance!;
  }
  FlavorConfig._internal(
    this.flavor,
    this.values,
  );

  static FlavorConfig? _instance;
  static FlavorConfig get instance => _instance!;

  final Flavor flavor;
  final FlavorValues values;

  static bool isDevelopment() => _instance?.flavor == Flavor.development;

  static bool isProduction() => _instance?.flavor == Flavor.production;

  static bool isStaging() => _instance?.flavor == Flavor.staging;
}

class FlavorValues {
  const FlavorValues({
    required this.baseUrl,
    this.httpProxy,
  });

  final String baseUrl;
  final String? httpProxy;
}
