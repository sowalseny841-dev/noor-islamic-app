import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/services/storage_service.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final storage = Get.find<StorageService>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text('Paramètres', style: AppTextStyles.heading3(color: AppColors.white)),
        backgroundColor: AppColors.primary,
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _SectionHeader(title: 'Compte'),
          _SettingsTile(
            icon: Icons.person_outline_rounded,
            title: 'Mon Profil',
            onTap: () {},
          ),
          _SectionHeader(title: 'Prière'),
          _SettingsTile(
            icon: Icons.location_on_outlined,
            title: 'Localisation',
            subtitle: storage.cityName,
            onTap: () {},
          ),
          _SettingsTile(
            icon: Icons.calculate_outlined,
            title: 'Méthode de calcul',
            subtitle: storage.calculationMethod,
            onTap: () => _showMethodPicker(context, storage),
          ),
          _SettingsTile(
            icon: Icons.notifications_outlined,
            title: 'Notifications Azan',
            trailing: Switch(
              value: storage.notificationsEnabled,
              onChanged: (val) => storage.setNotificationsEnabled(val),
              activeColor: AppColors.primary,
            ),
            onTap: () {},
          ),
          _SectionHeader(title: 'Apparence'),
          _SettingsTile(
            icon: Icons.dark_mode_outlined,
            title: 'Thème',
            subtitle: _themeLabel(storage.themeMode),
            onTap: () => _showThemePicker(context, storage),
          ),
          _SettingsTile(
            icon: Icons.language_outlined,
            title: 'Langue',
            subtitle: storage.language == 'fr' ? 'Français' : 'العربية',
            onTap: () {},
          ),
          _SectionHeader(title: 'À propos'),
          _SettingsTile(
            icon: Icons.info_outline_rounded,
            title: 'Version',
            subtitle: '1.0.0',
            onTap: () {},
          ),
          _SettingsTile(
            icon: Icons.star_outline_rounded,
            title: 'Évaluer l\'application',
            onTap: () {},
          ),
          _SettingsTile(
            icon: Icons.share_outlined,
            title: 'Partager l\'application',
            onTap: () {},
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

  void _showMethodPicker(BuildContext context, StorageService storage) {
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
      builder: (ctx) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 16),
          Text('Méthode de calcul', style: AppTextStyles.heading3()),
          const SizedBox(height: 8),
          ...methods.map((m) => ListTile(
                title: Text(m),
                trailing: storage.calculationMethod == m
                    ? const Icon(Icons.check_rounded, color: AppColors.primary)
                    : null,
                onTap: () {
                  storage.setCalculationMethod(m);
                  Get.back();
                },
              )),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  void _showThemePicker(BuildContext context, StorageService storage) {
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
                  t == 'light' ? Icons.wb_sunny_rounded :
                  t == 'dark' ? Icons.nights_stay_rounded :
                  Icons.settings_suggest_rounded,
                  color: AppColors.primary,
                ),
                title: Text(t == 'light' ? 'Clair' : t == 'dark' ? 'Sombre' : 'Système'),
                trailing: storage.themeMode == t
                    ? const Icon(Icons.check_rounded, color: AppColors.primary)
                    : null,
                onTap: () {
                  storage.setThemeMode(t);
                  Get.back();
                },
              )),
          const SizedBox(height: 16),
        ],
      ),
    );
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
        border: Border.all(color: isDark ? AppColors.dividerDark : AppColors.dividerLight),
      ),
      child: ListTile(
        leading: Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: AppColors.primary, size: 20),
        ),
        title: Text(title, style: AppTextStyles.bodyLarge()),
        subtitle: subtitle != null ? Text(subtitle!, style: AppTextStyles.bodySmall()) : null,
        trailing: trailing ??
            const Icon(Icons.chevron_right_rounded,
                color: AppColors.textSecondaryLight),
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
