import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:password_manager/screens/settings_screen/settings_screen.dart';

class ThemeNotifier extends StateNotifier<AppTheme> {
  ThemeNotifier() : super(AppTheme.light);

  void setTheme(AppTheme theme) {
    state = theme;
  }
}

final themeProvider = StateNotifierProvider<ThemeNotifier, AppTheme>((ref) {
  return ThemeNotifier();
});
