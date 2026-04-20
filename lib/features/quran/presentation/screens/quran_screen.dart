import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../controllers/quran_controller.dart';
import 'quran_surah_screen.dart';

class QuranScreen extends StatelessWidget {
  const QuranScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(QuranController());
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (ctx, inner) => [
            SliverAppBar(
              expandedHeight: 160,
              pinned: true,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded,
                    color: Colors.white, size: 20),
                onPressed: () => Get.back(),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.headphones_outlined,
                      color: Colors.white),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.more_vert_rounded,
                      color: Colors.white),
                  onPressed: () => _showOptions(context, controller),
                ),
              ],
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [AppColors.primaryDark, AppColors.primary],
                    ),
                  ),
                  child: SafeArea(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('القرآن الكريم',
                            style: AppTextStyles.arabicLarge(
                                color: AppColors.gold)),
                        Text('Le Saint Coran',
                            style: AppTextStyles.heading2(
                                color: AppColors.white)),
                        const SizedBox(height: 4),
                        Obx(() => Text(
                              'Dernière lecture: Page ${controller.currentPage.value}',
                              style: AppTextStyles.bodySmall(
                                  color: AppColors.white.withOpacity(0.7)),
                            )),
                      ],
                    ),
                  ),
                ),
              ),
              backgroundColor: AppColors.primary,
              bottom: TabBar(
                indicatorColor: AppColors.gold,
                indicatorWeight: 3,
                labelColor: AppColors.gold,
                unselectedLabelColor: AppColors.white.withOpacity(0.6),
                labelStyle: AppTextStyles.bodyMedium(color: AppColors.gold),
                tabs: const [
                  Tab(text: 'Sourates'),
                  Tab(text: 'Juz'),
                  Tab(text: 'Favoris'),
                ],
              ),
            ),
          ],
          body: TabBarView(
            children: [
              _SurahTab(controller: controller),
              _JuzTab(controller: controller),
              _BookmarksTab(controller: controller),
            ],
          ),
        ),
        // Audio player bar
        bottomNavigationBar: Obx(() {
          if (!controller.isPlaying.value) return const SizedBox.shrink();
          return _AudioPlayerBar(controller: controller);
        }),
      ),
    );
  }

  void _showOptions(BuildContext context, QuranController controller) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Paramètres', style: AppTextStyles.heading3()),
            const SizedBox(height: 20),
            Text('Récitateur', style: AppTextStyles.bodyLarge()),
            const SizedBox(height: 10),
            ...controller.reciters.map((r) => ListTile(
                  title: Text(r),
                  trailing: Obx(() => controller.selectedReciter.value == r
                      ? const Icon(Icons.check_rounded,
                          color: AppColors.primary)
                      : const SizedBox.shrink()),
                  onTap: () {
                    controller.selectReciter(r);
                    Get.back();
                  },
                )),
          ],
        ),
      ),
    );
  }
}

class _SurahTab extends StatelessWidget {
  final QuranController controller;

  const _SurahTab({required this.controller});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: controller.surahs.length,
      itemBuilder: (ctx, i) {
        final s = controller.surahs[i];
        return _SurahTile(
          surah: s,
          isDark: isDark,
          onTap: () => Get.to(() => QuranSurahScreen(surah: s)),
        ).animate(delay: (i * 40).ms).fadeIn(duration: 250.ms);
      },
    );
  }
}

class _SurahTile extends StatelessWidget {
  final Map<String, dynamic> surah;
  final bool isDark;
  final VoidCallback onTap;

  const _SurahTile(
      {required this.surah, required this.isDark, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            '${surah['number']}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      title: Text(surah['name'], style: AppTextStyles.bodyLarge()),
      subtitle: Text(
        '${surah['type']} • ${surah['verses']} versets',
        style: AppTextStyles.bodySmall(),
      ),
      trailing: Text(
        surah['nameAr'],
        style: AppTextStyles.arabicSmall(color: AppColors.primary),
      ),
    );
  }
}

class _JuzTab extends StatelessWidget {
  final QuranController controller;

  const _JuzTab({required this.controller});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 30,
      itemBuilder: (ctx, i) {
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.dividerLight),
          ),
          child: ListTile(
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text('${i + 1}',
                    style: AppTextStyles.bodyLarge(color: AppColors.primary)),
              ),
            ),
            title: Text('Juz ${i + 1}', style: AppTextStyles.bodyLarge()),
            subtitle: Text('Pages ${(i * 20) + 1} - ${(i + 1) * 20}',
                style: AppTextStyles.bodySmall()),
            trailing: const Icon(Icons.chevron_right_rounded,
                color: AppColors.textSecondaryLight),
          ),
        );
      },
    );
  }
}

class _BookmarksTab extends StatelessWidget {
  final QuranController controller;

  const _BookmarksTab({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.bookmarks.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('🔖', style: TextStyle(fontSize: 64)),
              const SizedBox(height: 16),
              Text('Aucun favori', style: AppTextStyles.heading3()),
              const SizedBox(height: 8),
              Text('Ajoutez des pages à vos favoris',
                  style: AppTextStyles.bodyMedium()),
            ],
          ),
        );
      }
      return ListView.builder(
        itemCount: controller.bookmarks.length,
        itemBuilder: (ctx, i) => ListTile(
          leading: const Icon(Icons.bookmark_rounded, color: AppColors.primary),
          title: Text('Page ${controller.bookmarks[i]}'),
          trailing: IconButton(
            icon: const Icon(Icons.delete_outline_rounded),
            onPressed: () =>
                controller.toggleBookmark(controller.bookmarks[i]),
          ),
        ),
      );
    });
  }
}

class _AudioPlayerBar extends StatelessWidget {
  final QuranController controller;

  const _AudioPlayerBar({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.primaryDark,
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, -2))
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Obx(() => Text(
                  controller.selectedReciter.value,
                  style: AppTextStyles.bodySmall(color: AppColors.white),
                )),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.skip_previous_rounded,
                  color: Colors.white, size: 24),
              onPressed: () {},
            ),
            GestureDetector(
              onTap: controller.togglePlayPause,
              child: Container(
                width: 42,
                height: 42,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary,
                ),
                child: Obx(() => Icon(
                      controller.isPlaying.value
                          ? Icons.pause_rounded
                          : Icons.play_arrow_rounded,
                      color: Colors.white,
                      size: 24,
                    )),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.skip_next_rounded,
                  color: Colors.white, size: 24),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.repeat_rounded,
                  color: Colors.white, size: 20),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
