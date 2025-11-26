import 'package:equatable/equatable.dart';
import '../core/constants/app_strings.dart';

class LocaleState extends Equatable {
  final AppLanguage language;

  const LocaleState({required this.language});

  LocaleState copyWith({AppLanguage? language}) {
    return LocaleState(language: language ?? this.language);
  }

  @override
  List<Object?> get props => [language];
}
