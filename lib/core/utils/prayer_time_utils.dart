import 'package:adhan/adhan.dart';
import 'package:intl/intl.dart';

class PrayerTimeUtils {
  static PrayerTimes getPrayerTimes({
    required double latitude,
    required double longitude,
    String method = 'MuslimWorldLeague',
  }) {
    final coords = Coordinates(latitude, longitude);
    final params = _getCalculationParameters(method);
    final dateComponents = DateComponents.from(DateTime.now());
    return PrayerTimes(coords, dateComponents, params);
  }

  static CalculationParameters _getCalculationParameters(String method) {
    switch (method) {
      case 'France':
      case 'UOIF':
        return CalculationMethod.moon_sighting_committee.getParameters();
      case 'MuslimWorldLeague':
        return CalculationMethod.muslim_world_league.getParameters();
      case 'Egyptian':
        return CalculationMethod.egyptian.getParameters();
      case 'Karachi':
        return CalculationMethod.karachi.getParameters();
      case 'NorthAmerica':
        return CalculationMethod.north_america.getParameters();
      case 'Dubai':
        return CalculationMethod.dubai.getParameters();
      default:
        return CalculationMethod.muslim_world_league.getParameters();
    }
  }

  static String formatTime(DateTime? time) {
    if (time == null) return '--:--';
    return DateFormat('hh:mm a').format(time);
  }

  static String formatTime24(DateTime? time) {
    if (time == null) return '--:--';
    return DateFormat('HH:mm').format(time);
  }

  static String getNextPrayerCountdown(PrayerTimes prayerTimes) {
    final now = DateTime.now();
    final nextPrayer = prayerTimes.nextPrayer();
    final nextTime = prayerTimes.timeForPrayer(nextPrayer);
    if (nextTime == null) return '';
    final diff = nextTime.difference(now);
    final hours = diff.inHours;
    final minutes = diff.inMinutes % 60;
    if (hours > 0) return '${hours}h ${minutes}min';
    return '${minutes}min';
  }

  static Prayer getCurrentPrayer(PrayerTimes prayerTimes) {
    return prayerTimes.currentPrayer();
  }

  static String prayerToString(Prayer prayer) {
    switch (prayer) {
      case Prayer.fajr:
        return 'Fajr';
      case Prayer.sunrise:
        return 'Lever du soleil';
      case Prayer.dhuhr:
        return 'Dhuhr';
      case Prayer.asr:
        return 'Asr';
      case Prayer.maghrib:
        return 'Maghrib';
      case Prayer.isha:
        return 'Isha';
      default:
        return 'Isha';
    }
  }

  static String prayerToStringAr(Prayer prayer) {
    switch (prayer) {
      case Prayer.fajr:
        return 'الفجر';
      case Prayer.sunrise:
        return 'الشروق';
      case Prayer.dhuhr:
        return 'الظهر';
      case Prayer.asr:
        return 'العصر';
      case Prayer.maghrib:
        return 'المغرب';
      case Prayer.isha:
        return 'العشاء';
      default:
        return 'العشاء';
    }
  }
}
