import 'package:depi_graduation_project/custom%20widgets/auth_gate.dart';
// import 'package:depi_graduation_project/screens/investor_main_screen.dart';
import 'package:depi_graduation_project/theme/themes.dart';
import 'package:flutter/material.dart';

class Fikraty extends StatefulWidget {
  const Fikraty({super.key});

  @override
  State<Fikraty> createState() => _FikratyState();
}

class _FikratyState extends State<Fikraty> {
  ThemeMode _themeMode = ThemeMode.system;

  void toggleTheme() {
    setState(() {
      if (_themeMode == ThemeMode.light) {
        _themeMode = ThemeMode.dark;
      } else if (_themeMode == ThemeMode.dark) {
        _themeMode = ThemeMode.light;
      } else {
        // If system, check current brightness and switch
        final brightness = MediaQuery.of(context).platformBrightness;
        _themeMode =
            brightness == Brightness.dark ? ThemeMode.light : ThemeMode.dark;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: _themeMode,
      home: AuthGate(),
    );
  }
}
