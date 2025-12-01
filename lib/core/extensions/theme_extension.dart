import 'package:flutter/material.dart';

extension ThemeExtension on BuildContext {
  // Quick access to theme colors
  Color get primaryColor => Theme.of(this).colorScheme.primary;
  Color get backgroundColor => Theme.of(this).scaffoldBackgroundColor;
  Color get surfaceColor => Theme.of(this).cardColor;
  Color get textColor => Theme.of(this).colorScheme.onBackground;
  Color get onSurfaceColor => Theme.of(this).colorScheme.onSurface;
  
  // Quick access to text styles
  TextStyle? get headlineStyle => Theme.of(this).textTheme.headlineLarge;
  TextStyle? get titleStyle => Theme.of(this).textTheme.titleLarge;
  TextStyle? get bodyStyle => Theme.of(this).textTheme.bodyMedium;
  
  // Check if dark mode
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;
}