
import 'package:tokyo_car_club/localization/app_localization.dart';

class StringUtils {
  StringUtils._();

  static String t(String key) {
    return AppLocalization.instance.translate(key);
  }
}
