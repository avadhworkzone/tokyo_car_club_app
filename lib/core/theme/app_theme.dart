import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  // CORE BRAND COLORS
  static const Color navy = Color(0xFF0D1B2A);
  static const Color royalBlue = Color(0xFF1E90FF);
  static const Color softCyan = Color(0xFF6EC6FF);

  // SECONDARY
  static const Color charcoal = Color(0xFF121212);
  static const Color silver = Color(0xFFE0E0E0);
  static const Color platinum = Color(0xFFC9D1D9);

  // ACCENTS
  static const Color success = Color(0xFF2ECC71);
  static const Color warning = Color(0xFFFF6B3D);
  static const Color gold = Color(0xFFF4C542);

  // LIGHT THEME (for users who prefer bright UI)
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: Colors.white,

    colorScheme: ColorScheme.light(
      primary: royalBlue,
      secondary: softCyan,
      surface: Colors.white,
    ),

    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: navy,
      ),
      bodyMedium: TextStyle(fontSize: 16, color: Colors.black87),
      bodySmall: TextStyle(fontSize: 14, color: Colors.black54),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      hintStyle: TextStyle(color: platinum),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: platinum),
      ),
      focusedBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(14)),
        borderSide: BorderSide(color: royalBlue, width: 1.6),
      ),
    ),
  );

  // DARK THEME (main premium car rental theme)
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: charcoal,

    colorScheme: ColorScheme.dark(
      primary: royalBlue,
      secondary: softCyan,
      surface: charcoal,
    ),

    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      bodyMedium: TextStyle(fontSize: 16, color: silver),
      bodySmall: TextStyle(fontSize: 14, color: platinum),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: navy,
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      hintStyle: TextStyle(color: silver),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: platinum),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: softCyan, width: 1.5),
      ),
    ),
  );
}
