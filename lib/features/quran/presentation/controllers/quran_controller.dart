import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import '../../../../shared/services/storage_service.dart';

class QuranController extends GetxController {
  final _dio = Dio(BaseOptions(
    baseUrl: 'https://api.alquran.cloud/v1',
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 30),
  ));

  final StorageService _storage = Get.find<StorageService>();

  final RxBool isPlaying = false.obs;
  final RxBool showTranslation = true.obs;
  final RxDouble fontSize = 24.0.obs;
  final RxString selectedReciter = 'Mishary Rashid Alafasy'.obs;
  final RxList<int> bookmarks = <int>[].obs;
  final RxInt currentPage = 1.obs;
  final RxInt currentSurah = 1.obs;

  final List<String> reciters = [
    'Mishary Rashid Alafasy',
    'Abdul Basit Abdul Samad',
    'Maher Al-Muaiqly',
    'Saud Al-Shuraim',
    'Abu Bakr Al-Shatri',
  ];

  void selectReciter(String reciter) {
    selectedReciter.value = reciter;
  }

  // --- Surahs list (API AlQuran.cloud) ---
  final RxList<Map<String, dynamic>> surahs = <Map<String, dynamic>>[].obs;
  final RxBool isLoadingSurahs = true.obs;
  final RxString surahsError = ''.obs;

  // --- Ayahs (API AlQuran.cloud) ---
  final RxList<Map<String, dynamic>> currentAyahs = <Map<String, dynamic>>[].obs;
  final RxBool isLoadingAyahs = false.obs;
  final RxInt loadedSurahNumber = 0.obs;
  final RxBool isCurrentSurahCached = false.obs;
  final RxBool isSaving = false.obs;

  @override
  void onInit() {
    super.onInit();
    currentPage.value = _storage.lastQuranPage;
    bookmarks.value = _storage.quranBookmarks;
    _loadSurahs();
  }

  Future<void> _loadSurahs() async {
    isLoadingSurahs.value = true;
    surahsError.value = '';
    try {
      final response = await _dio.get('/surah');
      if (response.statusCode == 200 && response.data['code'] == 200) {
        final list = response.data['data'] as List;
        surahs.value = list.map<Map<String, dynamic>>((s) => {
          'number': s['number'] as int,
          'name': s['englishName'] as String,
          'nameAr': s['name'] as String,
          'verses': s['numberOfAyahs'] as int,
          'type': (s['revelationType'] as String) == 'Meccan' ? 'Mecquoise' : 'Médinoise',
        }).toList();
      }
    } on DioException {
      surahsError.value = 'Connexion impossible. Vérifiez votre réseau.';
    } catch (_) {
      surahsError.value = 'Erreur inattendue.';
    } finally {
      isLoadingSurahs.value = false;
    }
  }

  Future<File> _cacheFile(int surahNumber) async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/quran_surah_$surahNumber.json');
  }

  Future<bool> isSurahCached(int surahNumber) async {
    final file = await _cacheFile(surahNumber);
    return file.existsSync();
  }

  Future<void> fetchSurahAyahs(int surahNumber) async {
    if (loadedSurahNumber.value == surahNumber && currentAyahs.isNotEmpty) return;
    isLoadingAyahs.value = true;
    currentAyahs.clear();

    // Check cache first
    final cached = await isSurahCached(surahNumber);
    isCurrentSurahCached.value = cached;

    if (cached) {
      try {
        final file = await _cacheFile(surahNumber);
        final data = jsonDecode(await file.readAsString()) as List;
        currentAyahs.value = data.cast<Map<String, dynamic>>();
        loadedSurahNumber.value = surahNumber;
        isLoadingAyahs.value = false;
        return;
      } catch (_) {
        // cache corrupted, fetch from network
      }
    }

    try {
      final response = await _dio.get(
        '/surah/$surahNumber/editions/quran-uthmani,fr.hamidullah',
      );
      if (response.statusCode == 200 && response.data['code'] == 200) {
        final editions = response.data['data'] as List;
        final arabicAyahs = editions[0]['ayahs'] as List;
        final frenchAyahs = editions[1]['ayahs'] as List;
        currentAyahs.value = List.generate(arabicAyahs.length, (i) => {
          'number': '${arabicAyahs[i]['numberInSurah']}',
          'arabic': arabicAyahs[i]['text'] as String,
          'translation': frenchAyahs[i]['text'] as String,
        });
        loadedSurahNumber.value = surahNumber;
      }
    } on DioException {
      Get.snackbar('Erreur', 'Impossible de charger les versets. Vérifiez votre connexion.');
    } catch (_) {
      Get.snackbar('Erreur', 'Erreur inattendue lors du chargement.');
    } finally {
      isLoadingAyahs.value = false;
    }
  }

  Future<void> saveSurahOffline(int surahNumber) async {
    if (currentAyahs.isEmpty) return;
    isSaving.value = true;
    try {
      final file = await _cacheFile(surahNumber);
      await file.writeAsString(jsonEncode(currentAyahs.toList()));
      isCurrentSurahCached.value = true;
      Get.snackbar(
        'Sauvegardé',
        'Sourate enregistrée pour la lecture hors-ligne',
        backgroundColor: Colors.green.shade600,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    } catch (_) {
      Get.snackbar('Erreur', 'Impossible de sauvegarder.');
    } finally {
      isSaving.value = false;
    }
  }

  Future<void> deleteSurahCache(int surahNumber) async {
    try {
      final file = await _cacheFile(surahNumber);
      if (file.existsSync()) await file.delete();
      isCurrentSurahCached.value = false;
      Get.snackbar('Supprimé', 'Sourate retirée du cache hors-ligne.',
          duration: const Duration(seconds: 2));
    } catch (_) {}
  }

  // --- Bookmarks & page ---
  void goToPage(int page) {
    currentPage.value = page;
    _storage.setLastQuranPage(page);
  }

  void toggleBookmark(int ayahNumber) {
    _storage.toggleQuranBookmark(ayahNumber);
    bookmarks.value = _storage.quranBookmarks;
  }

  bool isBookmarked(int page) => bookmarks.contains(page);

  // --- Playback ---
  void togglePlayPause() => isPlaying.value = !isPlaying.value;

  // --- Display ---
  void toggleTranslation() => showTranslation.value = !showTranslation.value;

  void increaseFontSize() {
    if (fontSize.value < 36) fontSize.value += 2;
  }

  void decreaseFontSize() {
    if (fontSize.value > 16) fontSize.value -= 2;
  }

  Future<void> retrySurahs() => _loadSurahs();
}
