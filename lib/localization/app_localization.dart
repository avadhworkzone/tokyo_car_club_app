import '../core/constants/app_strings.dart';

class AppLocalization {
  AppLocalization._internal();

  static final AppLocalization _instance = AppLocalization._internal();

  static AppLocalization get instance => _instance;

  AppLanguage _currentLanguage = AppLanguage.en;

  void setLanguage(AppLanguage language) {
    _currentLanguage = language;
  }

  AppLanguage get currentLanguage => _currentLanguage;

  String translate(String key) {
    return AppStrings.localizedValues[_currentLanguage]?[key] ?? key;
  }
}
