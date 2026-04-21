import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'core/theme/app_theme.dart';
import 'shared/services/storage_service.dart';
import 'features/splash/presentation/screens/splash_screen.dart';
import 'features/onboarding/presentation/screens/onboarding_screen.dart';
import 'features/home/presentation/screens/main_navigation_screen.dart';
import 'features/settings/presentation/screens/settings_screen.dart';
import 'features/settings/presentation/screens/qibla_screen.dart';
import 'features/quran/presentation/screens/quran_screen.dart';
import 'features/quran/presentation/screens/quran_surah_screen.dart';
import 'features/prayer/presentation/screens/prayer_screen.dart';
import 'features/prayer/presentation/screens/azan_screen.dart';
import 'features/azkar/presentation/screens/azkar_list_screen.dart';
import 'features/azkar/presentation/screens/azkar_detail_screen.dart';
import 'features/tasbih/presentation/screens/tasbih_screen.dart';
import 'features/calendar/presentation/screens/calendar_screen.dart';
import 'features/ummah/presentation/screens/ummah_screen.dart';

class NoorApp extends StatelessWidget {
  const NoorApp({super.key});

  @override
  Widget build(BuildContext context) {
    final storage = Get.find<StorageService>();

    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          title: 'Noor - نور',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: _getThemeMode(storage.themeMode),
          locale: const Locale('fr', 'FR'),
          fallbackLocale: const Locale('fr', 'FR'),
          home: child,
          getPages: AppPages.pages,
        );
      },
      child: const SplashScreen(),
    );
  }

  ThemeMode _getThemeMode(String mode) {
    switch (mode) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }
}

class AppPages {
  static final pages = [
    GetPage(name: '/splash', page: () => const SplashScreen()),
    GetPage(name: '/onboarding', page: () => const OnboardingScreen()),
    GetPage(name: '/home', page: () => const MainNavigationScreen()),
    GetPage(name: '/settings', page: () => const SettingsScreen()),
    GetPage(name: '/qibla', page: () => const QiblaScreen()),
    GetPage(name: '/quran', page: () => const QuranScreen()),
    GetPage(name: '/quran/surah', page: () => QuranSurahScreen(surah: Get.arguments as Map<String, dynamic>)),
    GetPage(name: '/prayer', page: () => const PrayerScreen()),
    GetPage(name: '/azan', page: () {
      final args = Get.arguments as Map<String, dynamic>;
      return AzanScreen(
        prayerName: args['prayerName'] as String,
        prayerTime: args['prayerTime'] as String,
        prayerColor: args['prayerColor'] as Color,
      );
    }),
    GetPage(name: '/azkar/detail', page: () => AzkarDetailScreen(categoryId: Get.arguments as String)),
    GetPage(name: '/tasbih', page: () => const TasbihScreen()),
    GetPage(name: '/calendar', page: () => const CalendarScreen()),
    GetPage(name: '/ummah', page: () => const UmmahScreen()),
  ];
}
