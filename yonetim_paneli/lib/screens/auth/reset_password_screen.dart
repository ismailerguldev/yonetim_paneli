import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:yonetim_paneli/core/services/auth_service.dart';

class RPasswordScreen extends StatelessWidget {
  final String email;
  const RPasswordScreen({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Kodu gir, Kolayca sıfırla!",
          style: TextStyle(color: Colors.black, fontSize: 22),
        ),
        SizedBox(height: 12),
        FormSection(email: email),
      ],
    );
  }
}

class FormSection extends StatefulWidget {
  final String email;
  const FormSection({super.key, required this.email});

  @override
  State<FormSection> createState() => _FormSectionState();
}

class _FormSectionState extends State<FormSection> {
  final TextEditingController _code = TextEditingController();
  final TextEditingController _newPassword = TextEditingController();
  final TextEditingController _newPasswordCheck = TextEditingController();
  @override
  void dispose() {
    _code.dispose();
    _newPassword.dispose();
    _newPasswordCheck.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(32.0),
      child: Column(
        children: [
          TextField(
            controller: _code,
            maxLength: 6,
            decoration: InputDecoration(
              labelText: "6 Haneli Kodu Giriniz",
              prefixIcon: Icon(Icons.password),
            ),
          ),
          SizedBox(height: 16),
          TextField(
            controller: _newPassword,
            obscureText: true,
            decoration: InputDecoration(
              labelText: "Yeni Parolanızı Giriniz",
              prefixIcon: Icon(Icons.lock),
            ),
          ),
          SizedBox(height: 24),
          TextField(
            controller: _newPasswordCheck,
            obscureText: true,
            decoration: InputDecoration(
              labelText: "Yeni Parolanızı Tekrar Giriniz",
              prefixIcon: Icon(Icons.check),
            ),
          ),
          SizedBox(height: 36),
          GestureDetector(
            onTap: () async {
              String newPassword = _newPassword.text;
              final isSuccess = await AuthService.resetPassword(
                widget.email,
                newPassword,
                _newPasswordCheck.text,
                _code.text,
              );
              if (!context.mounted) return;
              if (isSuccess == true) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Şifreniz başarıyla değiştirildi.")),
                );
                context.push("/login");
              }
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
                "Parolayı Sıfırla",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
