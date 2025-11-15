import 'package:flutter/material.dart';

final ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  scaffoldBackgroundColor: const Color(0xFFFAF7F2),
  colorScheme:  ColorScheme.light(
    primary: Color(0xFF8C7A5B),
    secondary: Color(0xFFC4B8A1),
    surface: Color(0xFFEFE8DE),
    onPrimary: Colors.white,
    onSecondary: Colors.black,
    onSurface: Colors.black87,
  ),
);

final ThemeData darkTheme = ThemeData(
  useMaterial3: true,

  brightness: Brightness.dark,
  scaffoldBackgroundColor: const Color(0xFF1F1C18),
  colorScheme: const ColorScheme.dark(
    primary: Color(0xFF9F8C6A),
    secondary: Color(0xFF6A5E4B),
    surface: Color(0xFF2A2622),
    onPrimary: Colors.black,
    onSecondary: Color.fromARGB(239, 255, 255, 255),
    onSurface: Color.fromARGB(225, 255, 255, 255),
  ),
);
