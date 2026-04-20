import 'dart:ui' show TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart' hide TextDirection;
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/models/azkar_model.dart';
import '../controllers/azkar_controller.dart';

class AzkarDetailScreen extends StatelessWidget {
  final String categoryId;

  const AzkarDetailScreen({super.key, required this.categoryId});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AzkarController>();
    final cat = controller.getCategoryById(categoryId);

    return Scaffold(
      body: Column(
        children: [
          _buildHeader(controller, cat),
          Expanded(
            child: Obx(() {
              if (controller.currentAzkar.isEmpty) {
                return const Center(child: Text('Aucun zikr dans cette catégorie'));
              }
              return PageView.builder(
                itemCount: controller.currentAzkar.length,
                onPageChanged: (i) => controller.currentIndex.value = i,
                itemBuilder: (ctx, i) {
                  return _AzkarCard(
                    item: controller.currentAzkar[i],
                    currentPage: i + 1,
                    totalPages: controller.currentAzkar.length,
                    onTap: () => controller.incrementCurrentZikr(),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(AzkarController controller, AzkarCategory? cat) {
    return Container(
      decoration: const BoxDecoration(
        gradient: AppColors.primaryGradient,
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 16, 16),
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new_rounded,
                        color: Colors.white, size: 20),
                    onPressed: () => Get.back(),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Text(cat?.name ?? 'Azkar',
                            style: AppTextStyles.heading3(color: AppColors.white)),
                        if (cat != null)
                          Text(
                            "Lecture d'aujourd'hui ${cat.readCount}/${cat.totalCount}",
                            style: AppTextStyles.bodySmall(
                                color: AppColors.white.withOpacity(0.8)),
                          ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.refresh_rounded,
                        color: Colors.white, size: 22),
                    onPressed: () => controller.resetCategory(categoryId),
                  ),
                ],
              ),
              Obx(() {
                final total = controller.currentAzkar.length;
                final current = controller.currentIndex.value + 1;
                return Text(
                  '$current / $total',
                  style: AppTextStyles.bodySmall(
                      color: AppColors.white.withOpacity(0.7)),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}

class _AzkarCard extends StatelessWidget {
  final AzkarItem item;
  final int currentPage;
  final int totalPages;
  final VoidCallback onTap;

  const _AzkarCard({
    required this.item,
    required this.currentPage,
    required this.totalPages,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final progress =
        item.repeatCount > 0 ? item.currentCount / item.repeatCount : 0.0;

    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardDark : const Color(0xFFFFF9F0),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: item.isCompleted
                ? AppColors.primary.withOpacity(0.4)
                : AppColors.gold.withOpacity(0.3),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    // Arabic text
                    Text(
                      item.arabic,
                      style: AppTextStyles.arabicLarge(
                        color: isDark
                            ? AppColors.textPrimaryDark
                            : AppColors.textPrimaryLight,
                      ).copyWith(fontSize: 26, height: 2.2),
                      textAlign: TextAlign.center,
                      textDirection: TextDirection.rtl,
                    ).animate().fadeIn(duration: 300.ms),
                    const SizedBox(height: 20),
                    // Divider
                    Container(
                      height: 1,
                      color: AppColors.gold.withOpacity(0.2),
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                    ),
                    const SizedBox(height: 16),
                    // Translation
                    Text(
                      item.translation,
                      style: AppTextStyles.bodyLarge(
                        color: isDark
                            ? AppColors.textPrimaryDark
                            : AppColors.textPrimaryLight,
                      ),
                      textAlign: TextAlign.center,
                    ).animate(delay: 100.ms).fadeIn(duration: 300.ms),
                    const SizedBox(height: 12),
                    // Transliteration
                    Text(
                      item.transliteration,
                      style: AppTextStyles.bodyMedium().copyWith(
                        fontStyle: FontStyle.italic,
                      ),
                      textAlign: TextAlign.center,
                    ).animate(delay: 200.ms).fadeIn(duration: 300.ms),
                    if (item.source.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          item.source,
                          style: AppTextStyles.caption(
                              color: AppColors.primary),
                        ),
                      ),
                    ],
                    if (item.benefit != null) ...[
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppColors.gold.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              color: AppColors.gold.withOpacity(0.3)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.star_rounded,
                                color: AppColors.gold, size: 16),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                item.benefit!,
                                style: AppTextStyles.bodySmall(
                                    color: AppColors.goldDark),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            // Counter area
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.primaryDark.withOpacity(0.3)
                    : AppColors.primary.withOpacity(0.05),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Progress
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${item.currentCount} / ${item.repeatCount}',
                        style: AppTextStyles.heading3(color: AppColors.primary),
                      ),
                      const SizedBox(height: 4),
                      SizedBox(
                        width: 120,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: progress.clamp(0.0, 1.0),
                            backgroundColor: AppColors.dividerLight,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              item.isCompleted
                                  ? AppColors.success
                                  : AppColors.primary,
                            ),
                            minHeight: 6,
                          ),
                        ),
                      ),
                    ],
                  ),
                  // Tap button
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: item.isCompleted
                          ? const LinearGradient(
                              colors: [AppColors.success, Color(0xFF16A34A)])
                          : AppColors.primaryGradient,
                      boxShadow: [
                        BoxShadow(
                          color: (item.isCompleted
                                  ? AppColors.success
                                  : AppColors.primary)
                              .withOpacity(0.3),
                          blurRadius: 12,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Icon(
                      item.isCompleted
                          ? Icons.check_rounded
                          : Icons.touch_app_rounded,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
