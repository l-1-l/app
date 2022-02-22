import 'package:app/store/token/repository.dart';
import 'package:app/utils/jwt.dart';
import 'package:dio/dio.dart';

class TokenInterceptors extends QueuedInterceptor {
  final Dio dio;

  TokenInterceptors(this.dio);

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final repo = AuthTokenRepository();
    final authToken = await repo.fromStorage();

    if (authToken != null) {
      final expiration = Jwt.remaingTime(authToken.accessToken);

      if (expiration != null && expiration.inSeconds < 60) {
        // dio.interceptors.requestLock.lock();
        // RefireshToken

        // Call the refresh endpoint to get a new token
        // await UserService().refresh().then((response) async {
        //   await TokenRepository().persistAccessToken(response.accessToken);
        //   accessToken = response.accessToken;
        // }).catchError((error, stackTrace) {
        //   handler.reject(error, true);
        // }).whenComplete(() => dio.interceptors.requestLock.unlock());
      }

      options.headers['Authorization'] = 'Bearer ${authToken.accessToken}';
    }

    return handler.next(options);
  }
}
