import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class PrayerModel {
  final String name;
  final String nameAr;
  final String time;
  final bool isActive;
  final bool notificationEnabled;
  final Color color;
  final IconData icon;

  const PrayerModel({
    required this.name,
    required this.nameAr,
    required this.time,
    this.isActive = false,
    this.notificationEnabled = true,
    required this.color,
    required this.icon,
  });

  static List<PrayerModel> fromPrayerTimes({
    required String fajr,
    required String sunrise,
    required String dhuhr,
    required String asr,
    required String maghrib,
    required String isha,
    String activePrayer = '',
  }) {
    return [
      PrayerModel(
        name: 'Fajr',
        nameAr: 'الفجر',
        time: fajr,
        isActive: activePrayer == 'Fajr',
        color: AppColors.fajrColor,
        icon: Icons.nightlight_round,
      ),
      PrayerModel(
        name: 'Lever du soleil',
        nameAr: 'الشروق',
        time: sunrise,
        isActive: activePrayer == 'Lever du soleil',
        color: AppColors.sunriseColor,
        icon: Icons.wb_twilight_rounded,
      ),
      PrayerModel(
        name: 'Dhuhr',
        nameAr: 'الظهر',
        time: dhuhr,
        isActive: activePrayer == 'Dhuhr',
        color: AppColors.dhuhrColor,
        icon: Icons.wb_sunny_rounded,
      ),
      PrayerModel(
        name: 'Asr',
        nameAr: 'العصر',
        time: asr,
        isActive: activePrayer == 'Asr',
        color: AppColors.asrColor,
        icon: Icons.cloud_rounded,
      ),
      PrayerModel(
        name: 'Maghrib',
        nameAr: 'المغرب',
        time: maghrib,
        isActive: activePrayer == 'Maghrib',
        color: AppColors.maghribColor,
        icon: Icons.wb_twilight_rounded,
      ),
      PrayerModel(
        name: 'Isha',
        nameAr: 'العشاء',
        time: isha,
        isActive: activePrayer == 'Isha',
        color: AppColors.ishaColor,
        icon: Icons.nights_stay_rounded,
      ),
    ];
  }
}
