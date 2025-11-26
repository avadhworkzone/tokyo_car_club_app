import 'package:flutter_bloc/flutter_bloc.dart';
import '../core/constants/app_strings.dart';
import '../localization/app_localization.dart';
import 'locale_state.dart';

class LocaleCubit extends Cubit<LocaleState> {
  LocaleCubit() : super(const LocaleState(language: AppLanguage.en)) {
    AppLocalization.instance.setLanguage(state.language);
  }

  void changeLanguage(AppLanguage language) {
    AppLocalization.instance.setLanguage(language);
    emit(state.copyWith(language: language));
  }

}
