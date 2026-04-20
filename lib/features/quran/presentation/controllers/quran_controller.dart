import 'package:get/get.dart' hide TextDirection;
import '../../../../shared/services/storage_service.dart';

class QuranController extends GetxController {
  final StorageService _storage = Get.find<StorageService>();

  final RxInt currentPage = 1.obs;
  final RxInt currentSurah = 1.obs;
  final RxBool isPlaying = false.obs;
  final RxBool showTranslation = true.obs;
  final RxDouble fontSize = 24.0.obs;
  final RxString selectedReciter = 'Mishary Rashid Alafasy'.obs;
  final RxList<int> bookmarks = <int>[].obs;
  final RxBool isLoading = false.obs;

  final List<Map<String, dynamic>> surahs = [
    {'number': 1, 'name': 'Al-Fatihah', 'nameAr': 'الفاتحة', 'verses': 7, 'juz': 1, 'type': 'Mecquoise'},
    {'number': 2, 'name': 'Al-Baqarah', 'nameAr': 'البقرة', 'verses': 286, 'juz': 1, 'type': 'Médinoise'},
    {'number': 3, 'name': 'Ali Imran', 'nameAr': 'آل عمران', 'verses': 200, 'juz': 3, 'type': 'Médinoise'},
    {'number': 4, 'name': "An-Nisa'", 'nameAr': 'النساء', 'verses': 176, 'juz': 4, 'type': 'Médinoise'},
    {'number': 5, 'name': 'Al-Maidah', 'nameAr': 'المائدة', 'verses': 120, 'juz': 6, 'type': 'Médinoise'},
    {'number': 6, 'name': 'Al-Anam', 'nameAr': 'الأنعام', 'verses': 165, 'juz': 7, 'type': 'Mecquoise'},
    {'number': 7, 'name': 'Al-Araf', 'nameAr': 'الأعراف', 'verses': 206, 'juz': 8, 'type': 'Mecquoise'},
    {'number': 8, 'name': 'Al-Anfal', 'nameAr': 'الأنفال', 'verses': 75, 'juz': 9, 'type': 'Médinoise'},
    {'number': 9, 'name': 'At-Tawbah', 'nameAr': 'التوبة', 'verses': 129, 'juz': 10, 'type': 'Médinoise'},
    {'number': 10, 'name': 'Yunus', 'nameAr': 'يونس', 'verses': 109, 'juz': 11, 'type': 'Mecquoise'},
    {'number': 36, 'name': 'Ya-Sin', 'nameAr': 'يس', 'verses': 83, 'juz': 22, 'type': 'Mecquoise'},
    {'number': 55, 'name': 'Ar-Rahman', 'nameAr': 'الرحمن', 'verses': 78, 'juz': 27, 'type': 'Médinoise'},
    {'number': 56, 'name': 'Al-Waqiah', 'nameAr': 'الواقعة', 'verses': 96, 'juz': 27, 'type': 'Mecquoise'},
    {'number': 67, 'name': 'Al-Mulk', 'nameAr': 'الملك', 'verses': 30, 'juz': 29, 'type': 'Mecquoise'},
    {'number': 112, 'name': 'Al-Ikhlas', 'nameAr': 'الإخلاص', 'verses': 4, 'juz': 30, 'type': 'Mecquoise'},
    {'number': 113, 'name': 'Al-Falaq', 'nameAr': 'الفلق', 'verses': 5, 'juz': 30, 'type': 'Mecquoise'},
    {'number': 114, 'name': 'An-Nas', 'nameAr': 'الناس', 'verses': 6, 'juz': 30, 'type': 'Mecquoise'},
  ];

  final List<String> reciters = [
    'Mishary Rashid Alafasy',
    'Abdul Rahman Al-Sudais',
    'Saud Al-Shuraim',
    'Maher Al Muaiqly',
    'Ibrahim Al-Akhdar',
    'Yasser Al-Dosari',
  ];

  @override
  void onInit() {
    super.onInit();
    currentPage.value = _storage.lastQuranPage;
    bookmarks.value = _storage.quranBookmarks;
  }

  void goToPage(int page) {
    currentPage.value = page;
    _storage.setLastQuranPage(page);
  }

  void togglePlayPause() => isPlaying.value = !isPlaying.value;

  void toggleTranslation() => showTranslation.value = !showTranslation.value;

  void toggleBookmark(int page) {
    _storage.toggleQuranBookmark(page);
    bookmarks.value = _storage.quranBookmarks;
  }

  bool isBookmarked(int page) => bookmarks.contains(page);

  void increaseFontSize() {
    if (fontSize.value < 36) fontSize.value += 2;
  }

  void decreaseFontSize() {
    if (fontSize.value > 16) fontSize.value -= 2;
  }

  void selectReciter(String reciter) => selectedReciter.value = reciter;
}
