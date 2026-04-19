import 'package:flutter/material.dart';

class AppColors {
  // Primary greens
  static const Color primary = Color(0xFF006B3C);
  static const Color primaryLight = Color(0xFF00A36C);
  static const Color primaryDark = Color(0xFF004D2A);
  static const Color primaryGradientStart = Color(0xFF004D2A);
  static const Color primaryGradientEnd = Color(0xFF00A36C);

  // Gold / accent
  static const Color gold = Color(0xFFD4AF37);
  static const Color goldLight = Color(0xFFF0D060);
  static const Color goldDark = Color(0xFFB8960C);

  // Backgrounds
  static const Color backgroundLight = Color(0xFFF5F5F0);
  static const Color backgroundDark = Color(0xFF0D1F14);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF162B1D);
  static const Color cardLight = Color(0xFFFFFFFF);
  static const Color cardDark = Color(0xFF1E3828);

  // Text
  static const Color textPrimaryLight = Color(0xFF1A1A1A);
  static const Color textSecondaryLight = Color(0xFF6B7280);
  static const Color textPrimaryDark = Color(0xFFF0F0E8);
  static const Color textSecondaryDark = Color(0xFF9CA3AF);

  // Status
  static const Color success = Color(0xFF22C55E);
  static const Color error = Color(0xFFEF4444);
  static const Color warning = Color(0xFFF59E0B);
  static const Color info = Color(0xFF3B82F6);

  // Misc
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color transparent = Colors.transparent;
  static const Color dividerLight = Color(0xFFE5E7EB);
  static const Color dividerDark = Color(0xFF2D4A35);

  // Prayer colors
  static const Color fajrColor = Color(0xFF6366F1);
  static const Color dhuhrColor = Color(0xFFF59E0B);
  static const Color asrColor = Color(0xFF3B82F6);
  static const Color maghribColor = Color(0xFFEF4444);
  static const Color ishaColor = Color(0xFF8B5CF6);
  static const Color sunriseColor = Color(0xFFFF8C00);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryGradientStart, primaryGradientEnd],
  );

  static const LinearGradient darkGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF002D18), Color(0xFF004D2A)],
  );

  static const LinearGradient goldGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [goldDark, goldLight],
  );

  static const LinearGradient splashGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF003A1F), Color(0xFF006B3C), Color(0xFF00A36C)],
  );
}
