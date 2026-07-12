import 'package:flutter/material.dart';

class AppFonts {
  AppFonts._();

  static const String fontFamilyEn = 'Inter';
  static const String fontFamilyAr = 'Cairo';

  // Font Weights
  static const FontWeight light = FontWeight.w300;
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semiBold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;
}

class AppTextStyles {
  AppTextStyles._();

  // Headings
  static const TextStyle h1 = TextStyle(fontSize: 32, fontWeight: AppFonts.bold);
  static const TextStyle h2 = TextStyle(fontSize: 24, fontWeight: AppFonts.bold);
  static const TextStyle h3 = TextStyle(fontSize: 20, fontWeight: AppFonts.semiBold);
  static const TextStyle h4 = TextStyle(fontSize: 18, fontWeight: AppFonts.semiBold);

  // Body
  static const TextStyle bodyLarge = TextStyle(fontSize: 16, fontWeight: AppFonts.regular);
  static const TextStyle bodyMedium = TextStyle(fontSize: 14, fontWeight: AppFonts.regular);
  static const TextStyle bodySmall = TextStyle(fontSize: 12, fontWeight: AppFonts.regular);

  // Labels
  static const TextStyle labelLarge = TextStyle(fontSize: 14, fontWeight: AppFonts.medium);
  static const TextStyle labelMedium = TextStyle(fontSize: 12, fontWeight: AppFonts.medium);
  static const TextStyle labelSmall = TextStyle(fontSize: 10, fontWeight: AppFonts.medium);
}
