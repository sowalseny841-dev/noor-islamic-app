import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class NoorAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? arabicTitle;
  final List<Widget>? actions;
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final Color? backgroundColor;
  final bool transparent;

  const NoorAppBar({
    super.key,
    required this.title,
    this.arabicTitle,
    this.actions,
    this.showBackButton = true,
    this.onBackPressed,
    this.backgroundColor,
    this.transparent = false,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor:
          transparent ? Colors.transparent : (backgroundColor ?? AppColors.primary),
      elevation: transparent ? 0 : 0,
      leading: showBackButton
          ? IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded,
                  color: AppColors.white, size: 20),
              onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
            )
          : null,
      title: Column(
        children: [
          Text(
            title,
            style: AppTextStyles.heading3(color: AppColors.white),
          ),
          if (arabicTitle != null)
            Text(
              arabicTitle!,
              style: AppTextStyles.arabicSmall(color: AppColors.gold),
            ),
        ],
      ),
      centerTitle: true,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
