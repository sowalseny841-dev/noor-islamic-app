import 'package:hijri/hijri_calendar.dart';

class HijriUtils {
  static String getTodayHijri() {
    final hijri = HijriCalendar.now();
    return '${hijri.hDay} ${_getMonthName(hijri.hMonth)}, ${hijri.hYear} AH';
  }

  static String getHijriDate(DateTime date) {
    final hijri = HijriCalendar.fromDate(date);
    return '${hijri.hDay} ${_getMonthName(hijri.hMonth)}, ${hijri.hYear}';
  }

  static String getHijriMonthYear() {
    final hijri = HijriCalendar.now();
    return '${_getMonthName(hijri.hMonth)} ${hijri.hYear} AH';
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
