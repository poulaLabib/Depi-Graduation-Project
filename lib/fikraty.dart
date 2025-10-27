import 'package:depi_graduation_project/custom%20widgets/auth_gate.dart';
// import 'package:depi_graduation_project/screens/investor_main_screen.dart';
import 'package:depi_graduation_project/theme/themes.dart';
import 'package:flutter/material.dart';

class Fikraty extends StatelessWidget {
  const Fikraty({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: appTheme,
      home: AuthGate(),
    );
  }
}