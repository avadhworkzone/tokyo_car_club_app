import 'package:equatable/equatable.dart';

abstract class SettingsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class SettingsInitial extends SettingsState {}

class SettingsLoading extends SettingsState {}

class SettingsLoaded extends SettingsState {
  final bool isDarkMode;
  final String language;
  
  SettingsLoaded({
    required this.isDarkMode,
    required this.language,
  });
  
  @override
  List<Object?> get props => [isDarkMode, language];
}

class SettingsError extends SettingsState {
  final String message;
  
  SettingsError(this.message);
  
  @override
  List<Object?> get props => [message];
}