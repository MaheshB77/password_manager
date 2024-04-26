import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:password_manager/models/password.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PasswordNotifier extends StateNotifier<List<Password>> {
  final supabase = Supabase.instance.client;
  PasswordNotifier() : super([]);

  Future<void> getPasswords() async {
    try {
      print('Getting the passwords');

      final response = await supabase.from('password').select('*');
      List<Password> pwds = response
          .map(
            (pwd) => Password(
              id: pwd['id'],
              title: pwd['title'],
              username: pwd['username'],
              password: pwd['password'],
              email: pwd['email'],
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
          'user_id': supabase.auth.currentUser!.id,
        }
      ]);
    } catch (error) {
      print('Error while adding the password :: $error');
    }
  }

  Future<void> update(Password password) async {
    try {
      print('Updating the password');
      await supabase.from('password').update({
        'title': password.title,
        'username': password.username,
        'password': password.password,
        'email': password.email,
      }).eq('id', password.id!);
    } catch (error) {
      print('Error while updating the password :: $error');
    }
  }

  Future<void> delete(String id) async {
    try {
      print('Deleting the password');
      await supabase.from('password').delete().eq('id', id);
    } catch (error) {
      print('Error while deleting the password :: $error');
    }
  }

}

final passwordProvider =
    StateNotifierProvider<PasswordNotifier, List<Password>>((ref) {
  return PasswordNotifier();
});
