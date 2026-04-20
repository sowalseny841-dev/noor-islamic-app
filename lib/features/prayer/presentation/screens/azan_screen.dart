import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart' hide TextDirection;
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/hijri_utils.dart';

class AzanScreen extends StatelessWidget {
  final String prayerName;
  final String prayerTime;
  final Color prayerColor;

  const AzanScreen({
    super.key,
    required this.prayerName,
    required this.prayerTime,
    required this.prayerColor,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.primaryDark,
              prayerColor.withOpacity(0.6),
              AppColors.primaryDark,
            ],
          ),
        ),
        child: Stack(
          children: [
            // Background mosque image overlay
            Positioned.fill(
              child: Opacity(
                opacity: 0.2,
                child: CustomPaint(
                  painter: _MosqueFullPainter(),
                ),
              ),
            ),
            // Circular glow
            Center(
              child: Container(
                width: size.width * 0.7,
                height: size.width * 0.7,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      prayerColor.withOpacity(0.3),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            SafeArea(
              child: Column(
                children: [
                  // Top controls
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.close_rounded,
                                color: Colors.white, size: 20),
                          ),
                          onPressed: () => Get.back(),
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.volume_up_outlined,
                                  color: Colors.white.withOpacity(0.8)),
                              onPressed: () {},
                            ),
                            IconButton(
                              icon: Icon(Icons.tune_rounded,
                                  color: Colors.white.withOpacity(0.8)),
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  // Prayer info
                  Column(
                    children: [
                      Text(
                        prayerName,
                        style: AppTextStyles.prayerName(color: AppColors.white)
                            .copyWith(fontSize: 24),
                      ).animate().fadeIn(duration: 500.ms),
                      const SizedBox(height: 8),
                      Text(
                        prayerTime,
                        style: AppTextStyles.prayerTime(color: AppColors.white),
                      )
                          .animate()
                          .scale(duration: 600.ms, curve: Curves.elasticOut),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.mosque_rounded,
                                color: AppColors.gold, size: 16),
                            const SizedBox(width: 6),
                            Text(
                              HijriUtils.getTodayHijri(),
                              style: AppTextStyles.bodySmall(
                                  color: AppColors.goldLight),
                            ),
                          ],
                        ),
                      ).animate(delay: 200.ms).fadeIn(duration: 400.ms),
                    ],
                  ),
                  const Spacer(),
                  // Azan text
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color: AppColors.gold.withOpacity(0.3), width: 1),
                      ),
                      child: Column(
                        children: [
                          Text(
                            'اللَّهُ أَكْبَرُ اللَّهُ أَكْبَرُ\nأَشْهَدُ أَنْ لَا إِلَهَ إِلَّا اللَّهُ',
                            style: AppTextStyles.arabicMedium(
                                color: AppColors.white),
                            textAlign: TextAlign.center,
                            textDirection: TextDirection.rtl,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Allahu Akbar, Allahu Akbar\nAshadu an la ilaha illallah',
                            style: AppTextStyles.bodySmall(
                                color: AppColors.white.withOpacity(0.7)),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ).animate(delay: 400.ms).fadeIn(duration: 500.ms),
                  const SizedBox(height: 24),
                  // Day selectors
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: ['Ven', 'Sam', 'Dim', 'Lun', 'Mar', 'Mer', 'Jeu']
                          .asMap()
                          .entries
                          .map((e) => _DayChip(
                                day: e.value,
                                isActive: e.key == 0,
                                isToday: e.key == 2,
                              ))
                          .toList(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Save button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: AppColors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                        ),
                        child: Text('Appuyez pour Enregistrer',
                            style: AppTextStyles.button()),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Quick links
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => Get.to(() => const QuranLinkScreen()),
                            icon: const Text('📖', style: TextStyle(fontSize: 16)),
                            label: Text('Coran',
                                style: AppTextStyles.bodySmall(
                                    color: AppColors.white)),
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(
                                  color: Colors.white.withOpacity(0.3)),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {},
                            icon: const Text('🧭', style: TextStyle(fontSize: 16)),
                            label: Text('Qibla',
                                style: AppTextStyles.bodySmall(
                                    color: AppColors.white)),
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(
                                  color: Colors.white.withOpacity(0.3)),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DayChip extends StatelessWidget {
  final String day;
  final bool isActive;
  final bool isToday;

  const _DayChip({
    required this.day,
    this.isActive = false,
    this.isToday = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(day,
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 12,
            )),
        const SizedBox(height: 4),
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive
                ? AppColors.primary
                : (isToday
                    ? Colors.white.withOpacity(0.15)
                    : Colors.transparent),
            border: isToday
                ? Border.all(color: AppColors.gold, width: 2)
                : Border.all(color: Colors.white.withOpacity(0.2)),
          ),
          child: Center(
            child: isActive
                ? const Icon(Icons.check, color: Colors.white, size: 16)
                : (isToday
                    ? const Icon(Icons.remove, color: Colors.white, size: 16)
                    : const Icon(Icons.remove, color: Colors.transparent, size: 16)),
          ),
        ),
      ],
    );
  }
}

class _MosqueFullPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    final path = Path();
    final w = size.width;
    final h = size.height;
    path.moveTo(0, h);
    path.lineTo(0, h * 0.75);
    path.lineTo(w * 0.06, h * 0.75);
    path.lineTo(w * 0.06, h * 0.45);
    path.quadraticBezierTo(w * 0.085, h * 0.25, w * 0.11, h * 0.45);
    path.lineTo(w * 0.11, h * 0.75);
    path.lineTo(w * 0.3, h * 0.75);
    path.lineTo(w * 0.3, h * 0.6);
    path.quadraticBezierTo(w * 0.36, h * 0.45, w * 0.42, h * 0.6);
    path.lineTo(w * 0.42, h * 0.75);
    path.lineTo(w * 0.44, h * 0.75);
    path.lineTo(w * 0.44, h * 0.6);
    path.quadraticBezierTo(w * 0.5, h * 0.3, w * 0.56, h * 0.6);
    path.lineTo(w * 0.56, h * 0.75);
    path.lineTo(w * 0.58, h * 0.75);
    path.lineTo(w * 0.58, h * 0.6);
    path.quadraticBezierTo(w * 0.64, h * 0.45, w * 0.70, h * 0.6);
    path.lineTo(w * 0.70, h * 0.75);
    path.lineTo(w * 0.89, h * 0.75);
    path.lineTo(w * 0.89, h * 0.45);
    path.quadraticBezierTo(w * 0.915, h * 0.25, w * 0.94, h * 0.45);
    path.lineTo(w * 0.94, h * 0.75);
    path.lineTo(w, h * 0.75);
    path.lineTo(w, h);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Placeholder for navigation
class QuranLinkScreen extends StatelessWidget {
  const QuranLinkScreen({super.key});

  @override
  Widget build(BuildContext context) => const Scaffold(
        body: Center(child: Text('Coran')),
      );
}
