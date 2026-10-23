import 'package:flutter/material.dart';
import 'app_colors.dart';

extension HexColorExtension on String {
  Color toColor([Color fallback = AppColors.black]) {
    try {
      final cleanHex = replaceFirst('#', '').trim();
      final buffer = StringBuffer();
      if (cleanHex.length == 6) {
        buffer.write('ff$cleanHex');
      } else if (cleanHex.length == 8) {
        buffer.write(cleanHex);
      } else if (cleanHex.length == 3) {
        buffer.write('ff');
        for (var char in cleanHex.split('')) {
          buffer.write('$char$char');
        }
      } else {
        return fallback;
      }
      return Color(int.parse(buffer.toString(), radix: 16));
    } catch (_) {
      return fallback;
    }
  }
}
