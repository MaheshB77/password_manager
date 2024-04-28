import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:password_manager/models/password.dart';
import 'package:password_manager/providers/password_provider.dart';

class PasswordSelectNotifier extends StateNotifier<List<Password>> {
  List<Password> passwords;
  PasswordSelectNotifier(this.passwords) : super(passwords);

  void setSelected(String id) {
    for (var pwd in passwords) {
      if (pwd.id == id) {
        pwd.selected = !pwd.selected;
      }
    }
    state = [...passwords];
  }
}

final passwordSelectProvider =
    StateNotifierProvider<PasswordSelectNotifier, List<Password>>(
  (ref) {
    final pwds = ref.watch(passwordProvider);
    return PasswordSelectNotifier(pwds);
  },
);