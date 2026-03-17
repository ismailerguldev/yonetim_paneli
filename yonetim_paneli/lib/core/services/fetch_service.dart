import 'package:dio/dio.dart';
import 'package:yonetim_paneli/core/services/auth_service.dart';
import 'package:yonetim_paneli/core/services/token_service.dart';

class ApiClient {
  static final Dio dio =
      Dio(
          BaseOptions(
            baseUrl: "http://192.168.1.165:5001/api",
            connectTimeout: const Duration(seconds: 10),
            receiveTimeout: const Duration(seconds: 10),
            headers: {
              "Content-Type": "application/json",
              "Accept": "application/json",
            },
          ),
        )
        ..interceptors.add(
          InterceptorsWrapper(
            onError: (DioException error, handler) async {
              print("Fetch Service 21. satırdaki printten gelen hata: ${error.response?.data.toString()}");
              if (error.response?.statusCode == 401) {
                if (error.requestOptions.headers["isRefresh"] == true) {
                  return handler.next(error);
                }
                final refreshToken = await TokenStorage.getRefreshToken();
                if (refreshToken == null) {
                  return handler.next(error);
                }
                try {
                  final refreshResponse = await dio.post(
                    "/auth/refresh",
                    data: {"refreshToken": refreshToken},
                    options: Options(headers: {"isRefresh": true}),
                  );
                  final newAccessToken = refreshResponse.data["accessToken"];
                  final newRefreshToken =
                      refreshResponse.data["refreshToken"]["token"];
                  await TokenStorage.saveRefreshToken(newRefreshToken);
                  AuthService.setAccessToken(newAccessToken);
                  error.requestOptions.headers["Authorization"] =
                      "Bearer $newAccessToken";
                  return handler.resolve(await dio.fetch(error.requestOptions));
                } on DioException catch (e) {
                  return handler.next(e);
                }
              }

              return handler.next(error);
            },
          ),
        );
}
