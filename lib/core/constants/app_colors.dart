import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Theme-aware colors - use these methods instead of static colors
  static Color background(BuildContext context) =>
      Theme.of(context).scaffoldBackgroundColor;
  static Color surface(BuildContext context) => Theme.of(context).cardColor;
  static Color primary = const Color(0xFF007AFF);
  static Color onPrimary(BuildContext context) =>
      Theme.of(context).colorScheme.onPrimary;
  static Color onSurface(BuildContext context) =>
      Theme.of(context).colorScheme.onSurface;
  static Color onBackground(BuildContext context) =>
      Theme.of(context).colorScheme.onBackground;

  // Theme-aware colors that change with light/dark theme
  static Color accent(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
      ? const Color(0xFF007AFF)
      : const Color(0xFF0056CC);

  static Color cardBackground(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
      // ? const Color(0xFF1A1D29) : Colors.white;
      ? const Color(0xFF1A1D29)
      : const Color(0xFFF5F5F5);

  static Color gradientEnd(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
      ? const Color(0xFF2A2D3A)
      : const Color(0xFF64B5F6);

  // Theme-aware text colors
  static Color textPrimary(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
      ? Colors.white
      : Colors.black87;

  static Color textSecondary(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
      ? Colors.white70
      : Colors.black54;

  static Color textTertiary(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
      ? Colors.white54
      : Colors.black45;

  // Static colors that don't change with theme
  static const Color success = Color(0xFF2ECC71);
  static const Color warning = Color(0xFFF1C40F);
  static const Color error = Color(0xFFE74C3C);
  static const Color amber = Colors.amber;
  static const Color orangeAccent = Colors.orangeAccent;
  static const Color blueAccent = Colors.blueAccent;

  // Legacy colors - kept for backward compatibility but use theme-aware methods above
  static const Color darkBackground = Color(0xFF0A0D14);
  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static const Color white54 = Colors.white54;
  static const Color white70 = Colors.white70;
  static const Color white24 = Colors.white24;
  static const Color black87 = Colors.black87;
  static const Color black54 = Colors.black54;
  static const Color black45 = Colors.black45;
}
