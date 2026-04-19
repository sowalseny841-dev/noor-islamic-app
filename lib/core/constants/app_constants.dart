class AppConstants {
  static const String appName = 'Noor';
  static const String appVersion = '1.0.0';

  // Default location (Conakry, Guinea)
  static const double defaultLatitude = 9.5370;
  static const double defaultLongitude = -13.6773;
  static const String defaultCity = 'Conakry';
  static const String defaultCountry = 'Guinée';

  // Prayer calculation method
  static const String defaultCalculationMethod = 'MuslimWorldLeague';

  // Storage keys
  static const String keyOnboardingDone = 'onboarding_done';
  static const String keyThemeMode = 'theme_mode';
  static const String keyLanguage = 'language';
  static const String keyLocation = 'location';
  static const String keyCalculationMethod = 'calculation_method';
  static const String keyAzkarProgress = 'azkar_progress';
  static const String keyLastQuranPage = 'last_quran_page';
  static const String keyQuranBookmarks = 'quran_bookmarks';
  static const String keyTasbihCounts = 'tasbih_counts';
  static const String keyNotificationsEnabled = 'notifications_enabled';
  static const String keyAdhanSound = 'adhan_sound';

  // Prayer names
  static const List<String> prayerNames = [
    'Fajr',
    'Lever du soleil',
    'Dhuhr',
    'Asr',
    'Maghrib',
    'Isha',
  ];

  static const List<String> prayerNamesAr = [
    'الفجر',
    'الشروق',
    'الظهر',
    'العصر',
    'المغرب',
    'العشاء',
  ];
}
