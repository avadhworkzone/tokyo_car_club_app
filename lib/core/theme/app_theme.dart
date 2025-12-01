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

  // GRADIENT COLORS FOR LIGHT THEME
  static const Color lightGradientStart = Color(0xFF4FC3F7);
  static const Color lightGradientEnd = Color(0xFF29B6F6);

  // LIGHT THEME (for users who prefer bright UI)
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: const Color(0xFFF8FAFC), // Clean light blue-gray
    // scaffoldBackgroundColor: const Color(0xFFFEEF8FE), // Clean light blue-gray
    useMaterial3: true,

    colorScheme: ColorScheme.light(
      primary: royalBlue,
      secondary: softCyan,
      surface: Colors.white,
      background: const Color(0xFFF8FAFC),
      onPrimary: Colors.white,
      onSecondary: navy,
      onSurface: navy,
      onBackground: navy,
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: navy,
      elevation: 0,
      centerTitle: true,
    ),

    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 3,
      shadowColor: royalBlue.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),

    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: navy,
      ),
      headlineMedium: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: navy,
      ),
      titleLarge: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: navy,
      ),
      bodyLarge: TextStyle(fontSize: 18, color: Colors.black87),
      bodyMedium: TextStyle(fontSize: 16, color: Colors.black87),
      bodySmall: TextStyle(fontSize: 14, color: Colors.black54),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.grey.shade50,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      hintStyle: const TextStyle(color: platinum),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: platinum),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: platinum),
      ),
      focusedBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(14)),
        borderSide: BorderSide(color: royalBlue, width: 2),
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: royalBlue,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      ),
    ),
  );

  // DARK THEME (main premium car rental theme)
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: charcoal,
    useMaterial3: true,

    colorScheme: ColorScheme.dark(
      primary: royalBlue,
      secondary: softCyan,
      surface: navy,
      background: charcoal,
      onPrimary: Colors.white,
      onSecondary: charcoal,
      onSurface: Colors.white,
      onBackground: Colors.white,
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: charcoal,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
    ),

    cardTheme: CardThemeData(
      color: navy,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),

    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      headlineMedium: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
      titleLarge: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
      bodyLarge: TextStyle(fontSize: 18, color: silver),
      bodyMedium: TextStyle(fontSize: 16, color: silver),
      bodySmall: TextStyle(fontSize: 14, color: platinum),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: navy,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      hintStyle: const TextStyle(color: silver),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: platinum),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: platinum),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: softCyan, width: 2),
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: royalBlue,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      ),
    ),

    switchTheme: SwitchThemeData(
      thumbColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return softCyan;
        }
        return silver;
      }),
      trackColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return softCyan.withOpacity(0.3);
        }
        return platinum.withOpacity(0.3);
      }),
    ),
  );
}
