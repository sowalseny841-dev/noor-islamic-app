import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/services/storage_service.dart';
import '../../../prayer/presentation/controllers/prayer_controller.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late final StorageService _storage;

  @override
  void initState() {
    super.initState();
    _storage = Get.find<StorageService>();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text('Paramètres',
            style: AppTextStyles.heading3(color: AppColors.white)),
        backgroundColor: AppColors.primary,
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _SectionHeader(title: 'Prière'),
          _SettingsTile(
            icon: Icons.location_on_outlined,
            title: 'Localisation',
            subtitle: _storage.cityName,
            onTap: _refreshLocation,
          ),
          _SettingsTile(
            icon: Icons.calculate_outlined,
            title: 'Méthode de calcul',
            subtitle: _storage.calculationMethod,
            onTap: () => _showMethodPicker(context),
          ),
          _SettingsTile(
            icon: Icons.notifications_outlined,
            title: 'Notifications Azan',
            trailing: Switch(
              value: _storage.notificationsEnabled,
              onChanged: (val) {
                _storage.setNotificationsEnabled(val);
                setState(() {});
              },
              activeColor: AppColors.primary,
            ),
            onTap: () {},
          ),
          _SectionHeader(title: 'Apparence'),
          _SettingsTile(
            icon: Icons.dark_mode_outlined,
            title: 'Thème',
            subtitle: _themeLabel(_storage.themeMode),
            onTap: () => _showThemePicker(context),
          ),
          _SettingsTile(
            icon: Icons.language_outlined,
            title: 'Langue',
            subtitle: _storage.language == 'ar' ? 'العربية' : 'Français',
            onTap: () => _showLanguagePicker(context),
          ),
          _SectionHeader(title: 'À propos'),
          _SettingsTile(
            icon: Icons.info_outline_rounded,
            title: 'Version',
            subtitle: '1.0.5',
            onTap: () {},
          ),
          _SettingsTile(
            icon: Icons.star_outline_rounded,
            title: 'Évaluer l\'application',
            onTap: _rateApp,
          ),
          _SettingsTile(
            icon: Icons.share_outlined,
            title: 'Partager l\'application',
            onTap: _shareApp,
          ),
          _SettingsTile(
            icon: Icons.privacy_tip_outlined,
            title: 'Politique de confidentialité',
            onTap: _openPrivacyPolicy,
          ),
        ],
      ),
    );
  }

  String _themeLabel(String mode) {
    switch (mode) {
      case 'light': return 'Clair';
      case 'dark': return 'Sombre';
      default: return 'Système';
    }
  }

  Future<void> _refreshLocation() async {
    Get.snackbar('Localisation', 'Mise à jour en cours...',
        backgroundColor: AppColors.primary, colorText: Colors.white,
        duration: const Duration(seconds: 2));
    try {
      final prayer = Get.find<PrayerController>();
      await prayer.refreshLocation();
      setState(() {});
      Get.snackbar('Localisation', 'Position mise à jour : ${_storage.cityName}',
          backgroundColor: Colors.green, colorText: Colors.white);
    } catch (_) {
      Get.snackbar('Erreur', 'Impossible de mettre à jour la localisation.',
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  void _showMethodPicker(BuildContext context) {
    final methods = [
      'MuslimWorldLeague',
      'Egypt',
      'Karachi',
      'NorthAmerica',
      'Dubai',
      'France',
    ];
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 16),
            Text('Méthode de calcul', style: AppTextStyles.heading3()),
            const SizedBox(height: 8),
            ...methods.map((m) => ListTile(
                  title: Text(m),
                  trailing: _storage.calculationMethod == m
                      ? const Icon(Icons.check_rounded, color: AppColors.primary)
                      : null,
                  onTap: () async {
                    await _storage.setCalculationMethod(m);
                    setModalState(() {});
                    setState(() {});
                    Get.back();
                    Get.snackbar('Méthode', 'Méthode "$m" appliquée',
                        backgroundColor: AppColors.primary,
                        colorText: Colors.white);
                  },
                )),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _showThemePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 16),
          Text('Choisir un thème', style: AppTextStyles.heading3()),
          const SizedBox(height: 8),
          ...['system', 'light', 'dark'].map((t) => ListTile(
                leading: Icon(
                  t == 'light'
                      ? Icons.wb_sunny_rounded
                      : t == 'dark'
                          ? Icons.nights_stay_rounded
                          : Icons.settings_suggest_rounded,
                  color: AppColors.primary,
                ),
                title: Text(t == 'light'
                    ? 'Clair'
                    : t == 'dark'
                        ? 'Sombre'
                        : 'Système'),
                trailing: _storage.themeMode == t
                    ? const Icon(Icons.check_rounded, color: AppColors.primary)
                    : null,
                onTap: () async {
                  await _storage.setThemeMode(t);
                  final mode = t == 'dark'
                      ? ThemeMode.dark
                      : t == 'light'
                          ? ThemeMode.light
                          : ThemeMode.system;
                  Get.changeThemeMode(mode);
                  setState(() {});
                  Get.back();
                },
              )),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  void _showLanguagePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 16),
          Text('Langue / اللغة', style: AppTextStyles.heading3()),
          const SizedBox(height: 8),
          ListTile(
            leading: const Text('🇫🇷', style: TextStyle(fontSize: 28)),
            title: const Text('Français'),
            trailing: _storage.language == 'fr'
                ? const Icon(Icons.check_rounded, color: AppColors.primary)
                : null,
            onTap: () async {
              await _storage.setLanguage('fr');
              Get.updateLocale(const Locale('fr', 'FR'));
              setState(() {});
              Get.back();
            },
          ),
          ListTile(
            leading: const Text('🇸🇦', style: TextStyle(fontSize: 28)),
            title: const Text('العربية'),
            trailing: _storage.language == 'ar'
                ? const Icon(Icons.check_rounded, color: AppColors.primary)
                : null,
            onTap: () async {
              await _storage.setLanguage('ar');
              Get.updateLocale(const Locale('ar', 'SA'));
              setState(() {});
              Get.back();
            },
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Future<void> _rateApp() async {
    const url = 'https://play.google.com/store/apps/details?id=com.noor.app';
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      Get.snackbar('Info', 'Application non encore disponible sur le Play Store.',
          backgroundColor: AppColors.primary, colorText: Colors.white);
    }
  }

  Future<void> _shareApp() async {
    await Share.share(
      'Découvre Noor — نور, l\'application islamique complète :\n'
      '🕌 Horaires de prière\n📖 Coran complet\n📿 Azkar\n🧭 Qibla\n\n'
      'Télécharge-la sur le Play Store : https://play.google.com/store/apps/details?id=com.noor.app',
      subject: 'Noor — Application Islamique',
    );
  }

  Future<void> _openPrivacyPolicy() async {
    const url = 'https://sowalseny841-dev.github.io/noor-islamic-app/docs/privacy-policy.html';
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(4, 20, 4, 8),
        child: Text(
          title.toUpperCase(),
          style: AppTextStyles.caption(color: AppColors.primary)
              .copyWith(letterSpacing: 1.2, fontWeight: FontWeight.w600),
        ),
      );
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback onTap;

  const _SettingsTile({
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: isDark ? AppColors.dividerDark : AppColors.dividerLight),
      ),
      child: ListTile(
        leading: Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: AppColors.primary, size: 20),
        ),
        title: Text(title, style: AppTextStyles.bodyLarge()),
        subtitle: subtitle != null
            ? Text(subtitle!, style: AppTextStyles.bodySmall())
            : null,
        trailing: trailing ??
            const Icon(Icons.chevron_right_rounded,
                color: AppColors.textSecondaryLight),
        onTap: onTap,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
