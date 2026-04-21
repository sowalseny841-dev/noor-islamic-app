import 'package:dio/dio.dart';
import 'package:get/get.dart';
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

  final RxList<Map<String, dynamic>> surahs = <Map<String, dynamic>>[].obs;
  final RxBool isLoadingSurahs = true.obs;
  final RxString surahsError = ''.obs;

  final RxList<Map<String, dynamic>> currentAyahs = <Map<String, dynamic>>[].obs;
  final RxBool isLoadingAyahs = false.obs;
  final RxInt loadedSurahNumber = 0.obs;

  @override
  void onInit() {
    super.onInit();
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

  Future<void> fetchSurahAyahs(int surahNumber) async {
    if (loadedSurahNumber.value == surahNumber && currentAyahs.isNotEmpty) return;
    isLoadingAyahs.value = true;
    currentAyahs.clear();
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

  void toggleBookmark(int ayahNumber) {
    _storage.toggleQuranBookmark(ayahNumber);
    bookmarks.value = _storage.quranBookmarks;
  }

  void togglePlayPause() {
    isPlaying.value = !isPlaying.value;
  }

  Future<void> retrySurahs() => _loadSurahs();
}
