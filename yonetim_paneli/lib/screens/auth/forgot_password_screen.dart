import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:yonetim_paneli/core/services/auth_service.dart';

class FPasswordScreen extends StatelessWidget {
  const FPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Parolanızı Sıfırlayın",
          style: TextStyle(color: Colors.black, fontSize: 22),
        ),
        SizedBox(height: 16),
        FormSection(),
      ],
    );
  }
}

class FormSection extends StatefulWidget {
  const FormSection({super.key});

  @override
  State<FormSection> createState() => _FormSectionState();
}

class _FormSectionState extends State<FormSection> {
  final TextEditingController email = TextEditingController();
  @override
  void dispose() {
    email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        children: [
          TextField(
            controller: email,
            decoration: InputDecoration(
              labelText: "E-postanızı giriniz",
              prefixIcon: Icon(Icons.email),
            ),
          ),
          SizedBox(height: 16),
          GestureDetector(
            onTap: () async {
              final isOkay = await AuthService.forgotPassword(email.text);
              if (!context.mounted) return;
              if (isOkay == true) {
                context.push("/reset-password", extra: email.text);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Bir hata meydana geldi.")),
                );
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
                "Kod Gönder",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
