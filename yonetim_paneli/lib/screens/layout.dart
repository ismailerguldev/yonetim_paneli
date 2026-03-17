import 'package:flutter/material.dart';

class Layout extends StatelessWidget {
  final Widget child;
  const Layout({super.key, required this.child});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(bottom: true, top: true, child: child),
      backgroundColor: Color(0xFFF8F9FA),
    );
  }
}
