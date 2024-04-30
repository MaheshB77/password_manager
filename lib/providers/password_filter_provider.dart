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
}

final passwordFilterProvider =
    StateNotifierProvider<PasswordFilterNotifier, List<Password>>(
  (ref) {
    final pwds = ref.read(passwordProvider);
    return PasswordFilterNotifier(pwds);
  },
);
