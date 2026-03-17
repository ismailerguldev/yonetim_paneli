import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yonetim_paneli/core/models/project.model.dart';
import 'package:yonetim_paneli/core/notifiers.dart';
import 'package:yonetim_paneli/screens/auth/forgot_password_screen.dart';
import 'package:yonetim_paneli/screens/auth/login_screen.dart';
import 'package:yonetim_paneli/screens/auth/reset_password_screen.dart';
import 'package:yonetim_paneli/screens/auth/signup_screen.dart';
import 'package:yonetim_paneli/screens/home/main_page.dart';
import 'package:yonetim_paneli/screens/home/profil_page.dart';
import 'package:yonetim_paneli/screens/home/project_detail.dart';
import 'package:yonetim_paneli/screens/layout.dart';

// GoRouter configuration

final routerProvider = Provider<GoRouter>((ref) {
  const protectedPaths = ["/profile", "/home", "/project"];
  const authPaths = ["/login", "/signup"];
  final routerNotifier = ValueNotifier<bool>(false);
  ref.listen(authProvider, (previous, next) {
    routerNotifier.value = !routerNotifier.value;
  });
  return GoRouter(
    initialLocation: "/login",
    refreshListenable: routerNotifier,
    redirect: (context, state) {
      final authstate = ref.read(authProvider);
      if (authstate.isLoading) {
        return null;
      }
      final isAuthenticated = authstate.value != null;
      final isInProtected = protectedPaths.any(
        (p) => state.matchedLocation.startsWith(p),
      );
      final isInAuthPaths = authPaths.any(
        (p) => state.matchedLocation.startsWith(p),
      );
      if (!isAuthenticated && isInProtected) {
        return "/login";
      }
      if (isAuthenticated && isInAuthPaths) {
        return "/home";
      }
      return null;
    },
    routes: [
      ShellRoute(
        builder: (context, state, child) => Layout(child: child),
        routes: [
          GoRoute(
            path: "/login",
            builder: (context, state) => const LoginScreen(),
          ),
          GoRoute(
            path: "/signup",
            builder: (context, state) => const SignupScreen(),
          ),
          GoRoute(path: "/home", builder: (context, state) => MainPage()),
          GoRoute(path: "/profile", builder: (context, state) => ProfilePage()),
          GoRoute(
            path: "/project/:id",
            builder: (context, state) {
              final Project projectData = state.extra as Project;
              return ProjectDetailScreen(projectData: projectData);
            },
          ),
          GoRoute(
            path: "/forgot-password",
            builder: (context, state) => FPasswordScreen(),
          ),
          GoRoute(
            path: "/reset-password",
            builder: (context, state) {
              final String email = state.extra as String;
              return RPasswordScreen(email: email);
            },
          ),
        ],
      ),
    ],
  );
});
