import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTextStyles {
  // Arabic fonts
  static TextStyle arabicLarge({Color? color, FontWeight? weight}) =>
      TextStyle(
        fontFamily: 'ScheherazadeNew',
        fontSize: 28,
        fontWeight: weight ?? FontWeight.bold,
        color: color ?? AppColors.textPrimaryLight,
        height: 1.8,
      );

  static TextStyle arabicMedium({Color? color, FontWeight? weight}) =>
      TextStyle(
        fontFamily: 'ScheherazadeNew',
        fontSize: 22,
        fontWeight: weight ?? FontWeight.normal,
        color: color ?? AppColors.textPrimaryLight,
        height: 1.8,
      );

  static TextStyle arabicSmall({Color? color}) => TextStyle(
        fontFamily: 'ScheherazadeNew',
        fontSize: 18,
        fontWeight: FontWeight.normal,
        color: color ?? AppColors.textPrimaryLight,
        height: 1.8,
      );

  static TextStyle quranVerse({Color? color}) => TextStyle(
        fontFamily: 'ScheherazadeNew',
        fontSize: 26,
        fontWeight: FontWeight.normal,
        color: color ?? AppColors.textPrimaryLight,
        height: 2.0,
      );

  // Latin / French fonts
  static TextStyle heading1({Color? color, bool dark = false}) =>
      GoogleFonts.poppins(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: color ??
            (dark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
      );

  static TextStyle heading2({Color? color, bool dark = false}) =>
      GoogleFonts.poppins(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: color ??
            (dark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
      );

  static TextStyle heading3({Color? color, bool dark = false}) =>
      GoogleFonts.poppins(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: color ??
            (dark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
      );

  static TextStyle bodyLarge({Color? color, bool dark = false}) =>
      GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: color ??
            (dark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
      );

  static TextStyle bodyMedium({Color? color, bool dark = false}) =>
      GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: color ??
            (dark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
      );

  static TextStyle bodySmall({Color? color, bool dark = false}) =>
      GoogleFonts.poppins(
        fontSize: 12,
        fontWeight: FontWeight.normal,
        color: color ??
            (dark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
      );

  static TextStyle caption({Color? color}) => GoogleFonts.poppins(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        color: color ?? AppColors.textSecondaryLight,
        letterSpacing: 0.4,
      );

  static TextStyle prayerTime({Color? color}) => GoogleFonts.poppins(
        fontSize: 56,
        fontWeight: FontWeight.bold,
        color: color ?? AppColors.white,
        letterSpacing: -1,
      );

  static TextStyle prayerName({Color? color}) => GoogleFonts.poppins(
        fontSize: 20,
        fontWeight: FontWeight.w500,
        color: color ?? AppColors.white,
      );

  static TextStyle counter({Color? color}) => GoogleFonts.poppins(
        fontSize: 64,
        fontWeight: FontWeight.bold,
        color: color ?? AppColors.textPrimaryLight,
      );

  static TextStyle button({Color? color}) => GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: color ?? AppColors.white,
        letterSpacing: 0.5,
      );
}
