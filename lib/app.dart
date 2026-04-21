import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'core/theme/app_theme.dart';
import 'shared/services/storage_service.dart';
import 'features/splash/presentation/screens/splash_screen.dart';
import 'features/onboarding/presentation/screens/onboarding_screen.dart';
import 'features/home/presentation/screens/main_navigation_screen.dart';

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
  ];
}
