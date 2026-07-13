import 'package:flutter/material.dart';

class AppFonts {
  AppFonts._();

  static const String fontFamilyEn = 'Inter';
  static const String fontFamilyAr = 'IBMPlexSansArabic';
  static const String fontFamilyPrimary = 'IBMPlexSansArabic';

  // Font Weights
  static const FontWeight light = FontWeight.w300;
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semiBold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;
}

class AppTextStyles {
  AppTextStyles._();

  // Headings tuned for IBM Plex Sans Arabic geometric proportions
  static const TextStyle h1 = TextStyle(
    fontFamily: AppFonts.fontFamilyPrimary,
    fontSize: 26,
    fontWeight: AppFonts.bold,
    height: 1.3,
  );
  static const TextStyle h2 = TextStyle(
    fontFamily: AppFonts.fontFamilyPrimary,
    fontSize: 21,
    fontWeight: AppFonts.bold,
    height: 1.35,
  );
  static const TextStyle h3 = TextStyle(
    fontFamily: AppFonts.fontFamilyPrimary,
    fontSize: 18,
    fontWeight: AppFonts.semiBold,
    height: 1.4,
  );
  static const TextStyle h4 = TextStyle(
    fontFamily: AppFonts.fontFamilyPrimary,
    fontSize: 16,
    fontWeight: AppFonts.semiBold,
    height: 1.4,
  );

  // Body text tuned for readability without bulkiness
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: AppFonts.fontFamilyPrimary,
    fontSize: 15,
    fontWeight: AppFonts.regular,
    height: 1.5,
  );
  static const TextStyle bodyMedium = TextStyle(
    fontFamily: AppFonts.fontFamilyPrimary,
    fontSize: 13.5,
    fontWeight: AppFonts.regular,
    height: 1.5,
  );
  static const TextStyle bodySmall = TextStyle(
    fontFamily: AppFonts.fontFamilyPrimary,
    fontSize: 12,
    fontWeight: AppFonts.regular,
    height: 1.4,
  );

  // Labels and Button texts
  static const TextStyle labelLarge = TextStyle(
    fontFamily: AppFonts.fontFamilyPrimary,
    fontSize: 14,
    fontWeight: AppFonts.semiBold,
    height: 1.3,
  );
  static const TextStyle labelMedium = TextStyle(
    fontFamily: AppFonts.fontFamilyPrimary,
    fontSize: 12,
    fontWeight: AppFonts.medium,
    height: 1.3,
  );
  static const TextStyle labelSmall = TextStyle(
    fontFamily: AppFonts.fontFamilyPrimary,
    fontSize: 10.5,
    fontWeight: AppFonts.medium,
    height: 1.3,
  );
}
