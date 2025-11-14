import 'package:flutter/material.dart';

final appTheme = ThemeData(
  useMaterial3: false,
  colorScheme: ColorScheme.light(
    // for scaffold background color
    surface: Color.fromARGB(255, 255, 251, 222),
    primary: Color.fromARGB(255, 106, 167, 226),
    onPrimary: Colors.black,
    secondary: Color.fromARGB(255, 161, 209, 255),
    onSecondary: Colors.black,
    tertiary: Colors.white,
    onTertiary: Colors.black,
  ),
  scaffoldBackgroundColor: const Color.fromARGB(255, 255, 251, 222),
);