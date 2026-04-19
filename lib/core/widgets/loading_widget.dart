import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class NoorLoadingWidget extends StatelessWidget {
  final Color? color;
  const NoorLoadingWidget({super.key, this.color});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        color: color ?? AppColors.primary,
        strokeWidth: 3,
      ),
    );
  }
}
