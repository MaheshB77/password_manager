import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:password_manager/models/category.dart';
import 'package:password_manager/models/password.dart';
import 'package:password_manager/providers/password/password_provider.dart';

class PasswordFilterNotifier extends StateNotifier<List<Password>> {
  List<Password> passwords;
  PasswordFilterNotifier(this.passwords) : super(passwords);

  void search(String searchText) {
    state = passwords
        .where(
          (pwd) => pwd.title.toLowerCase().contains(searchText.toLowerCase()),
        )
        .toList();
  }

  void withCategories(List<Category> categories) {
    if (categories.isEmpty) {
      state = passwords;
      return;
    }
    state = passwords
        .where(
          (pwd) => categories.any((c) => c.id == pwd.categoryId),
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
