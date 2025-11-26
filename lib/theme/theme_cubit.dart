import 'package:flutter_bloc/flutter_bloc.dart';
import 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(const ThemeState(themeMode: AppThemeMode.light));

  void toggleTheme() {
    final newMode = state.themeMode == AppThemeMode.light
        ? AppThemeMode.dark
        : AppThemeMode.light;
    emit(state.copyWith(themeMode: newMode));
  }

  void setTheme(AppThemeMode mode) {
    emit(state.copyWith(themeMode: mode));
  }
}
