import 'package:flutter/material.dart';

class ColorHelper {
  static Color parseHexColor(String? hexString, Color fallback) {
    if (hexString == null || hexString.isEmpty) return fallback;
    try {
      final hex = hexString.replaceAll('#', '');
      if (hex.length == 6) return Color(int.parse('0xFF$hex'));
      if (hex.length == 8) return Color(int.parse('0x$hex'));
      return fallback;
    } catch (_) {
      return fallback;
    }
  }
}

