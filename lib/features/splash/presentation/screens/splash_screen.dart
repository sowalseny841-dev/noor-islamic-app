import 'package:flutter/material.dart';
import 'package:get/get.dart' hide TextDirection;
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/gradient_background.dart';
import '../../../../shared/services/storage_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    _navigateAfterDelay();
  }

  Future<void> _navigateAfterDelay() async {
    await Future.delayed(const Duration(seconds: 3));
    final storage = Get.find<StorageService>();
    if (storage.isOnboardingDone) {
      Get.offAllNamed('/home');
    } else {
      Get.offAllNamed('/onboarding');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        colors: AppColors.splashGradient.colors,
        showMosqueIllustration: true,
        child: SafeArea(
          child: Column(
            children: [
              const Spacer(flex: 2),
              // Logo + App name
              Column(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: AppColors.goldGradient,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.gold.withOpacity(0.4),
                          blurRadius: 30,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Text(
                        'نور',
                        style: TextStyle(
                          fontFamily: 'ScheherazadeNew',
                          fontSize: 42,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )
                      .animate()
                      .scale(duration: 600.ms, curve: Curves.elasticOut),
                  const SizedBox(height: 24),
                  Text(
                    'Noor',
                    style: AppTextStyles.heading1(color: AppColors.white).copyWith(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 4,
                    ),
                  )
                      .animate(delay: 400.ms)
                      .fadeIn(duration: 600.ms)
                      .slideY(begin: 0.3, end: 0),
                  const SizedBox(height: 8),
                  Text(
                    'نور',
                    style: AppTextStyles.arabicLarge(color: AppColors.goldLight),
                  )
                      .animate(delay: 600.ms)
                      .fadeIn(duration: 600.ms),
                  const SizedBox(height: 16),
                  Container(
                    height: 2,
                    width: 60,
                    decoration: BoxDecoration(
                      gradient: AppColors.goldGradient,
                      borderRadius: BorderRadius.circular(1),
                    ),
                  ).animate(delay: 800.ms).scaleX(duration: 600.ms),
                  const SizedBox(height: 16),
                  Text(
                    'Votre compagnon islamique',
                    style: AppTextStyles.bodyMedium(color: AppColors.white.withOpacity(0.8)),
                  )
                      .animate(delay: 1000.ms)
                      .fadeIn(duration: 600.ms),
                ],
              ),
              const Spacer(flex: 2),
              // Loading indicator
              Column(
                children: [
                  SizedBox(
                    width: 40,
                    height: 40,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.gold.withOpacity(0.8),
                      ),
                      strokeWidth: 2,
                    ),
                  ).animate(delay: 1200.ms).fadeIn(duration: 400.ms),
                  const SizedBox(height: 16),
                  Text(
                    'بِسْمِ اللَّهِ الرَّحْمَنِ الرَّحِيمِ',
                    style: AppTextStyles.arabicSmall(
                      color: AppColors.white.withOpacity(0.7),
                    ),
                  )
                      .animate(delay: 1400.ms)
                      .fadeIn(duration: 600.ms),
                ],
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
