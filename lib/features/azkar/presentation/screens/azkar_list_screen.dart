import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart' hide TextDirection;
import 'package:percent_indicator/linear_percent_indicator.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/gradient_background.dart';
import '../../../../shared/models/azkar_model.dart';
import '../controllers/azkar_controller.dart';
import 'azkar_detail_screen.dart';

class AzkarListScreen extends StatelessWidget {
  const AzkarListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AzkarController());
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              return ListView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                children: [
                  _buildFavoriteCard(controller, isDark),
                  const SizedBox(height: 20),
                  Text('La liste de Azkars',
                      style: AppTextStyles.heading3()),
                  const SizedBox(height: 12),
                  ...controller.categories
                      .asMap()
                      .entries
                      .map((e) => _AzkarCategoryTile(
                            category: e.value,
                            index: e.key,
                            onTap: () {
                              controller.selectCategory(e.value.id);
                              Get.to(() => AzkarDetailScreen(
                                    categoryId: e.value.id,
                                  ));
                            },
                          ).animate(delay: (e.key * 60).ms)
                              .fadeIn(duration: 300.ms)
                              .slideX(begin: 0.1, end: 0)),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return GradientBackground(
      showMosqueIllustration: true,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new_rounded,
                        color: Colors.white, size: 20),
                    onPressed: () => Get.back(),
                  ),
                  const Spacer(),
                ],
              ),
              Text(
                'Azkar',
                style: AppTextStyles.heading1(color: AppColors.white)
                    .copyWith(fontSize: 36, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                'Duae et zikr basé sur les\nhadiths et le coran',
                style: AppTextStyles.bodyMedium(
                    color: AppColors.white.withOpacity(0.85)),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFavoriteCard(AzkarController controller, bool isDark) {
    final favorites = controller.categories
        .where((c) => c.id == 'morning' || c.id == 'evening')
        .toList();
    if (favorites.isEmpty) return const SizedBox.shrink();
    final morning = favorites.firstWhere((c) => c.id == 'morning',
        orElse: () => favorites.first);

    return GestureDetector(
      onTap: () {
        controller.selectCategory(morning.id);
        Get.to(() => AzkarDetailScreen(categoryId: morning.id));
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Mon Azkar préférés',
                      style: AppTextStyles.heading3(color: AppColors.white)
                          .copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(
                    "Lecture d'aujourd'hui ${morning.readCount}/${morning.totalCount}",
                    style: AppTextStyles.bodySmall(
                        color: AppColors.white.withOpacity(0.8)),
                  ),
                  const SizedBox(height: 10),
                  LinearPercentIndicator(
                    percent: morning.totalCount > 0
                        ? (morning.readCount / morning.totalCount).clamp(0.0, 1.0)
                        : 0.0,
                    lineHeight: 6,
                    backgroundColor: AppColors.white.withOpacity(0.25),
                    progressColor: AppColors.gold,
                    barRadius: const Radius.circular(3),
                    padding: EdgeInsets.zero,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            const Text('📖', style: TextStyle(fontSize: 50)),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.2, end: 0);
  }
}

class _AzkarCategoryTile extends StatelessWidget {
  final AzkarCategory category;
  final int index;
  final VoidCallback onTap;

  const _AzkarCategoryTile({
    required this.category,
    required this.index,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final progress = category.totalCount > 0
        ? category.readCount / category.totalCount
        : 0.0;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardDark : AppColors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(category.icon,
                    style: const TextStyle(fontSize: 24)),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(category.name,
                      style: AppTextStyles.bodyLarge()),
                  const SizedBox(height: 2),
                  Text(
                    "Lecture d'aujourd'hui ${category.readCount}/${category.totalCount}",
                    style: AppTextStyles.bodySmall(),
                  ),
                  if (progress > 0) ...[
                    const SizedBox(height: 6),
                    LinearPercentIndicator(
                      percent: progress.clamp(0.0, 1.0),
                      lineHeight: 4,
                      backgroundColor: AppColors.dividerLight,
                      progressColor: AppColors.primary,
                      barRadius: const Radius.circular(2),
                      padding: EdgeInsets.zero,
                    ),
                  ],
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded,
                color: AppColors.textSecondaryLight),
          ],
        ),
      ),
    );
  }
}
