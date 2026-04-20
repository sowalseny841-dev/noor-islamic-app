class HijriDate {
  final int hYear;
  final int hMonth;
  final int hDay;

  const HijriDate({required this.hYear, required this.hMonth, required this.hDay});

  factory HijriDate.now() => HijriDate.fromGregorian(DateTime.now());

  factory HijriDate.fromDate(DateTime date) => HijriDate.fromGregorian(date);

  factory HijriDate.fromGregorian(DateTime date) {
    final jd = _gregorianToJD(date.year, date.month, date.day);
    return _jdToHijri(jd);
  }

  static int _gregorianToJD(int y, int m, int d) {
    if (m <= 2) {
      y--;
      m += 12;
    }
    final a = (y / 100).floor();
    final b = 2 - a + (a / 4).floor();
    return (365.25 * (y + 4716)).floor() +
        (30.6001 * (m + 1)).floor() +
        d +
        b -
        1524;
  }

  static HijriDate _jdToHijri(int jd) {
    int l = jd - 1948440 + 10632;
    final n = ((l - 1) / 10631).floor();
    l = l - 10631 * n + 354;
    final j = ((10985 - l) / 5316).floor() * ((50 * l) / 17719).floor() +
        (l / 5670).floor() * ((43 * l) / 15238).floor();
    l = l -
        ((30 - j) / 15).floor() * ((17719 * j) / 50).floor() -
        (j / 16).floor() * ((15238 * j) / 43).floor() +
        29;
    final year = 30 * n + j - 30;
    final month = ((24 * l) / 709).floor();
    final day = l - ((709 * month) / 24).floor();
    return HijriDate(hYear: year, hMonth: month, hDay: day);
  }
}

class HijriUtils {
  static String getTodayHijri() {
    final h = HijriDate.now();
    return '${h.hDay} ${_getMonthName(h.hMonth)}, ${h.hYear} AH';
  }

  static String getHijriDate(DateTime date) {
    final h = HijriDate.fromGregorian(date);
    return '${h.hDay} ${_getMonthName(h.hMonth)}, ${h.hYear}';
  }

  static String getHijriMonthYear() {
    final h = HijriDate.now();
    return '${_getMonthName(h.hMonth)} ${h.hYear} AH';
  }

  static String _getMonthName(int month) {
    const months = [
      'Muharram', 'Safar', 'Rabi al-Awwal', 'Rabi al-Thani',
      'Jumada al-Awwal', 'Jumada al-Thani', 'Rajab', 'Shaban',
      'Ramadan', 'Shawwal', 'Dhul-Qadah', 'Dhul-Hijjah',
    ];
    if (month < 1 || month > 12) return '';
    return months[month - 1];
  }

  static String getMonthNameAr(int month) {
    const months = [
      'محرم', 'صفر', 'ربيع الأول', 'ربيع الثاني',
      'جمادى الأولى', 'جمادى الثانية', 'رجب', 'شعبان',
      'رمضان', 'شوال', 'ذو القعدة', 'ذو الحجة',
    ];
    if (month < 1 || month > 12) return '';
    return months[month - 1];
  }

  static List<Map<String, String>> getIslamicHolidays(int hijriYear) {
    return [
      {'name': 'Nouvel An Islamique', 'date': '1 Muharram $hijriYear'},
      {'name': 'Achoura', 'date': '10 Muharram $hijriYear'},
      {'name': 'Mawlid an-Nabi', 'date': '12 Rabi al-Awwal $hijriYear'},
      {'name': 'Début du Ramadan', 'date': '1 Ramadan $hijriYear'},
      {'name': 'Nuit du Destin (Laylat al-Qadr)', 'date': '27 Ramadan $hijriYear'},
      {'name': 'Aïd al-Fitr', 'date': '1 Shawwal $hijriYear'},
      {'name': 'Jour d\'Arafat', 'date': '9 Dhul-Hijjah $hijriYear'},
      {'name': 'Aïd al-Adha', 'date': '10 Dhul-Hijjah $hijriYear'},
    ];
  }
}
