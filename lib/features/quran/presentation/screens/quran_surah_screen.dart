import 'dart:ui' show TextDirection;
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide TextDirection;
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../controllers/quran_controller.dart';

class QuranSurahScreen extends StatelessWidget {
  final Map<String, dynamic> surah;

  const QuranSurahScreen({super.key, required this.surah});

  // Sample ayahs for Al-Fatihah (surah 1)
  static const List<Map<String, String>> _fatihahAyahs = [
    {
      'number': '1',
      'arabic': 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
      'translation': 'Au nom d\'Allah, le Tout Miséricordieux, le Très Miséricordieux',
    },
    {
      'number': '2',
      'arabic': 'الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ',
      'translation': 'Louange à Allah, Seigneur de l\'univers',
    },
    {
      'number': '3',
      'arabic': 'الرَّحْمَٰنِ الرَّحِيمِ',
      'translation': 'Le Tout Miséricordieux, le Très Miséricordieux',
    },
    {
      'number': '4',
      'arabic': 'مَالِكِ يَوْمِ الدِّينِ',
      'translation': 'Maître du Jour de la rétribution.',
    },
    {
      'number': '5',
      'arabic': 'إِيَّاكَ نَعْبُدُ وَإِيَّاكَ نَسْتَعِينُ',
      'translation': 'C\'est Toi [Seul] que nous adorons, et c\'est Toi [Seul] dont nous implorons le secours.',
    },
    {
      'number': '6',
      'arabic': 'اهْدِنَا الصِّرَاطَ الْمُسْتَقِيمَ',
      'translation': 'Guide-nous dans le droit chemin',
    },
    {
      'number': '7',
      'arabic': 'صِرَاطَ الَّذِينَ أَنْعَمْتَ عَلَيْهِمْ غَيْرِ الْمَغْضُوبِ عَلَيْهِمْ وَلَا الضَّالِّينَ',
      'translation': 'le chemin de ceux que Tu as comblés de faveurs, non pas de ceux qui ont encouru Ta colère, ni des égarés.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<QuranController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.backgroundDark : const Color(0xFFFFFBF0),
      appBar: AppBar(
        backgroundColor:
            isDark ? AppColors.surfaceDark : const Color(0xFFFFFBF0),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded,
              color: isDark ? AppColors.white : AppColors.textPrimaryLight,
              size: 20),
          onPressed: () => Get.back(),
        ),
        title: Column(
          children: [
            Text(surah['name'],
                style: AppTextStyles.heading3(
                    color: isDark
                        ? AppColors.white
                        : AppColors.textPrimaryLight)),
            Text('Juz ${surah['juz']}, Page1',
                style: AppTextStyles.bodySmall()),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.bookmark_border_rounded,
                color: isDark ? AppColors.white : AppColors.textPrimaryLight),
            onPressed: () => controller.toggleBookmark(1),
          ),
          Obx(() => IconButton(
                icon: Icon(Icons.headset_rounded,
                    color: controller.isPlaying.value
                        ? AppColors.primary
                        : (isDark
                            ? AppColors.white
                            : AppColors.textPrimaryLight)),
                onPressed: controller.togglePlayPause,
              )),
          IconButton(
            icon: Icon(Icons.more_horiz_rounded,
                color: isDark ? AppColors.white : AppColors.textPrimaryLight),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                // Surah header
                Center(
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 10),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: AppColors.gold.withOpacity(0.5), width: 2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'سُورَةُ ${surah['nameAr']}',
                          style: AppTextStyles.arabicLarge(
                              color: isDark
                                  ? AppColors.gold
                                  : AppColors.primaryDark),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text('بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
                          style: AppTextStyles.arabicMedium(
                              color: isDark
                                  ? AppColors.textPrimaryDark
                                  : AppColors.textPrimaryLight)),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                // Ayahs
                ..._fatihahAyahs.map((ayah) => _AyahTile(
                      ayah: ayah,
                      isDark: isDark,
                      controller: controller,
                    )),
              ],
            ),
          ),
          // Audio controls
          _buildAudioControls(context, controller, isDark),
        ],
      ),
    );
  }

  Widget _buildAudioControls(
      BuildContext context, QuranController controller, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.white,
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, -2))
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              '1.0x',
              style: AppTextStyles.bodyMedium(color: AppColors.primary)
                  .copyWith(fontWeight: FontWeight.w600),
            ),
            IconButton(
              icon: const Icon(Icons.replay_10_rounded),
              onPressed: () {},
              color: isDark ? AppColors.white : AppColors.textPrimaryLight,
            ),
            GestureDetector(
              onTap: controller.togglePlayPause,
              child: Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: AppColors.primaryGradient,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.3),
                      blurRadius: 12,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Obx(() => Icon(
                      controller.isPlaying.value
                          ? Icons.pause_rounded
                          : Icons.play_arrow_rounded,
                      color: Colors.white,
                      size: 30,
                    )),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.forward_10_rounded),
              onPressed: () {},
              color: isDark ? AppColors.white : AppColors.textPrimaryLight,
            ),
            IconButton(
              icon: const Icon(Icons.repeat_rounded),
              onPressed: () {},
              color: isDark ? AppColors.white : AppColors.textSecondaryLight,
            ),
          ],
        ),
      ),
    );
  }
}

class _AyahTile extends StatelessWidget {
  final Map<String, String> ayah;
  final bool isDark;
  final QuranController controller;

  const _AyahTile(
      {required this.ayah, required this.isDark, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.cardDark
            : const Color(0xFFFFFDF5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: AppColors.gold.withOpacity(0.15), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Ayah number badge
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.gold, width: 1.5),
                ),
                child: Center(
                  child: Text(
                    ayah['number']!,
                    style: AppTextStyles.bodySmall(color: AppColors.gold)
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.play_circle_outline_rounded,
                    color: AppColors.primary),
                onPressed: controller.togglePlayPause,
                iconSize: 22,
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Arabic
          Text(
            ayah['arabic']!,
            style: controller.showTranslation.value
                ? AppTextStyles.quranVerse(
                    color: isDark
                        ? AppColors.textPrimaryDark
                        : AppColors.textPrimaryLight)
                : AppTextStyles.quranVerse(
                    color: isDark
                        ? AppColors.textPrimaryDark
                        : AppColors.textPrimaryLight),
            textAlign: TextAlign.right,
            textDirection: TextDirection.rtl,
          ),
          // Translation
          Obx(() {
            if (!controller.showTranslation.value) {
              return const SizedBox.shrink();
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),
                Text(
                  ayah['translation']!,
                  style: AppTextStyles.bodyMedium(
                    color: isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondaryLight,
                  ),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }
}
