import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/hijri_utils.dart';
import '../../../../shared/services/storage_service.dart';
import '../../../prayer/presentation/controllers/prayer_controller.dart';
import '../../../azkar/presentation/screens/azkar_list_screen.dart';
import '../../../quran/presentation/screens/quran_screen.dart';
import '../../../tasbih/presentation/screens/tasbih_screen.dart';
import '../../../calendar/presentation/screens/calendar_screen.dart';
import '../../../settings/presentation/screens/qibla_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final prayer = Get.put(PrayerController());
    final storage = Get.find<StorageService>();

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(prayer, storage),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildNextPrayerCard(prayer),
                  const SizedBox(height: 24),
                  _buildFeatureGrid(context),
                  const SizedBox(height: 24),
                  _buildDailyVerse(),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar(PrayerController prayer, StorageService storage) {
    return SliverAppBar(
      expandedHeight: 200,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.primaryDark, AppColors.primary, AppColors.primaryLight],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Obx(() => Text(
                                'As-salamu Alaykum 🌙',
                                style: AppTextStyles.heading3(
                                    color: AppColors.white),
                              )),
                          const SizedBox(height: 4),
                          Obx(() => Text(
                                storage.cityName,
                                style: AppTextStyles.bodySmall(
                                    color: AppColors.white.withOpacity(0.8)),
                              )),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          HijriUtils.getTodayHijri(),
                          style: AppTextStyles.bodySmall(
                              color: AppColors.goldLight),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Obx(() {
                    final next = prayer.nextPrayerName.value;
                    final countdown = prayer.nextPrayerCountdown.value;
                    return Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.white.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppColors.white.withOpacity(0.2),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.access_time_rounded,
                              color: AppColors.gold, size: 20),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Prochaine prière',
                                  style: AppTextStyles.bodySmall(
                                      color: AppColors.white.withOpacity(0.7))),
                              Text('$next dans $countdown',
                                  style: AppTextStyles.bodyMedium(
                                      color: AppColors.white)),
                            ],
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        ),
      ),
      backgroundColor: AppColors.primary,
    );
  }

  Widget _buildNextPrayerCard(PrayerController prayer) {
    return Obx(() {
      final prayers = prayer.prayers;
      final current = prayer.currentPrayerName.value;
      final activeP = prayers.firstWhereOrNull((p) => p.name == current);
      if (activeP == null) return const SizedBox.shrink();

      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [activeP.color.withOpacity(0.8), activeP.color],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: activeP.color.withOpacity(0.3),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(activeP.icon, color: AppColors.white, size: 40),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Prière actuelle',
                    style: AppTextStyles.bodySmall(
                        color: AppColors.white.withOpacity(0.8))),
                Text(activeP.name,
                    style: AppTextStyles.heading2(color: AppColors.white)),
                Text(activeP.nameAr,
                    style: AppTextStyles.arabicSmall(color: AppColors.goldLight)),
              ],
            ),
            const Spacer(),
            Text(
              activeP.time,
              style: AppTextStyles.heading3(color: AppColors.white),
            ),
          ],
        ),
      ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.2, end: 0);
    });
  }

  Widget _buildFeatureGrid(BuildContext context) {
    final features = [
      _Feature('Coran', 'القرآن', '📖', AppColors.primaryDark,
          () => Get.to(() => const QuranScreen())),
      _Feature('Azkar', 'الأذكار', '🌿', const Color(0xFF2D6A4F),
          () => Get.to(() => const AzkarListScreen())),
      _Feature('Tasbih', 'التسبيح', '📿', const Color(0xFF1A472A),
          () => Get.to(() => const TasbihScreen())),
      _Feature('Qibla', 'القبلة', '🧭', const Color(0xFF386641),
          () => Get.to(() => const QiblaScreen())),
      _Feature('Calendrier', 'التقويم', '📅', const Color(0xFF357A38),
          () => Get.to(() => const CalendarScreen())),
      _Feature('Dua', 'الدعاء', '🤲', const Color(0xFF5C8D4A),
          () {}),
      _Feature('99 Noms', 'أسماء الله', '✨', const Color(0xFF1E5631),
          () {}),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Fonctionnalités', style: AppTextStyles.heading3()),
        const SizedBox(height: 12),
        GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1,
          ),
          itemCount: features.length,
          itemBuilder: (context, index) {
            return _FeatureTile(feature: features[index])
                .animate(delay: (index * 60).ms)
                .fadeIn(duration: 300.ms)
                .scale(begin: const Offset(0.8, 0.8));
          },
        ),
      ],
    );
  }

  Widget _buildDailyVerse() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primaryDark,
            AppColors.primary,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Verset du jour',
                  style: AppTextStyles.bodySmall(
                      color: AppColors.goldLight)),
              const Icon(Icons.bookmark_border_rounded,
                  color: AppColors.gold, size: 20),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'إِنَّ مَعَ الْعُسْرِ يُسْرًا',
            style: AppTextStyles.arabicMedium(color: AppColors.white)
                .copyWith(fontSize: 24),
            textDirection: TextDirection.rtl,
          ),
          const SizedBox(height: 8),
          Text(
            '"En vérité, avec la difficulté vient la facilité."',
            style: AppTextStyles.bodyMedium(
                color: AppColors.white.withOpacity(0.85)),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            '— Sourate Al-Inshirah (94:6)',
            style: AppTextStyles.caption(color: AppColors.goldLight),
          ),
        ],
      ),
    ).animate(delay: 300.ms).fadeIn(duration: 500.ms);
  }
}

class _Feature {
  final String name;
  final String nameAr;
  final String emoji;
  final Color color;
  final VoidCallback onTap;

  const _Feature(this.name, this.nameAr, this.emoji, this.color, this.onTap);
}

class _FeatureTile extends StatelessWidget {
  final _Feature feature;

  const _FeatureTile({required this.feature});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: feature.onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [feature.color, feature.color.withOpacity(0.7)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: feature.color.withOpacity(0.25),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(feature.emoji, style: const TextStyle(fontSize: 32)),
            const SizedBox(height: 6),
            Text(
              feature.name,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
