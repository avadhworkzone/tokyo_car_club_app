enum AppLanguage { en, ja }

class AppStrings {
  AppStrings._();

  static const Map<AppLanguage, Map<String, String>> localizedValues = {
    AppLanguage.en: {
      'app_title': 'Tokyo Car Club',
      'home_title': 'Rent your dream car',
      'subtitle': 'Premium car rental in Tokyo',
      'pick_up_location': 'Pick-up location',
      'drop_off_location': 'Drop-off location',
      'pick_up_date': 'Pick-up date',
      'drop_off_date': 'Drop-off date',
      'search_cars': 'Search Cars',
      'loading': 'Loading...',
      'language': 'Language',
      'theme': 'Theme',
      'light_theme': 'Light',
      'dark_theme': 'Dark',
      'car_type': 'Car type',
      'economy': 'Economy',
      'suv': 'SUV',
      'luxury': 'Luxury',
    },
    AppLanguage.ja: {
      'app_title': '東京カー クラブ',
      'home_title': '憧れの車をレンタル',
      'subtitle': '東京でプレミアムレンタカー',
      'pick_up_location': 'ピックアップ場所',
      'drop_off_location': '返却場所',
      'pick_up_date': 'ピックアップ日',
      'drop_off_date': '返却日',
      'search_cars': '車を検索',
      'loading': '読み込み中...',
      'language': '言語',
      'theme': 'テーマ',
      'light_theme': 'ライト',
      'dark_theme': 'ダーク',
      'car_type': '車タイプ',
      'economy': 'エコノミー',
      'suv': 'SUV',
      'luxury': 'ラグジュアリー',
    },
  };
}
