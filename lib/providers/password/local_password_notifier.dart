import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:password_manager/models/password.dart';
import 'package:password_manager/services/password_service.dart';

class PasswordNotifierLocal extends StateNotifier<List<Password>> {
  final ps = PasswordService();

  PasswordNotifierLocal() : super([]);

  Future<void> getPasswords() async {
    try {
      print('Getting the passwords');
      final sqfResult = await ps.getPasswords();
      state = sqfResult;
    } catch (error) {
      print('Error while getting the passwords :: $error');
    }
  }

  Future<void> save(Password password) async {
    print('Adding the password');
    await ps.save(password);
  }

  Future<void> update(Password password) async {
    try {
      print('Updating the password');
      await ps.update(password);
    } catch (error) {
      print('Error while updating the password :: $error');
    }
  }

  Future<void> delete(String id) async {
    try {
      print('Deleting the password');
      await ps.delete(id);
      state = state.where((pwd) => pwd.id != id).toList();
    } catch (error) {
      print('Error while deleting the password :: $error');
    }
  }

  Future<void> deleteMultiple(List<String> ids) async {
    try {
      print('Deleting the passwords $ids');
      // await supabase.from('password').delete().inFilter('id', ids);
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
