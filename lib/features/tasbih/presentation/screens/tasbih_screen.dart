import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart' hide TextDirection;
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../controllers/tasbih_controller.dart';

class TasbihScreen extends StatelessWidget {
  const TasbihScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TasbihController());
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.surfaceDark : AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: isDark ? AppColors.white : AppColors.textPrimaryLight,
            size: 20,
          ),
          onPressed: () => Get.back(),
        ),
        title: Obx(() => Column(
              children: [
                Text(
                  'Tasbih',
                  style: AppTextStyles.heading3(
                      color: isDark ? AppColors.white : AppColors.textPrimaryLight),
                ),
                Text(
                  '${controller.selectedIndex.value + 1}/${controller.tasbihList.length}',
                  style: AppTextStyles.bodySmall(),
                ),
              ],
            )),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh_rounded,
                color: isDark ? AppColors.white : AppColors.textPrimaryLight),
            onPressed: controller.reset,
          ),
          IconButton(
            icon: Icon(Icons.copy_outlined,
                color: isDark ? AppColors.white : AppColors.textPrimaryLight),
            onPressed: () => _showTasbihList(context, controller),
          ),
          IconButton(
            icon: Icon(Icons.more_horiz_rounded,
                color: isDark ? AppColors.white : AppColors.textPrimaryLight),
            onPressed: () {},
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        final current = controller.currentTasbih;
        if (current == null) return const SizedBox.shrink();

        return Column(
          children: [
            // Zikr card
            Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.cardDark
                      : const Color(0xFFFFF9F0),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                      color: AppColors.gold.withOpacity(0.3), width: 1.5),
                ),
                child: Column(
                  children: [
                    Text(
                      current.arabic,
                      style: AppTextStyles.arabicLarge(
                        color: isDark
                            ? AppColors.textPrimaryDark
                            : AppColors.textPrimaryLight,
                      ).copyWith(fontSize: 24),
                      textAlign: TextAlign.center,
                      textDirection: TextDirection.rtl,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      current.translation,
                      style: AppTextStyles.bodyMedium(),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      current.transliteration,
                      style: AppTextStyles.bodySmall()
                          .copyWith(fontStyle: FontStyle.italic),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ).animate().fadeIn(duration: 300.ms),
            ),
            // Counter display
            Obx(() => Text(
                  '${controller.count.value}',
                  style: AppTextStyles.counter(
                    color: isDark ? AppColors.white : AppColors.textPrimaryLight,
                  ),
                )).animate().scale(duration: 100.ms),
            Text(
              '/ ${controller.targetCount}',
              style: AppTextStyles.bodyLarge(
                  color: AppColors.textSecondaryLight),
            ),
            Obx(() => Text(
                  'Tours: ${controller.rounds.value}',
                  style: AppTextStyles.bodyMedium(),
                )),
            const Spacer(),
            // Bead animation
            Obx(() => _TasbihBeads(
                  count: controller.count.value,
                  total: controller.targetCount,
                )),
            const Spacer(),
            // Bottom controls
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _IconAction(
                    icon: Icons.palette_outlined,
                    onTap: () {},
                  ),
                  // Main tap button
                  GestureDetector(
                    onTap: controller.increment,
                    child: Obx(() {
                      final progress = controller.progress;
                      return Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            width: 120,
                            height: 120,
                            child: CircularProgressIndicator(
                              value: progress,
                              strokeWidth: 6,
                              backgroundColor: AppColors.dividerLight,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                progress >= 1.0
                                    ? AppColors.success
                                    : AppColors.primary,
                              ),
                            ),
                          ),
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: AppColors.primaryGradient,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primary.withOpacity(0.4),
                                  blurRadius: 20,
                                  spreadRadius: 4,
                                ),
                              ],
                            ),
                            child: const Icon(Icons.touch_app_rounded,
                                color: Colors.white, size: 36),
                          ),
                        ],
                      );
                    }),
                  ),
                  _IconAction(
                    icon: Icons.edit_outlined,
                    onTap: () => _showTasbihList(context, controller),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  void _showTasbihList(BuildContext context, TasbihController controller) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.6,
        maxChildSize: 0.9,
        builder: (_, scrollController) => Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.dividerLight,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Text('Choisir un Tasbih',
                  style: AppTextStyles.heading3()),
            ),
            Expanded(
              child: Obx(() => ListView.builder(
                    controller: scrollController,
                    itemCount: controller.tasbihList.length,
                    itemBuilder: (_, i) {
                      final t = controller.tasbihList[i];
                      return ListTile(
                        leading: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.primary.withOpacity(0.1),
                          ),
                          child: Center(
                            child: Text('${t.targetCount}',
                                style: AppTextStyles.bodySmall(
                                    color: AppColors.primary)
                                    .copyWith(fontWeight: FontWeight.bold)),
                          ),
                        ),
                        title: Text(t.arabic,
                            style: AppTextStyles.arabicSmall(),
                            textDirection: TextDirection.rtl),
                        subtitle: Text(t.translation,
                            style: AppTextStyles.bodySmall()),
                        trailing:
                            controller.selectedIndex.value == i
                                ? const Icon(Icons.check_circle_rounded,
                                    color: AppColors.primary)
                                : null,
                        onTap: () {
                          controller.selectTasbih(i);
                          Get.back();
                        },
                      );
                    },
                  )),
            ),
          ],
        ),
      ),
    );
  }
}

class _TasbihBeads extends StatelessWidget {
  final int count;
  final int total;

  const _TasbihBeads({required this.count, required this.total});

  @override
  Widget build(BuildContext context) {
    const beadCount = 11;
    final activeBead = total > 0 ? (count / total * beadCount).floor() : 0;

    return SizedBox(
      height: 100,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // String
          CustomPaint(
            size: const Size(300, 80),
            painter: _BeadStringPainter(),
          ),
          // Beads
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(beadCount, (i) {
              final isActive = i < activeBead;
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: isActive ? 22 : 18,
                height: isActive ? 22 : 18,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: isActive
                      ? const LinearGradient(
                          colors: [AppColors.primaryLight, AppColors.primary],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                      : const LinearGradient(
                          colors: [Color(0xFF80C8A0), Color(0xFF4DAF7C)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                  boxShadow: [
                    BoxShadow(
                      color: (isActive ? AppColors.primary : const Color(0xFF4DAF7C))
                          .withOpacity(0.4),
                      blurRadius: isActive ? 8 : 4,
                      spreadRadius: isActive ? 2 : 0,
                    ),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _BeadStringPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primaryLight.withOpacity(0.4)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final path = Path();
    path.moveTo(20, size.height * 0.5);
    path.quadraticBezierTo(
        size.width * 0.5, size.height * 0.2, size.width - 20, size.height * 0.5);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _IconAction extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _IconAction({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.08),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.primary.withOpacity(0.2)),
        ),
        child: Icon(icon, color: AppColors.primary, size: 22),
      ),
    );
  }
}
