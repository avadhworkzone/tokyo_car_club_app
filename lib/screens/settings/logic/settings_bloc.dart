import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../theme/theme_cubit.dart';
import '../../../theme/theme_state.dart';
import 'settings_event.dart';
import 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final ThemeCubit themeCubit;
  
  SettingsBloc(this.themeCubit) : super(SettingsInitial()) {
    on<LoadSettingsEvent>((event, emit) async {
      emit(SettingsLoading());
      try {
        final prefs = await SharedPreferences.getInstance();
        final language = prefs.getString('language') ?? 'English';
        
        emit(SettingsLoaded(
          isDarkMode: themeCubit.isDarkMode,
          language: language,
        ));
      } catch (e) {
        emit(SettingsError(e.toString()));
      }
    });

    on<ToggleDarkModeEvent>((event, emit) async {
      if (state is SettingsLoaded) {
        final currentState = state as SettingsLoaded;
        
        // Update theme through ThemeCubit
        if (event.isDarkMode) {
          await themeCubit.setTheme(AppThemeMode.dark);
        } else {
          await themeCubit.setTheme(AppThemeMode.light);
        }
        
        emit(SettingsLoaded(
          isDarkMode: event.isDarkMode,
          language: currentState.language,
        ));
      }
    });

    on<ChangeLanguageEvent>((event, emit) async {
      if (state is SettingsLoaded) {
        final currentState = state as SettingsLoaded;
        
        // Save language preference
        try {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('language', event.language);
        } catch (e) {
          // Handle error silently
        }
        
        emit(SettingsLoaded(
          isDarkMode: currentState.isDarkMode,
          language: event.language,
        ));
      }
    });
  }
}