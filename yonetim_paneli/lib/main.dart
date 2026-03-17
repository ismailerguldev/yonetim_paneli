import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yonetim_paneli/core/services/auth_service.dart';
import 'package:yonetim_paneli/core/services/token_service.dart';
import 'package:yonetim_paneli/core/theme.dart';
import 'package:yonetim_paneli/navigation/router.dart';

void main() {
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    return MaterialApp.router(
      theme: appTheme,
      debugShowCheckedModeBanner: false,
      title: "Yönetim Paneli",
      routerConfig: router,
    );
  }
}
