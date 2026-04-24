import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' hide TextDirection;
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/hijri_utils.dart';
import '../../../prayer/presentation/controllers/prayer_controller.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  DateTime _selectedDate = DateTime.now();
  bool _showIslamicFirst = true;

  // --- AlAdhan API pour les fêtes islamiques ---
  final _dio = Dio(BaseOptions(
    baseUrl: 'https://api.aladhan.com/v1',
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 20),
  ));

  List<Map<String, String>> _holidays = [];
  bool _loadingHolidays = false;

  // 8 événements islamiques fixes (jour hijri, mois hijri, emoji, nom arabe, nom français)
  static const List<Map<String, dynamic>> _islamicEvents = [
    {'hDay': 1,  'hMonth': 1,  'emoji': '🌙', 'nameAr': 'رأس السنة الهجرية', 'nameFr': 'Nouvel An Islamique'},
    {'hDay': 10, 'hMonth': 1,  'emoji': '🕌', 'nameAr': 'يوم عاشوراء',       'nameFr': 'Jour d\'Achoura'},
    {'hDay': 12, 'hMonth': 3,  'emoji': '💚', 'nameAr': 'المولد النبوي',      'nameFr': 'Mawlid An-Nabawi'},
    {'hDay': 27, 'hMonth': 7,  'emoji': '✨', 'nameAr': 'ليلة الإسراء',       'nameFr': 'Nuit du Mi\'raj'},
    {'hDay': 15, 'hMonth': 8,  'emoji': '🌟', 'nameAr': 'ليلة البراءة',       'nameFr': 'Nuit du Mi\'Raj (Laylat al-Baraat)'},
    {'hDay': 1,  'hMonth': 10, 'emoji': '🎉', 'nameAr': 'عيد الفطر',          'nameFr': 'Aïd al-Fitr'},
    {'hDay': 9,  'hMonth': 12, 'emoji': '🤲', 'nameAr': 'يوم عرفة',           'nameFr': 'Jour d\'Arafah'},
    {'hDay': 10, 'hMonth': 12, 'emoji': '🐑', 'nameAr': 'عيد الأضحى',         'nameFr': 'Aïd al-Adha'},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _fetchHolidays();
  }

  Future<void> _fetchHolidays() async {
    setState(() => _loadingHolidays = true);
    final hijriYear = HijriDate.now().hYear;
    final results = <Map<String, String>>[];

    for (final event in _islamicEvents) {
      try {
        final resp = await _dio.get(
          '/hToG/${event['hDay']}-${event['hMonth']}-$hijriYear',
        );
        if (resp.statusCode == 200 && resp.data['code'] == 200) {
          final greg = resp.data['data']['gregorian'];
          final day   = greg['day']   as String;
          final month = greg['month']['en'] as String;
          final year  = greg['year']  as String;
          results.add({
            'emoji':  event['emoji']  as String,
            'nameAr': event['nameAr'] as String,
            'nameFr': event['nameFr'] as String,
            'hijri':  '${event['hDay']} ${HijriUtils.getMonthNameAr(event['hMonth'] as int)} $hijriYear',
            'gregorian': '$day $month $year',
          });
        }
      } catch (_) {
        // fallback : sans date grégorienne
        results.add({
          'emoji':  event['emoji']  as String,
          'nameAr': event['nameAr'] as String,
          'nameFr': event['nameFr'] as String,
          'hijri':  '${event['hDay']} ${HijriUtils.getMonthNameAr(event['hMonth'] as int)} $hijriYear',
          'gregorian': '',
        });
      }
    }

    if (mounted) setState(() { _holidays = results; _loadingHolidays = false; });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final prayer = Get.find<PrayerController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildHeader(isDark),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildCalendarCard(isDark),
                  const SizedBox(height: 16),
                  _buildTabBar(isDark),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 280,
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        _buildPrayerTimesTab(prayer),
                        _buildHolidaysTab(isDark),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildDateConverter(isDark),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(bool isDark) {
    return SliverAppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded,
            color: Colors.white, size: 20),
        onPressed: () => Get.back(),
      ),
      title: Column(
        children: [
          Text('Calendrier',
              style: AppTextStyles.heading3(color: AppColors.white)),
          Text('التقويم الإسلامي',
              style: AppTextStyles.arabicSmall(color: AppColors.goldLight)),
        ],
      ),
      centerTitle: true,
      backgroundColor: AppColors.primary,
      actions: [
        IconButton(
          icon: const Icon(Icons.swap_vert_rounded, color: Colors.white),
          onPressed: () => setState(() => _showIslamicFirst = !_showIslamicFirst),
          tooltip: 'Inverser l\'affichage',
        ),
      ],
    );
  }

  Widget _buildCalendarCard(bool isDark) {
    final now = DateTime.now();
    final daysInMonth =
        DateUtils.getDaysInMonth(_selectedDate.year, _selectedDate.month);
    final firstDayOfMonth =
        DateTime(_selectedDate.year, _selectedDate.month, 1);
    final firstWeekday = firstDayOfMonth.weekday % 7;
    final hijriMonth =
        HijriDate.fromGregorian(DateTime(_selectedDate.year, _selectedDate.month));

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Month header
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left_rounded),
                  onPressed: () => setState(() {
                    _selectedDate = DateTime(
                        _selectedDate.year, _selectedDate.month - 1);
                  }),
                ),
                Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          DateFormat('MMMM, yyyy', 'fr').format(_selectedDate),
                          style: AppTextStyles.heading3(),
                        ),
                        const SizedBox(width: 4),
                        const Icon(Icons.arrow_drop_down_rounded,
                            color: AppColors.primary),
                      ],
                    ),
                    Text(
                      '${HijriUtils.getMonthNameAr(hijriMonth.hMonth)} ${hijriMonth.hYear}',
                      style: AppTextStyles.bodySmall(color: AppColors.primary),
                    ),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.chevron_right_rounded),
                      onPressed: () => setState(() {
                        _selectedDate = DateTime(
                            _selectedDate.year, _selectedDate.month + 1);
                      }),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                            color: AppColors.primary.withOpacity(0.3)),
                      ),
                      child: Text(
                        'Islamique',
                        style: AppTextStyles.caption(
                            color: AppColors.primary),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Day headers
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: ['Dim', 'Lun', 'Mar', 'Mer', 'Jeu', 'Ven', 'Sam']
                  .map((d) => SizedBox(
                        width: 36,
                        child: Text(d,
                            textAlign: TextAlign.center,
                            style: AppTextStyles.caption()),
                      ))
                  .toList(),
            ),
          ),
          const SizedBox(height: 4),
          // Days grid
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 12),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                childAspectRatio: 1,
              ),
              itemCount: firstWeekday + daysInMonth,
              itemBuilder: (_, i) {
                if (i < firstWeekday) return const SizedBox.shrink();
                final day = i - firstWeekday + 1;
                final date = DateTime(
                    _selectedDate.year, _selectedDate.month, day);
                final hijri = HijriDate.fromGregorian(date);
                final isToday = date.day == now.day &&
                    date.month == now.month &&
                    date.year == now.year;
                final isSelected = date.day == _selectedDate.day &&
                    date.month == _selectedDate.month;

                return GestureDetector(
                  onTap: () => setState(() => _selectedDate = date),
                  child: Container(
                    margin: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isSelected
                          ? AppColors.primary
                          : (isToday
                              ? AppColors.primary.withOpacity(0.12)
                              : null),
                      border: isToday && !isSelected
                          ? Border.all(color: AppColors.primary, width: 1.5)
                          : null,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '$day',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: isToday || isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                            color: isSelected
                                ? Colors.white
                                : (isToday
                                    ? AppColors.primary
                                    : null),
                          ),
                        ),
                        Text(
                          '${hijri.hDay}',
                          style: TextStyle(
                            fontSize: 9,
                            color: isSelected
                                ? Colors.white.withOpacity(0.7)
                                : AppColors.textSecondaryLight,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms);
  }

  Widget _buildTabBar(bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.backgroundLight,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(10),
        ),
        labelColor: Colors.white,
        unselectedLabelColor: AppColors.textSecondaryLight,
        dividerColor: Colors.transparent,
        tabs: const [
          Tab(text: 'Horaires des prières'),
          Tab(text: 'Fêtes islamiques'),
        ],
      ),
    );
  }

  Widget _buildPrayerTimesTab(PrayerController prayer) {
    return Obx(() {
      if (prayer.prayers.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }
      return ListView.builder(
        itemCount: prayer.prayers.length,
        itemBuilder: (_, i) {
          final p = prayer.prayers[i];
          return ListTile(
            leading: Icon(p.icon, color: p.color, size: 22),
            title: Text(p.name, style: AppTextStyles.bodyLarge()),
            trailing: Text(p.time,
                style: AppTextStyles.bodyMedium(color: p.color)
                    .copyWith(fontWeight: FontWeight.w600)),
          );
        },
      );
    });
  }

  Widget _buildHolidaysTab(bool isDark) {
    // Fallback sur données locales si l'API n'a pas encore répondu
    if (_loadingHolidays) {
      return const Center(child: CircularProgressIndicator(color: AppColors.primary));
    }

    if (_holidays.isEmpty) {
      final hijri = HijriDate.now();
      final local = HijriUtils.getIslamicHolidays(hijri.hYear);
      return ListView.builder(
        itemCount: local.length,
        itemBuilder: (_, i) => ListTile(
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.gold.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Center(child: Text('🌙', style: TextStyle(fontSize: 20))),
          ),
          title: Text(local[i]['name']!, style: AppTextStyles.bodyLarge()),
          subtitle: Text(local[i]['date']!, style: AppTextStyles.bodySmall()),
        ),
      );
    }

    return ListView.builder(
      itemCount: _holidays.length,
      itemBuilder: (_, i) {
        final h = _holidays[i];
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 4),
          decoration: BoxDecoration(
            color: isDark ? AppColors.cardDark : AppColors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.gold.withValues(alpha: 0.15)),
          ),
          child: ListTile(
            leading: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.gold.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(child: Text(h['emoji']!, style: const TextStyle(fontSize: 22))),
            ),
            title: Text(h['nameFr']!, style: AppTextStyles.bodyLarge()),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(h['nameAr']!, style: AppTextStyles.arabicSmall(color: AppColors.primary), textDirection: TextDirection.rtl),
                if (h['gregorian']!.isNotEmpty)
                  Text(h['gregorian']!, style: AppTextStyles.caption()),
                Text(h['hijri']!, style: AppTextStyles.caption(color: AppColors.textSecondaryLight)),
              ],
            ),
            isThreeLine: true,
          ),
        );
      },
    );
  }

  Widget _buildDateConverter(bool isDark) {
    final hijri = HijriDate.fromGregorian(_selectedDate);
    final gregorianStr =
        DateFormat('MMMM dd, yyyy', 'fr').format(_selectedDate);
    final islamicStr =
        '${HijriUtils.getMonthNameAr(hijri.hMonth)} ${hijri.hDay}, ${hijri.hYear}';

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Date', style: AppTextStyles.heading3()),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.backgroundLight,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.dividerLight),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Calendrier grégorien',
                          style: AppTextStyles.caption()),
                      const SizedBox(height: 4),
                      Text(gregorianStr, style: AppTextStyles.bodyLarge()),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.backgroundLight,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.dividerLight),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Calendrier islamique',
                          style: AppTextStyles.caption()),
                      const SizedBox(height: 4),
                      Text(islamicStr,
                          style: AppTextStyles.arabicSmall(
                              color: AppColors.primary),
                          textDirection: TextDirection.rtl),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate(delay: 200.ms).fadeIn(duration: 400.ms);
  }
}
