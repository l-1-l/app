// ignore_for_file: avoid_dynamic_calls

import 'dart:io';

import 'package:app/conf/flavor.dart';
import 'package:app/store/network/provider.dart';
import 'package:app/store/network/notifier.dart';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'exception.dart';
import 'interceptors.dart';
import 'response.dart';

final netProvider = Provider((ref) {
  final dio = NetClient.createDio();
  final netNotifier = ref.read(networkProvider.notifier);
  return NetClient(dio, netNotifier);
});

class NetClient {
  final Dio dio;
  final NetworkNotifier notifier;

  NetClient(this.dio, this.notifier);

  static Dio createDio([String baseUrl = '']) {
    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        receiveTimeout: 15000, // 15 seconds
        connectTimeout: 15000,
        sendTimeout: 15000,
      ),
    );

    if (FlavorConfig.instance.values.httpProxy != null) {
      dio.httpClientAdapter = DefaultHttpClientAdapter()
        ..onHttpClientCreate = (client) => client
          ..findProxy = (uri) {
            return 'PROXY ${FlavorConfig.instance.values.httpProxy}';
          }
          ..badCertificateCallback = (
            X509Certificate cert,
            String host,
            int port,
          ) =>
              true;
    }

    if (kDebugMode) {
      dio.interceptors.add(
        LogInterceptor(
          requestBody: true,
          responseHeader: false,
          responseBody: true,
        ),
      );
    }

    final cacheOptions = CacheOptions(
      store: MemCacheStore(),

      /// Optional.
      /// Returns a cached response on error but for statuses 401 & 403.
      hitCacheOnErrorExcept: [401, 403],

      /// Optional.
      /// Overrides any HTTP directive to delete entry past this duration.
      maxStale: const Duration(days: 7),
    );
    dio.interceptors.add(DioCacheInterceptor(options: cacheOptions));

    dio.interceptors.add(TokenInterceptors(dio));

    return dio;
  }

  Future<NetResponse> get<T>(
    String path, {
    String? baseUrl,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final response = await dio.get<T>(
        _uri(path, baseUrl),
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
      return _handleResponse<T>(response);
    } on Exception catch (e) {
      return _handleError<T>(e);
    }
  }

  Future<NetResponse<T>> post<T>(
    String path,
    dynamic data, {
    String? baseUrl,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final response = await dio.post<T>(
        _uri(path, baseUrl),
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return _handleResponse<T>(response);
    } on Exception catch (e) {
      return _handleError(e);
    }
  }

  Future<NetResponse> patch<T>(
    String path, {
    dynamic data,
    String? baseUrl,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final response = await dio.patch<T>(
        _uri(path, baseUrl),
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return _handleResponse<T>(response);
    } on Exception catch (e) {
      return _handleError<T>(e);
    }
  }

  Future<NetResponse> put<T>(
    String path, {
    dynamic data,
    String? baseUrl,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await dio.put<T>(
        _uri(path, baseUrl),
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return _handleResponse<T>(
        response,
      );
    } on Exception catch (e) {
      return _handleError<T>(e);
    }
  }

  Future<NetResponse> delete<T>(
    String path, {
    dynamic data,
    String? baseUrl,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await dio.delete<T>(
        _uri(path, baseUrl),
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return _handleResponse<T>(response);
    } on Exception catch (e) {
      return _handleError<T>(e);
    }
  }

  String _uri(
    String path, [
    String? baseUrl,
  ]) =>
      (baseUrl ?? FlavorConfig.instance.values.baseUrl) + path;

  NetResponse<T> _handleResponse<T>(
    Response response,
  ) {
    final statusCode = response.statusCode;
    final dynamic data = response.data;

    if (statusCode == null) {
      return const NetResponse.error(
        NetException.connectivity(),
      );
    }

    if (statusCode >= 200 && statusCode < 300) {
      return NetResponse<T>.success(
        (data['data'] ?? data) as T,
      );
    }

    if (data['message'] != null || data['code'] != null) {
      return NetResponse.error(
        NetException.error(
          data['message'] as String? ?? '',
          data['code'] as String? ?? '',
        ),
      );
    }

    return const NetResponse.error(
      NetException.unknown(),
    );
  }

  NetResponse<T> _handleError<T>(
    Exception e,
  ) {
    if (e is DioError) {
      switch (e.type) {
        case DioErrorType.cancel:
          return NetResponse<T>.error(
            NetException.cancelled(e.message),
          );
        case DioErrorType.connectTimeout:
        case DioErrorType.receiveTimeout:
        case DioErrorType.sendTimeout:
          return const NetResponse.error(
            NetException.connectivity(),
          );
        case DioErrorType.response:
          final res = e.response;
          if (res == null) {
            return NetResponse.error(
              NetException.message(e.message),
            );
          }
          if (res.statusCode == 401) {
            return const NetResponse.error(
              NetException.unauthorized(),
            );
          }
          if (res.statusCode != null && res.statusCode! >= 500) {
            return const NetResponse.error(
              NetException.unknown(),
            );
          }

          if (res.data['message'] != null || res.data['code'] != null) {
            return NetResponse.error(
              NetException.error(
                res.data['message'] as String? ?? '',
                res.data['code'] as String? ?? '',
              ),
            );
          }
          return const NetResponse.error(
            NetException.unknown(),
          );
        case DioErrorType.other:
          if (e.error is SocketException) {
            notifier.off();
            return const NetResponse.error(
              NetException.connectivity(),
            );
          }
          return const NetResponse.error(
            NetException.unknown(),
          );
      }
    }

    return NetResponse.error(
      NetException.message(e.toString()),
    );
  }
}
