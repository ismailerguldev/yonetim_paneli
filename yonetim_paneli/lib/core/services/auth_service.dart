import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yonetim_paneli/core/models/user.model.dart';
import 'package:yonetim_paneli/core/services/fetch_service.dart';
import 'package:yonetim_paneli/core/services/token_service.dart';

class AuthService {
  static String? _accessToken;

  static void setAccessToken(String token) {
    _accessToken = token;
    ApiClient.dio.options.headers["Authorization"] = "Bearer $token";
  }

  static String? get accessToken => _accessToken;
  Future<void> login(String email, String password) async {
    try {
      final response = await ApiClient.dio.post(
        "/auth/login",
        data: {"email": email, "password": password},
      );
      final accessToken = response.data["accessToken"];
      final refreshToken = response.data["refreshToken"]["token"];
      AuthService.setAccessToken(accessToken);
      await TokenStorage.saveRefreshToken(refreshToken);
      print("Giriş yaptınız. $accessToken, $refreshToken");
    } on DioException catch (error) {
      print("Bir hata meydana geldi. ${error.response?.data.toString()}");
    }
  }

  Future<bool> register(
    String firstName,
    String lastName,
    String email,
    String password,
    String phone,
    String confirmPassword,
  ) async {
    try {
      final response = await ApiClient.dio.post(
        "/auth/register",
        data: {
          "firstName": firstName,
          "lastName": lastName,
          "email": email,
          "phone": phone,
          "password": password,
          "confirmPassword": confirmPassword,
        },
      );
      if (response.statusCode == 200) {
        return true;
      }
      return false;
    } on DioException catch (e) {
      print(e.response?.data.toString());
      return false;
    }
  }

  Future<User?> getMe() async {
    try {
      final response = await ApiClient.dio.get("/auth/me");
      print(response.data.toString());
      print("auth service getMe 36. satırdaki print -> ${response.statusCode}");
      return User.fromJson(response.data["user"]);
    } on DioException {
      return null;
    }
  }

  static Future<bool> forgotPassword(String email) async {
    try {
      final response = await ApiClient.dio.post(
        "/auth/forgot-password",
        data: {"email": email},
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } on DioException catch (e) {
      print(e.response?.data.toString());
      return false;
    }
  }

  static Future<bool> resetPassword(
    String email,
    String newPassword,
    String newPasswordCheck,
    String code,
  ) async {
    try {
      final response = await ApiClient.dio.post(
        "/auth/reset-password",
        data: {
          "code": code,
          "email": email,
          "newPassword": newPassword,
          "newPasswordCheck": newPasswordCheck,
        },
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } on DioException catch (e) {
      print(e.response?.data.toString());
      return false;
    }
  }

  Future<void> logout() async {
    try {
      final refreshToken = await TokenStorage.getRefreshToken();
      final response = await ApiClient.dio.post(
        "/auth/logout",
        data: {"refreshToken": refreshToken},
      );
      print(response.data["message"]);
    } on DioException catch (e) {
      print(e.response?.data.toString());
    } finally {
      await TokenStorage.clear();
      setAccessToken("");
    }
  }
}

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});
