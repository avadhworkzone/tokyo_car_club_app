import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  static const String _themeKey = 'theme_mode';
  
  ThemeCubit() : super(const ThemeState(themeMode: AppThemeMode.dark)) {
    _loadTheme();
  }

  static Future<ThemeCubit> create() async {
    final cubit = ThemeCubit._internal();
    await cubit._loadTheme();
    return cubit;
  }

  ThemeCubit._internal() : super(const ThemeState(themeMode: AppThemeMode.dark));

  Future<void> _loadTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isDark = prefs.getBool(_themeKey) ?? true; // Default to dark theme
      emit(ThemeState(themeMode: isDark ? AppThemeMode.dark : AppThemeMode.light));
    } catch (e) {
      // If loading fails, use default dark theme
      emit(const ThemeState(themeMode: AppThemeMode.dark));
    }
  }

  Future<void> toggleTheme() async {
    final newMode = state.themeMode == AppThemeMode.light
        ? AppThemeMode.dark
        : AppThemeMode.light;
    await _saveTheme(newMode);
    emit(state.copyWith(themeMode: newMode));
  }

  Future<void> setTheme(AppThemeMode mode) async {
    await _saveTheme(mode);
    emit(state.copyWith(themeMode: mode));
  }

  Future<void> _saveTheme(AppThemeMode mode) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_themeKey, mode == AppThemeMode.dark);
    } catch (e) {
      // Handle save error silently
    }
  }

  bool get isDarkMode => state.themeMode == AppThemeMode.dark;
}
