import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yonetim_paneli/core/notifiers.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(64),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Tekrar Hoş Geldiniz",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),
            SizedBox(height: 8),
            Text(
              "Proje paneliniz için giriş yapın.",
              style: TextStyle(color: Colors.black45),
            ),
            SizedBox(height: 24),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: "Email",
                    prefixIcon: Icon(Icons.email),
                  ),
                ),
                SizedBox(height: 36),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Parola",
                    prefixIcon: Icon(Icons.lock),
                  ),
                ),
                SizedBox(height: 8),
                InkWell(
                  onTap: () => context.push("/forgot-password"),
                  child: Text(
                    "Şifrenizi mi unuttunuz?",
                    style: TextStyle(
                      color: Colors.blue.shade800,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 24),
            GestureDetector(
              onTap: () {
                ref
                    .read(authProvider.notifier)
                    .login(
                      _emailController.text.trim(),
                      _passwordController.text.trim(),
                    );
              },
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF0f6DF0), Color(0xFF0A4ABA)],
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: EdgeInsets.all(16),
                alignment: Alignment.center,
                child: Text(
                  "Giriş Yap",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
            SizedBox(height: 36),
            GestureDetector(
              onTap: () {
                context.push("/signup");
              },
              child: RichText(
                text: TextSpan(
                  style: DefaultTextStyle.of(context).style,
                  children: [
                    TextSpan(
                      text: "Henüz bir hesabınız yoksa ",
                      style: TextStyle(color: Colors.grey),
                    ),
                    TextSpan(
                      text: "buradan ",
                      style: TextStyle(color: Colors.blueAccent),
                    ),
                    TextSpan(
                      text: "kayıt olabilirsiniz.",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
