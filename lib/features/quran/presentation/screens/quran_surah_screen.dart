import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../controllers/quran_controller.dart';

class QuranSurahScreen extends StatefulWidget {
  final Map<String, dynamic> surah;

  const QuranSurahScreen({super.key, required this.surah});

  @override
  State<QuranSurahScreen> createState() => _QuranSurahScreenState();
}

class _QuranSurahScreenState extends State<QuranSurahScreen> {
  late final QuranController _controller;

  @override
  void initState() {
    super.initState();
    _controller = Get.find<QuranController>();
    _controller.fetchSurahAyahs(widget.surah['number'] as int);
  }

  void _onSavePressed(bool alreadyCached) {
    final surahNumber = widget.surah['number'] as int;
    if (alreadyCached) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Supprimer le cache ?'),
          content: Text('Retirer "${widget.surah['name']}" de la lecture hors-ligne ?'),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Annuler')),
            TextButton(
              onPressed: () { Navigator.pop(ctx); _controller.deleteSurahCache(surahNumber); },
              child: const Text('Supprimer', style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      );
    } else {
      _controller.saveSurahOffline(surahNumber);
    }
  }

  @override
  Widget build(BuildContext context) {
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
            Text(
              widget.surah['name'] as String,
              style: AppTextStyles.heading3(
                  color: isDark
                      ? AppColors.white
                      : AppColors.textPrimaryLight),
            ),
            Text(
              '${widget.surah['verses']} versets · ${widget.surah['type']}',
              style: AppTextStyles.bodySmall(),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          Obx(() => IconButton(
                icon: Icon(Icons.headset_rounded,
                    color: _controller.isPlaying.value
                        ? AppColors.primary
                        : (isDark ? AppColors.white : AppColors.textPrimaryLight)),
                onPressed: _controller.togglePlayPause,
              )),
          Obx(() {
            final cached = _controller.isCurrentSurahCached.value;
            final saving = _controller.isSaving.value;
            if (saving) {
              return const Padding(
                padding: EdgeInsets.all(14),
                child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.gold)),
              );
            }
            return IconButton(
              icon: Icon(
                cached ? Icons.download_done_rounded : Icons.download_outlined,
                color: cached ? AppColors.gold : (isDark ? AppColors.white : AppColors.textPrimaryLight),
              ),
              tooltip: cached ? 'Supprimer du cache' : 'Sauvegarder hors-ligne',
              onPressed: () => _onSavePressed(cached),
            );
          }),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              if (_controller.isLoadingAyahs.value) {
                return const Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                );
              }
              if (_controller.currentAyahs.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.wifi_off_rounded,
                          size: 48, color: AppColors.primary),
                      const SizedBox(height: 12),
                      Text('Impossible de charger les versets',
                          style: AppTextStyles.bodyMedium()),
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: () => _controller.fetchSurahAyahs(
                            widget.surah['number'] as int),
                        child: const Text('Réessayer'),
                      ),
                    ],
                  ),
                );
              }
              return ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  Center(
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40, vertical: 10),
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: AppColors.gold.withValues(alpha: 0.5),
                                width: 2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            widget.surah['nameAr'] as String,
                            style: AppTextStyles.arabicLarge(
                                color: isDark
                                    ? AppColors.gold
                                    : AppColors.primaryDark),
                          ),
                        ),
                        const SizedBox(height: 12),
                        if ((widget.surah['number'] as int) != 9)
                          Text(
                            'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
                            style: AppTextStyles.arabicMedium(
                                color: isDark
                                    ? AppColors.textPrimaryDark
                                    : AppColors.textPrimaryLight),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  ..._controller.currentAyahs.map((ayah) => _AyahTile(
                        ayah: ayah,
                        isDark: isDark,
                        controller: _controller,
                      )),
                ],
              );
            }),
          ),
          _buildAudioControls(isDark),
        ],
      ),
    );
  }

  Widget _buildAudioControls(bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.white,
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 10,
              offset: const Offset(0, -2))
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text('1.0x',
                style: AppTextStyles.bodyMedium(color: AppColors.primary)
                    .copyWith(fontWeight: FontWeight.w600)),
            IconButton(
              icon: const Icon(Icons.replay_10_rounded),
              onPressed: () {},
              color: isDark ? AppColors.white : AppColors.textPrimaryLight,
            ),
            GestureDetector(
              onTap: _controller.togglePlayPause,
              child: Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: AppColors.primaryGradient,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.3),
                      blurRadius: 12,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Obx(() => Icon(
                      _controller.isPlaying.value
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
  final Map<String, dynamic> ayah;
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
        color: isDark ? AppColors.cardDark : const Color(0xFFFFFDF5),
        borderRadius: BorderRadius.circular(16),
        border:
            Border.all(color: AppColors.gold.withValues(alpha: 0.15), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.gold, width: 1.5),
                ),
                child: Center(
                  child: Text(
                    ayah['number'] as String,
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
          Text(
            ayah['arabic'] as String,
            style: AppTextStyles.quranVerse(
                color: isDark
                    ? AppColors.textPrimaryDark
                    : AppColors.textPrimaryLight),
            textAlign: TextAlign.right,
            textDirection: TextDirection.rtl,
          ),
          Obx(() {
            if (!controller.showTranslation.value) {
              return const SizedBox.shrink();
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),
                Text(
                  ayah['translation'] as String,
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
