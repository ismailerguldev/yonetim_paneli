import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yonetim_paneli/core/notifiers.dart';
import 'package:yonetim_paneli/core/services/auth_service.dart';

class SignupScreen extends ConsumerWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(64),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Yönetim Panelinize\nHoş Geldiniz",
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),
            SizedBox(height: 8),
            Text(
              "Başlamak için hızlıca kayıt olabilirsiniz.",
              style: TextStyle(color: Colors.black45),
            ),
            SizedBox(height: 24),
            FormSection(),
            SizedBox(height: 36),
            GestureDetector(
              onTap: () {
                context.push("/login");
              },
              child: RichText(
                text: TextSpan(
                  style: DefaultTextStyle.of(context).style,
                  children: [
                    TextSpan(
                      text: "Zaten bir hesabınız varsa ",
                      style: TextStyle(color: Colors.grey),
                    ),
                    TextSpan(
                      text: "buradan ",
                      style: TextStyle(color: Colors.blueAccent),
                    ),
                    TextSpan(
                      text: "giriş yapabilirsiniz",
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

class FormSection extends ConsumerStatefulWidget {
  const FormSection({super.key});

  @override
  ConsumerState<FormSection> createState() => _FormSectionState();
}

class _FormSectionState extends ConsumerState<FormSection> {
  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  @override
  void dispose() {
    firstName.dispose();
    lastName.dispose();
    email.dispose();
    phone.dispose();
    password.dispose();
    confirmPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      spacing: 36,
      children: [
        Row(
          spacing: 16,
          children: [
            Expanded(
              child: TextField(
                controller: firstName,
                decoration: InputDecoration(
                  labelText: "İsim",
                  prefixIcon: Icon(Icons.person),
                ),
              ),
            ),
            Expanded(
              child: TextField(
                controller: lastName,
                decoration: InputDecoration(
                  labelText: "Soy isim",
                  prefixIcon: Icon(Icons.person),
                ),
              ),
            ),
          ],
        ),
        TextField(
          controller: email,
          decoration: InputDecoration(
            labelText: "E-Posta",
            prefixIcon: Icon(Icons.email),
          ),
        ),
        TextField(
          controller: phone,
          decoration: InputDecoration(
            labelText: "Telefon",
            prefixIcon: Icon(Icons.phone),
          ),
        ),
        TextField(
          obscureText: true,
          controller: password,
          decoration: InputDecoration(
            labelText: "Parola",
            prefixIcon: Icon(Icons.lock),
          ),
        ),
        TextField(
          obscureText: true,
          controller: confirmPassword,
          decoration: InputDecoration(
            labelText: "Parola Onayı",
            prefixIcon: Icon(Icons.lock),
          ),
        ),
        SizedBox(height: 24),
        GestureDetector(
          onTap: () {
            ref
                .read(authProvider.notifier)
                .register(
                  firstName.text,
                  lastName.text,
                  email.text,
                  password.text,
                  phone.text,
                  confirmPassword.text
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
              "Kayıt Ol",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ),
      ],
    );
  }
}
