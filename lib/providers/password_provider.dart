import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:password_manager/models/password.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PasswordNotifier extends StateNotifier<List<Password>> {
  final supabase = Supabase.instance.client;
  PasswordNotifier() : super([]);

  void getPasswords() async {
    try {
      print('Getting the passwords');

      final response = await supabase.from('password').select('*');
      List<Password> pwds = response
          .map(
            (pwd) => Password(
              title: pwd['title'],
              username: pwd['username'],
              password: pwd['password'],
            ),
          )
          .toList();
      state = [...pwds];
    } catch (error) {
      print('Error while getting the passwords :: $error');
    }
  }

  Future<void> save(Password password) async {
    try {
      print('Adding the password');
      await supabase.from('password').insert([
        {
          'title': password.title,
          'username': password.username,
          'password': password.password,
          'email': password.email,
        }
      ]);
    } catch (error) {
      print('Error while adding the password :: $error');
    }
  }
}

final passwordProvider =
    StateNotifierProvider<PasswordNotifier, List<Password>>((ref) {
  return PasswordNotifier();
});
