import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/hijri_utils.dart';
import '../../../../shared/models/prayer_model.dart';
import '../controllers/prayer_controller.dart';
import 'azan_screen.dart';
import '../../../azkar/presentation/screens/azkar_list_screen.dart';
import '../../../quran/presentation/screens/quran_screen.dart';
import '../../../tasbih/presentation/screens/tasbih_screen.dart';
import '../../../calendar/presentation/screens/calendar_screen.dart';
import '../../../settings/presentation/screens/qibla_screen.dart';

class PrayerScreen extends StatelessWidget {
  const PrayerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PrayerController>();

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildHeader(controller),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildPrayerList(controller),
                  const SizedBox(height: 24),
                  _buildQuickAccessGrid(context),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(PrayerController controller) {
    return SliverAppBar(
      expandedHeight: 220,
      pinned: true,
      automaticallyImplyLeading: false,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [AppColors.primaryDark, AppColors.primary],
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Opacity(
                  opacity: 0.1,
                  child: CustomPaint(
                    size: const Size(double.infinity, 100),
                    painter: _MosqueHeaderPainter(),
                  ),
                ),
              ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Obx(() => Row(
                                children: [
                                  const Icon(Icons.location_on_rounded,
                                      color: AppColors.gold, size: 18),
                                  const SizedBox(width: 4),
                                  Text(
                                    controller.cityName.value,
                                    style: AppTextStyles.bodyMedium(
                                        color: AppColors.white),
                                  ),
                                ],
                              )),
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.share_outlined,
                                    color: AppColors.white, size: 20),
                                onPressed: () {},
                              ),
                              IconButton(
                                icon: const Icon(Icons.settings_outlined,
                                    color: AppColors.white, size: 20),
                                onPressed: () {},
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Obx(() {
                        final next = controller.nextPrayerName.value;
                        final time = controller.currentTime.value;
                        return Column(
                          children: [
                            Text(
                              next.isEmpty ? 'Isha' : next,
                              style: AppTextStyles.prayerName(
                                  color: AppColors.white),
                            ),
                            Text(
                              time,
                              style: AppTextStyles.prayerTime(
                                  color: AppColors.white),
                            ),
                            Text(
                              'Prière suivante en ${controller.nextPrayerCountdown.value}',
                              style: AppTextStyles.bodySmall(
                                  color: AppColors.white.withOpacity(0.7)),
                            ),
                          ],
                        );
                      }),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                              color: AppColors.gold.withOpacity(0.5)),
                        ),
                        child: Text(
                          HijriUtils.getTodayHijri(),
                          style: AppTextStyles.bodySmall(
                              color: AppColors.goldLight),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: AppColors.primary,
    );
  }

  Widget _buildPrayerList(PrayerController controller) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }
      return Column(
        children: List.generate(
          controller.prayers.length,
          (i) => _PrayerTile(
            prayer: controller.prayers[i],
            index: i,
          ).animate(delay: (i * 80).ms).fadeIn(duration: 300.ms).slideX(begin: 0.1, end: 0),
        ),
      );
    });
  }

  Widget _buildQuickAccessGrid(BuildContext context) {
    final items = [
      _QuickItem('Coran', '📖', () => Get.to(() => const QuranScreen())),
      _QuickItem('Azkar', '🌿', () => Get.to(() => const AzkarListScreen())),
      _QuickItem('Tasbih', '📿', () => Get.to(() => const TasbihScreen())),
      _QuickItem('Qibla', '🧭', () => Get.to(() => const QiblaScreen())),
      _QuickItem('Mosquée', '🕌', () {}),
      _QuickItem('Traqueur', '✅', () {}),
      _QuickItem('Calendrier', '📅', () => Get.to(() => const CalendarScreen())),
      _QuickItem('Dua', '🤲', () {}),
      _QuickItem('Galerie', '🖼️', () {}),
      _QuickItem('99 Noms', '✨', () {}),
    ];

    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
        mainAxisSpacing: 12,
        crossAxisSpacing: 8,
        childAspectRatio: 0.85,
      ),
      itemCount: items.length,
      itemBuilder: (_, i) => _QuickItemTile(item: items[i]),
    );
  }
}

class _PrayerTile extends StatefulWidget {
  final PrayerModel prayer;
  final int index;

  const _PrayerTile({required this.prayer, required this.index});

  @override
  State<_PrayerTile> createState() => _PrayerTileState();
}

class _PrayerTileState extends State<_PrayerTile> {
  bool _notifEnabled = true;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final prayer = widget.prayer;

    return GestureDetector(
      onTap: () => Get.to(() => AzanScreen(prayerName: prayer.name,
          prayerTime: prayer.time, prayerColor: prayer.color)),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: prayer.isActive
              ? prayer.color.withOpacity(0.12)
              : (isDark ? AppColors.cardDark : AppColors.white),
          borderRadius: BorderRadius.circular(16),
          border: prayer.isActive
              ? Border.all(color: prayer.color.withOpacity(0.4), width: 1.5)
              : Border.all(
                  color: isDark
                      ? AppColors.dividerDark
                      : AppColors.dividerLight,
                  width: 1),
          boxShadow: prayer.isActive
              ? [
                  BoxShadow(
                    color: prayer.color.withOpacity(0.15),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  )
                ]
              : null,
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: prayer.color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(prayer.icon, color: prayer.color, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(prayer.name, style: AppTextStyles.bodyLarge()),
                      if (prayer.isActive) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: prayer.color,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text('Actuelle',
                              style: AppTextStyles.caption(
                                  color: AppColors.white)),
                        ),
                      ]
                    ],
                  ),
                  Text(prayer.nameAr,
                      style: AppTextStyles.arabicSmall(
                          color: AppColors.textSecondaryLight)),
                ],
              ),
            ),
            Row(
              children: [
                if (_notifEnabled)
                  Icon(Icons.notifications_active_rounded,
                      color: prayer.color, size: 18)
                else
                  Icon(Icons.notifications_off_outlined,
                      color: AppColors.textSecondaryLight, size: 18),
                const SizedBox(width: 12),
                Text(prayer.time,
                    style: AppTextStyles.heading3(color: prayer.color)),
                const SizedBox(width: 8),
                Checkbox(
                  value: prayer.isActive,
                  onChanged: (_) {},
                  activeColor: prayer.color,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickItem {
  final String label;
  final String emoji;
  final VoidCallback onTap;
  const _QuickItem(this.label, this.emoji, this.onTap);
}

class _QuickItemTile extends StatelessWidget {
  final _QuickItem item;
  const _QuickItemTile({required this.item});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: item.onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                  color: AppColors.primary.withOpacity(0.2), width: 1),
            ),
            child: Center(
              child: Text(item.emoji,
                  style: const TextStyle(fontSize: 26)),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            item.label,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondaryLight,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _MosqueHeaderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    final path = Path();
    final w = size.width;
    final h = size.height;
    path.moveTo(0, h);
    path.lineTo(0, h * 0.5);
    path.lineTo(w * 0.1, h * 0.5);
    path.lineTo(w * 0.1, h * 0.1);
    path.quadraticBezierTo(w * 0.12, 0, w * 0.14, h * 0.1);
    path.lineTo(w * 0.14, h * 0.5);
    path.lineTo(w * 0.35, h * 0.5);
    path.lineTo(w * 0.35, h * 0.3);
    path.quadraticBezierTo(w * 0.42, h * 0.1, w * 0.5, 0);
    path.quadraticBezierTo(w * 0.58, h * 0.1, w * 0.65, h * 0.3);
    path.lineTo(w * 0.65, h * 0.5);
    path.lineTo(w * 0.86, h * 0.5);
    path.lineTo(w * 0.86, h * 0.1);
    path.quadraticBezierTo(w * 0.88, 0, w * 0.90, h * 0.1);
    path.lineTo(w * 0.90, h * 0.5);
    path.lineTo(w, h * 0.5);
    path.lineTo(w, h);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
