import 'package:flutter/material.dart';

class AppRadius {
  AppRadius._();

  // Raw values
  static const double sm = 4.0;
  static const double md = 8.0;
  static const double lg = 12.0;
  static const double xl = 16.0;
  static const double xxl = 24.0;
  static const double full = 50.0;

  // BorderRadius shortcuts
  static const BorderRadius circularSm = BorderRadius.all(Radius.circular(sm));
  static const BorderRadius circularMd = BorderRadius.all(Radius.circular(md));
  static const BorderRadius circularLg = BorderRadius.all(Radius.circular(lg));
  static const BorderRadius circularXl = BorderRadius.all(Radius.circular(xl));
  static const BorderRadius circularXxl = BorderRadius.all(Radius.circular(xxl));
  static const BorderRadius circularFull = BorderRadius.all(Radius.circular(full));

  // Bottom sheet top-only radius
  static const BorderRadius topXxl = BorderRadius.vertical(top: Radius.circular(xxl));
}
