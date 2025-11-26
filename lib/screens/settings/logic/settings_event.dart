import 'package:equatable/equatable.dart';

abstract class SettingsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadSettingsEvent extends SettingsEvent {}

class ToggleDarkModeEvent extends SettingsEvent {
  final bool isDarkMode;
  
  ToggleDarkModeEvent(this.isDarkMode);
  
  @override
  List<Object?> get props => [isDarkMode];
}

class ChangeLanguageEvent extends SettingsEvent {
  final String language;
  
  ChangeLanguageEvent(this.language);
  
  @override
  List<Object?> get props => [language];
}