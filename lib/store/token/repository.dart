import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../types/auth_token.dart';

class AuthTokenRepository {
  late FlutterSecureStorage _storage;

  factory AuthTokenRepository() => _instance;

  static final AuthTokenRepository _instance = AuthTokenRepository._internal();

  AuthTokenRepository._internal() {
    _storage = const FlutterSecureStorage();
  }

  Future<AuthToken?> fromStorage() async {
    final token = await _storage.read(
      key: '__access_token__',
    );

    if (token == null) return null;

    return AuthToken.fromJson(
      json.decode(token) as Map<String, dynamic>,
    );
  }

  Future<void> save(AuthToken token) async {
    await _storage.write(
      key: '__access_token__',
      value: json.encode(token.toJson()),
    );
  }

  Future<void> clear() async {
    await _storage.delete(key: '__access_token__');
  }
}
