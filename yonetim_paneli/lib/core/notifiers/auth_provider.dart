import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yonetim_paneli/core/models/user.model.dart';
import 'package:yonetim_paneli/core/notifiers.dart';
import 'package:yonetim_paneli/core/services/auth_service.dart';
import 'package:yonetim_paneli/core/services/token_service.dart';

class AuthNotifier extends AsyncNotifier<User?> {
  @override
  FutureOr<User?> build() async {
    final refreshToken = await TokenStorage.getRefreshToken();
    if (refreshToken != null) {
      try {
        print("Auth provider login 14. satır buraya girdi builde");
        return await AuthService().getMe();
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  Future<void> login(String email, String password) async {
    state = AsyncLoading();
    try {
      await AuthService().login(email, password);
      print("Auth provider login 26. satır buraya girdi logine");
      final user = await AuthService().getMe();
      state = AsyncData(user);
      ref.invalidate(projectProvider);
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
    }
  }

  Future<void> register(
    String firstName,
    String lastName,
    String email,
    String password,
    String phone,
    String confirmPassword,
  ) async {
    state = AsyncLoading();
    try {
      final result = await AuthService().register(
        firstName,
        lastName,
        email,
        password,
        phone,
        confirmPassword,
      );

      await login(email, password);
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
    }
  }

  void logout() {
    TokenStorage.clear();
    AuthService.setAccessToken("");
    state = AsyncData(null);
  }
}
