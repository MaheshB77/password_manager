
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
          .map((pwd) => Password(
                id: pwd['id'],
                title: pwd['title'],
                username: pwd['username'],
                password: pwd['password'],
                email: pwd['email'],
                updatedAt: DateTime.parse(pwd['updated_at']),
                categoryId: pwd['category_id'],
                iconId: pwd['icon_id'],
              ))
          .toList();
      state = [...pwds];
    } catch (error) {
      print('Error while getting the passwords :: $error');
    }
  }

  Future<void> save(Password password) async {
    print('Adding the password');
    await supabase.from('password').insert([
      {
        'title': password.title,
        'username': password.username,
        'password': password.password,
        'email': password.email,
        'user_id': supabase.auth.currentUser!.id,
        'category_id': password.categoryId,
        'icon_id': password.iconId,
      }
    ]);
  }

  Future<void> update(Password password) async {
    try {
      print('Updating the password');
      await supabase.from('password').update({
        'title': password.title,
        'username': password.username,
        'password': password.password,
        'email': password.email,
        'category_id': password.categoryId,
        'icon_id': password.iconId,
      }).eq('id', password.id!);
    } catch (error) {
      print('Error while updating the password :: $error');
    }
  }

  Future<void> delete(String id) async {
    try {
      print('Deleting the password');
      await supabase.from('password').delete().eq('id', id);
      state = state.where((pwd) => pwd.id != id).toList();
    } catch (error) {
      print('Error while deleting the password :: $error');
    }
  }

  Future<void> deleteMultiple(List<String> ids) async {
    try {
      print('Deleting the passwords $ids');
      await supabase.from('password').delete().inFilter('id', ids);
      state = state.where((pwd) => !ids.contains(pwd.id)).toList();
    } catch (error) {
      print('Error while deleting the passwords :: $error');
    }
  }

  void select(Password pwd, bool selected) {
    state.removeWhere((element) => element.id == pwd.id);
    pwd.selected = selected;
    state = [...state, pwd];
  }
}
