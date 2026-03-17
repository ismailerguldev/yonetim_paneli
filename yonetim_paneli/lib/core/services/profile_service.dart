import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:yonetim_paneli/core/services/fetch_service.dart';

class ProfileService {
  static Future<void> changePassword(String oldValue, String newValue) async {
    try {
      final response = await ApiClient.dio.post(
        "/auth/change-password",
        data: {"currentPassword": oldValue, "newPassword": newValue},
      );
      if (response.data["success"] == true) {
        debugPrint(response.data["message"]);
      }
    } on DioException catch (error) {
      debugPrint(error.response?.data.toString());
    }
  }
}
