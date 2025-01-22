import 'package:flutter/material.dart';

//light mode
ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    surface: const Color.fromARGB(255, 209, 209, 209),
    primary: Colors.grey.shade200,
    secondary: const Color.fromARGB(255, 172, 172, 172),
    inversePrimary: Colors.grey.shade800,
  ),
);

//dark mode
ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    surface: Colors.grey.shade900,
    primary: Colors.grey.shade800,
    secondary: Colors.grey.shade300,
    inversePrimary: Colors.grey.shade300,
  ),
);
