import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:password_manager/models/password.dart';
import 'package:password_manager/providers/password_provider.dart';

class PasswordFilterNotifier extends StateNotifier<List<Password>> {
  List<Password> passwords;
  PasswordFilterNotifier(this.passwords) : super(passwords);

  void filterPassword(String searchText) {
    state = passwords
        .where(
          (pwd) => pwd.title.toLowerCase().contains(searchText.toLowerCase()),
        )
        .toList();
  }

  void setSelected(String id) {
    for (var pwd in state) {
      if (pwd.id == id) {
        pwd.selected = !pwd.selected;
      }
    }
    state = [...state];
  }

  void clearSelected() {
    for (var pwd in state) {
      pwd.selected = false;
    }
    state = [...state];
  }
}

final passwordFilterProvider =
    StateNotifierProvider<PasswordFilterNotifier, List<Password>>(
  (ref) {
    final pwds = ref.watch(passwordProvider);
    return PasswordFilterNotifier(pwds);
  },
);
