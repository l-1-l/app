enum Flavor {
  development,
  staging,
  production,
}

class FlavorConfig {
  static FlavorConfig? _instance;
  static FlavorConfig get instance => _instance!;

  final Flavor flavor;
  final FlavorValues values;

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

  static bool isDevelopment() => _instance?.flavor == Flavor.development;

  static bool isProduction() => _instance?.flavor == Flavor.production;

  static bool isStaging() => _instance?.flavor == Flavor.staging;
}

class FlavorValues {
  final String baseUrl;
  final String? httpProxy;

  const FlavorValues({
    required this.baseUrl,
    this.httpProxy,
  });
}
