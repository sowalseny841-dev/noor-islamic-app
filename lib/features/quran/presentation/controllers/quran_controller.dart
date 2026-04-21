import 'package:get/get.dart';
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
    {'number': 1,   'name': 'Al-Fatihah',    'nameAr': 'الفاتحة',        'verses': 7,   'juz': 1,  'type': 'Mecquoise'},
    {'number': 2,   'name': 'Al-Baqarah',    'nameAr': 'البقرة',          'verses': 286, 'juz': 1,  'type': 'Médinoise'},
    {'number': 3,   'name': 'Ali Imran',     'nameAr': 'آل عمران',        'verses': 200, 'juz': 3,  'type': 'Médinoise'},
    {'number': 4,   'name': "An-Nisa'",      'nameAr': 'النساء',          'verses': 176, 'juz': 4,  'type': 'Médinoise'},
    {'number': 5,   'name': 'Al-Maidah',     'nameAr': 'المائدة',         'verses': 120, 'juz': 6,  'type': 'Médinoise'},
    {'number': 6,   'name': 'Al-Anam',       'nameAr': 'الأنعام',         'verses': 165, 'juz': 7,  'type': 'Mecquoise'},
    {'number': 7,   'name': 'Al-Araf',       'nameAr': 'الأعراف',         'verses': 206, 'juz': 8,  'type': 'Mecquoise'},
    {'number': 8,   'name': 'Al-Anfal',      'nameAr': 'الأنفال',         'verses': 75,  'juz': 9,  'type': 'Médinoise'},
    {'number': 9,   'name': 'At-Tawbah',     'nameAr': 'التوبة',          'verses': 129, 'juz': 10, 'type': 'Médinoise'},
    {'number': 10,  'name': 'Yunus',         'nameAr': 'يونس',            'verses': 109, 'juz': 11, 'type': 'Mecquoise'},
    {'number': 11,  'name': 'Hud',           'nameAr': 'هود',             'verses': 123, 'juz': 11, 'type': 'Mecquoise'},
    {'number': 12,  'name': 'Yusuf',         'nameAr': 'يوسف',            'verses': 111, 'juz': 12, 'type': 'Mecquoise'},
    {'number': 13,  'name': 'Ar-Rad',        'nameAr': 'الرعد',           'verses': 43,  'juz': 13, 'type': 'Médinoise'},
    {'number': 14,  'name': 'Ibrahim',       'nameAr': 'إبراهيم',         'verses': 52,  'juz': 13, 'type': 'Mecquoise'},
    {'number': 15,  'name': 'Al-Hijr',       'nameAr': 'الحجر',           'verses': 99,  'juz': 14, 'type': 'Mecquoise'},
    {'number': 16,  'name': 'An-Nahl',       'nameAr': 'النحل',           'verses': 128, 'juz': 14, 'type': 'Mecquoise'},
    {'number': 17,  'name': 'Al-Isra',       'nameAr': 'الإسراء',         'verses': 111, 'juz': 15, 'type': 'Mecquoise'},
    {'number': 18,  'name': 'Al-Kahf',       'nameAr': 'الكهف',           'verses': 110, 'juz': 15, 'type': 'Mecquoise'},
    {'number': 19,  'name': 'Maryam',        'nameAr': 'مريم',            'verses': 98,  'juz': 16, 'type': 'Mecquoise'},
    {'number': 20,  'name': 'Ta-Ha',         'nameAr': 'طه',              'verses': 135, 'juz': 16, 'type': 'Mecquoise'},
    {'number': 21,  'name': 'Al-Anbiya',     'nameAr': 'الأنبياء',        'verses': 112, 'juz': 17, 'type': 'Mecquoise'},
    {'number': 22,  'name': 'Al-Hajj',       'nameAr': 'الحج',            'verses': 78,  'juz': 17, 'type': 'Médinoise'},
    {'number': 23,  'name': 'Al-Muminun',    'nameAr': 'المؤمنون',        'verses': 118, 'juz': 18, 'type': 'Mecquoise'},
    {'number': 24,  'name': 'An-Nur',        'nameAr': 'النور',           'verses': 64,  'juz': 18, 'type': 'Médinoise'},
    {'number': 25,  'name': 'Al-Furqan',     'nameAr': 'الفرقان',         'verses': 77,  'juz': 18, 'type': 'Mecquoise'},
    {'number': 26,  'name': 'Ash-Shuara',    'nameAr': 'الشعراء',         'verses': 227, 'juz': 19, 'type': 'Mecquoise'},
    {'number': 27,  'name': 'An-Naml',       'nameAr': 'النمل',           'verses': 93,  'juz': 19, 'type': 'Mecquoise'},
    {'number': 28,  'name': 'Al-Qasas',      'nameAr': 'القصص',           'verses': 88,  'juz': 20, 'type': 'Mecquoise'},
    {'number': 29,  'name': 'Al-Ankabut',    'nameAr': 'العنكبوت',        'verses': 69,  'juz': 20, 'type': 'Mecquoise'},
    {'number': 30,  'name': 'Ar-Rum',        'nameAr': 'الروم',           'verses': 60,  'juz': 21, 'type': 'Mecquoise'},
    {'number': 31,  'name': 'Luqman',        'nameAr': 'لقمان',           'verses': 34,  'juz': 21, 'type': 'Mecquoise'},
    {'number': 32,  'name': 'As-Sajdah',     'nameAr': 'السجدة',          'verses': 30,  'juz': 21, 'type': 'Mecquoise'},
    {'number': 33,  'name': 'Al-Ahzab',      'nameAr': 'الأحزاب',         'verses': 73,  'juz': 21, 'type': 'Médinoise'},
    {'number': 34,  'name': 'Saba',          'nameAr': 'سبأ',             'verses': 54,  'juz': 22, 'type': 'Mecquoise'},
    {'number': 35,  'name': 'Fatir',         'nameAr': 'فاطر',            'verses': 45,  'juz': 22, 'type': 'Mecquoise'},
    {'number': 36,  'name': 'Ya-Sin',        'nameAr': 'يس',              'verses': 83,  'juz': 22, 'type': 'Mecquoise'},
    {'number': 37,  'name': 'As-Saffat',     'nameAr': 'الصافات',         'verses': 182, 'juz': 23, 'type': 'Mecquoise'},
    {'number': 38,  'name': 'Sad',           'nameAr': 'ص',               'verses': 88,  'juz': 23, 'type': 'Mecquoise'},
    {'number': 39,  'name': 'Az-Zumar',      'nameAr': 'الزمر',           'verses': 75,  'juz': 23, 'type': 'Mecquoise'},
    {'number': 40,  'name': 'Ghafir',        'nameAr': 'غافر',            'verses': 85,  'juz': 24, 'type': 'Mecquoise'},
    {'number': 41,  'name': 'Fussilat',      'nameAr': 'فصلت',            'verses': 54,  'juz': 24, 'type': 'Mecquoise'},
    {'number': 42,  'name': 'Ash-Shura',     'nameAr': 'الشورى',          'verses': 53,  'juz': 25, 'type': 'Mecquoise'},
    {'number': 43,  'name': 'Az-Zukhruf',    'nameAr': 'الزخرف',          'verses': 89,  'juz': 25, 'type': 'Mecquoise'},
    {'number': 44,  'name': 'Ad-Dukhan',     'nameAr': 'الدخان',          'verses': 59,  'juz': 25, 'type': 'Mecquoise'},
    {'number': 45,  'name': 'Al-Jathiyah',   'nameAr': 'الجاثية',         'verses': 37,  'juz': 25, 'type': 'Mecquoise'},
    {'number': 46,  'name': 'Al-Ahqaf',      'nameAr': 'الأحقاف',         'verses': 35,  'juz': 26, 'type': 'Mecquoise'},
    {'number': 47,  'name': 'Muhammad',      'nameAr': 'محمد',            'verses': 38,  'juz': 26, 'type': 'Médinoise'},
    {'number': 48,  'name': 'Al-Fath',       'nameAr': 'الفتح',           'verses': 29,  'juz': 26, 'type': 'Médinoise'},
    {'number': 49,  'name': 'Al-Hujurat',    'nameAr': 'الحجرات',         'verses': 18,  'juz': 26, 'type': 'Médinoise'},
    {'number': 50,  'name': 'Qaf',           'nameAr': 'ق',               'verses': 45,  'juz': 26, 'type': 'Mecquoise'},
    {'number': 51,  'name': 'Adh-Dhariyat',  'nameAr': 'الذاريات',        'verses': 60,  'juz': 26, 'type': 'Mecquoise'},
    {'number': 52,  'name': 'At-Tur',        'nameAr': 'الطور',           'verses': 49,  'juz': 27, 'type': 'Mecquoise'},
    {'number': 53,  'name': 'An-Najm',       'nameAr': 'النجم',           'verses': 62,  'juz': 27, 'type': 'Mecquoise'},
    {'number': 54,  'name': 'Al-Qamar',      'nameAr': 'القمر',           'verses': 55,  'juz': 27, 'type': 'Mecquoise'},
    {'number': 55,  'name': 'Ar-Rahman',     'nameAr': 'الرحمن',          'verses': 78,  'juz': 27, 'type': 'Médinoise'},
    {'number': 56,  'name': 'Al-Waqiah',     'nameAr': 'الواقعة',         'verses': 96,  'juz': 27, 'type': 'Mecquoise'},
    {'number': 57,  'name': 'Al-Hadid',      'nameAr': 'الحديد',          'verses': 29,  'juz': 27, 'type': 'Médinoise'},
    {'number': 58,  'name': 'Al-Mujadila',   'nameAr': 'المجادلة',        'verses': 22,  'juz': 28, 'type': 'Médinoise'},
    {'number': 59,  'name': 'Al-Hashr',      'nameAr': 'الحشر',           'verses': 24,  'juz': 28, 'type': 'Médinoise'},
    {'number': 60,  'name': 'Al-Mumtahanah', 'nameAr': 'الممتحنة',        'verses': 13,  'juz': 28, 'type': 'Médinoise'},
    {'number': 61,  'name': 'As-Saf',        'nameAr': 'الصف',            'verses': 14,  'juz': 28, 'type': 'Médinoise'},
    {'number': 62,  'name': 'Al-Jumuah',     'nameAr': 'الجمعة',          'verses': 11,  'juz': 28, 'type': 'Médinoise'},
    {'number': 63,  'name': 'Al-Munafiqun',  'nameAr': 'المنافقون',       'verses': 11,  'juz': 28, 'type': 'Médinoise'},
    {'number': 64,  'name': 'At-Taghabun',   'nameAr': 'التغابن',         'verses': 18,  'juz': 28, 'type': 'Médinoise'},
    {'number': 65,  'name': 'At-Talaq',      'nameAr': 'الطلاق',          'verses': 12,  'juz': 28, 'type': 'Médinoise'},
    {'number': 66,  'name': 'At-Tahrim',     'nameAr': 'التحريم',         'verses': 12,  'juz': 28, 'type': 'Médinoise'},
    {'number': 67,  'name': 'Al-Mulk',       'nameAr': 'الملك',           'verses': 30,  'juz': 29, 'type': 'Mecquoise'},
    {'number': 68,  'name': 'Al-Qalam',      'nameAr': 'القلم',           'verses': 52,  'juz': 29, 'type': 'Mecquoise'},
    {'number': 69,  'name': 'Al-Haqqah',     'nameAr': 'الحاقة',          'verses': 52,  'juz': 29, 'type': 'Mecquoise'},
    {'number': 70,  'name': 'Al-Maarij',     'nameAr': 'المعارج',         'verses': 44,  'juz': 29, 'type': 'Mecquoise'},
    {'number': 71,  'name': 'Nuh',           'nameAr': 'نوح',             'verses': 28,  'juz': 29, 'type': 'Mecquoise'},
    {'number': 72,  'name': 'Al-Jinn',       'nameAr': 'الجن',            'verses': 28,  'juz': 29, 'type': 'Mecquoise'},
    {'number': 73,  'name': 'Al-Muzzammil',  'nameAr': 'المزمل',          'verses': 20,  'juz': 29, 'type': 'Mecquoise'},
    {'number': 74,  'name': 'Al-Muddaththir','nameAr': 'المدثر',          'verses': 56,  'juz': 29, 'type': 'Mecquoise'},
    {'number': 75,  'name': 'Al-Qiyamah',    'nameAr': 'القيامة',         'verses': 40,  'juz': 29, 'type': 'Mecquoise'},
    {'number': 76,  'name': 'Al-Insan',      'nameAr': 'الإنسان',         'verses': 31,  'juz': 29, 'type': 'Médinoise'},
    {'number': 77,  'name': 'Al-Mursalat',   'nameAr': 'المرسلات',        'verses': 50,  'juz': 29, 'type': 'Mecquoise'},
    {'number': 78,  'name': "An-Naba'",      'nameAr': 'النبأ',           'verses': 40,  'juz': 30, 'type': 'Mecquoise'},
    {'number': 79,  'name': 'An-Naziat',     'nameAr': 'النازعات',        'verses': 46,  'juz': 30, 'type': 'Mecquoise'},
    {'number': 80,  'name': 'Abasa',         'nameAr': 'عبس',             'verses': 42,  'juz': 30, 'type': 'Mecquoise'},
    {'number': 81,  'name': 'At-Takwir',     'nameAr': 'التكوير',         'verses': 29,  'juz': 30, 'type': 'Mecquoise'},
    {'number': 82,  'name': 'Al-Infitar',    'nameAr': 'الانفطار',        'verses': 19,  'juz': 30, 'type': 'Mecquoise'},
    {'number': 83,  'name': 'Al-Mutaffifin', 'nameAr': 'المطففين',        'verses': 36,  'juz': 30, 'type': 'Mecquoise'},
    {'number': 84,  'name': 'Al-Inshiqaq',   'nameAr': 'الانشقاق',        'verses': 25,  'juz': 30, 'type': 'Mecquoise'},
    {'number': 85,  'name': 'Al-Buruj',      'nameAr': 'البروج',          'verses': 22,  'juz': 30, 'type': 'Mecquoise'},
    {'number': 86,  'name': 'At-Tariq',      'nameAr': 'الطارق',          'verses': 17,  'juz': 30, 'type': 'Mecquoise'},
    {'number': 87,  'name': "Al-A'la",       'nameAr': 'الأعلى',          'verses': 19,  'juz': 30, 'type': 'Mecquoise'},
    {'number': 88,  'name': 'Al-Ghashiyah',  'nameAr': 'الغاشية',         'verses': 26,  'juz': 30, 'type': 'Mecquoise'},
    {'number': 89,  'name': 'Al-Fajr',       'nameAr': 'الفجر',           'verses': 30,  'juz': 30, 'type': 'Mecquoise'},
    {'number': 90,  'name': 'Al-Balad',      'nameAr': 'البلد',           'verses': 20,  'juz': 30, 'type': 'Mecquoise'},
    {'number': 91,  'name': 'Ash-Shams',     'nameAr': 'الشمس',           'verses': 15,  'juz': 30, 'type': 'Mecquoise'},
    {'number': 92,  'name': 'Al-Layl',       'nameAr': 'الليل',           'verses': 21,  'juz': 30, 'type': 'Mecquoise'},
    {'number': 93,  'name': 'Ad-Duha',       'nameAr': 'الضحى',           'verses': 11,  'juz': 30, 'type': 'Mecquoise'},
    {'number': 94,  'name': 'Ash-Sharh',     'nameAr': 'الشرح',           'verses': 8,   'juz': 30, 'type': 'Mecquoise'},
    {'number': 95,  'name': 'At-Tin',        'nameAr': 'التين',           'verses': 8,   'juz': 30, 'type': 'Mecquoise'},
    {'number': 96,  'name': "Al-Alaq",       'nameAr': 'العلق',           'verses': 19,  'juz': 30, 'type': 'Mecquoise'},
    {'number': 97,  'name': 'Al-Qadr',       'nameAr': 'القدر',           'verses': 5,   'juz': 30, 'type': 'Mecquoise'},
    {'number': 98,  'name': 'Al-Bayyinah',   'nameAr': 'البينة',          'verses': 8,   'juz': 30, 'type': 'Médinoise'},
    {'number': 99,  'name': 'Az-Zalzalah',   'nameAr': 'الزلزلة',         'verses': 8,   'juz': 30, 'type': 'Médinoise'},
    {'number': 100, 'name': 'Al-Adiyat',     'nameAr': 'العاديات',        'verses': 11,  'juz': 30, 'type': 'Mecquoise'},
    {'number': 101, 'name': "Al-Qari'ah",    'nameAr': 'القارعة',         'verses': 11,  'juz': 30, 'type': 'Mecquoise'},
    {'number': 102, 'name': 'At-Takathur',   'nameAr': 'التكاثر',         'verses': 8,   'juz': 30, 'type': 'Mecquoise'},
    {'number': 103, 'name': 'Al-Asr',        'nameAr': 'العصر',           'verses': 3,   'juz': 30, 'type': 'Mecquoise'},
    {'number': 104, 'name': 'Al-Humazah',    'nameAr': 'الهمزة',          'verses': 9,   'juz': 30, 'type': 'Mecquoise'},
    {'number': 105, 'name': 'Al-Fil',        'nameAr': 'الفيل',           'verses': 5,   'juz': 30, 'type': 'Mecquoise'},
    {'number': 106, 'name': 'Quraysh',       'nameAr': 'قريش',            'verses': 4,   'juz': 30, 'type': 'Mecquoise'},
    {'number': 107, 'name': 'Al-Maun',       'nameAr': 'الماعون',         'verses': 7,   'juz': 30, 'type': 'Mecquoise'},
    {'number': 108, 'name': 'Al-Kawthar',    'nameAr': 'الكوثر',          'verses': 3,   'juz': 30, 'type': 'Mecquoise'},
    {'number': 109, 'name': 'Al-Kafirun',    'nameAr': 'الكافرون',        'verses': 6,   'juz': 30, 'type': 'Mecquoise'},
    {'number': 110, 'name': 'An-Nasr',       'nameAr': 'النصر',           'verses': 3,   'juz': 30, 'type': 'Médinoise'},
    {'number': 111, 'name': 'Al-Masad',      'nameAr': 'المسد',           'verses': 5,   'juz': 30, 'type': 'Mecquoise'},
    {'number': 112, 'name': 'Al-Ikhlas',     'nameAr': 'الإخلاص',         'verses': 4,   'juz': 30, 'type': 'Mecquoise'},
    {'number': 113, 'name': 'Al-Falaq',      'nameAr': 'الفلق',           'verses': 5,   'juz': 30, 'type': 'Mecquoise'},
    {'number': 114, 'name': 'An-Nas',        'nameAr': 'الناس',           'verses': 6,   'juz': 30, 'type': 'Mecquoise'},
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
