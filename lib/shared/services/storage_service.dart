import 'package:get/get.dart' hide TextDirection;
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/app_constants.dart';

class StorageService extends GetxService {
  late SharedPreferences _prefs;

  Future<StorageService> init() async {
    _prefs = await SharedPreferences.getInstance();
    return this;
  }

  bool get isOnboardingDone =>
      _prefs.getBool(AppConstants.keyOnboardingDone) ?? false;

  Future<void> setOnboardingDone() =>
      _prefs.setBool(AppConstants.keyOnboardingDone, true);

  String get themeMode => _prefs.getString(AppConstants.keyThemeMode) ?? 'system';
  Future<void> setThemeMode(String mode) =>
      _prefs.setString(AppConstants.keyThemeMode, mode);

  String get language => _prefs.getString(AppConstants.keyLanguage) ?? 'fr';
  Future<void> setLanguage(String lang) =>
      _prefs.setString(AppConstants.keyLanguage, lang);

  double get latitude =>
      _prefs.getDouble('latitude') ?? AppConstants.defaultLatitude;
  double get longitude =>
      _prefs.getDouble('longitude') ?? AppConstants.defaultLongitude;
  String get cityName =>
      _prefs.getString('city_name') ?? AppConstants.defaultCity;

  Future<void> saveLocation({
    required double lat,
    required double lng,
    required String city,
  }) async {
    await _prefs.setDouble('latitude', lat);
    await _prefs.setDouble('longitude', lng);
    await _prefs.setString('city_name', city);
  }

  String get calculationMethod =>
      _prefs.getString(AppConstants.keyCalculationMethod) ??
      AppConstants.defaultCalculationMethod;
  Future<void> setCalculationMethod(String method) =>
      _prefs.setString(AppConstants.keyCalculationMethod, method);

  bool get notificationsEnabled =>
      _prefs.getBool(AppConstants.keyNotificationsEnabled) ?? true;
  Future<void> setNotificationsEnabled(bool val) =>
      _prefs.setBool(AppConstants.keyNotificationsEnabled, val);

  int get lastQuranPage =>
      _prefs.getInt(AppConstants.keyLastQuranPage) ?? 1;
  Future<void> setLastQuranPage(int page) =>
      _prefs.setInt(AppConstants.keyLastQuranPage, page);

  List<int> get quranBookmarks {
    final list = _prefs.getStringList(AppConstants.keyQuranBookmarks) ?? [];
    return list.map((e) => int.tryParse(e) ?? 0).toList();
  }

  Future<void> toggleQuranBookmark(int page) async {
    final bookmarks = quranBookmarks;
    if (bookmarks.contains(page)) {
      bookmarks.remove(page);
    } else {
      bookmarks.add(page);
    }
    await _prefs.setStringList(
      AppConstants.keyQuranBookmarks,
      bookmarks.map((e) => e.toString()).toList(),
    );
  }

  Map<String, int> get azkarProgress {
    final keys = _prefs.getKeys()
        .where((k) => k.startsWith('azkar_progress_'))
        .toList();
    final map = <String, int>{};
    for (final k in keys) {
      map[k.replaceFirst('azkar_progress_', '')] = _prefs.getInt(k) ?? 0;
    }
    return map;
  }

  Future<void> setAzkarProgress(String categoryId, int count) =>
      _prefs.setInt('azkar_progress_$categoryId', count);

  int get tasbihCount => _prefs.getInt('tasbih_count') ?? 0;
  Future<void> setTasbihCount(int val) => _prefs.setInt('tasbih_count', val);

  Future<void> resetDailyProgress() async {
    final keys = _prefs.getKeys()
        .where((k) => k.startsWith('azkar_progress_'))
        .toList();
    for (final k in keys) {
      await _prefs.remove(k);
    }
  }
}
