import 'package:flutter/material.dart';

class ThemeUtil {
  static bool isDark(BuildContext context) {
    return MediaQuery.of(context).platformBrightness == Brightness.dark;
  }
}
