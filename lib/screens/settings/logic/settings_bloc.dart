import 'package:flutter_bloc/flutter_bloc.dart';
import 'settings_event.dart';
import 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc() : super(SettingsInitial()) {
    on<LoadSettingsEvent>((event, emit) async {
      emit(SettingsLoading());
      try {
        await Future.delayed(const Duration(seconds: 1));
        emit(SettingsLoaded(
          isDarkMode: true,
          language: 'English',
        ));
      } catch (e) {
        emit(SettingsError(e.toString()));
      }
    });

    on<ToggleDarkModeEvent>((event, emit) async {
      if (state is SettingsLoaded) {
        final currentState = state as SettingsLoaded;
        emit(SettingsLoaded(
          isDarkMode: event.isDarkMode,
          language: currentState.language,
        ));
      }
    });

    on<ChangeLanguageEvent>((event, emit) async {
      if (state is SettingsLoaded) {
        final currentState = state as SettingsLoaded;
        emit(SettingsLoaded(
          isDarkMode: currentState.isDarkMode,
          language: event.language,
        ));
      }
    });
  }
}