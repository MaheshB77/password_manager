import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:password_manager/models/password.dart';
import 'package:password_manager/services/password_service.dart';

class PasswordNotifierLocal extends StateNotifier<List<Password>> {
  var ps = PasswordService();

  PasswordNotifierLocal() : super([]);

  Future<List<Password>> getPasswords() async {
    try {
      print('Getting the passwords');
      final sqfResult = await ps.getPasswords();
      state = sqfResult;
      return sqfResult;
    } catch (error) {
      print('Error while getting the passwords :: $error');
    }
    return [];
  }

  Future<void> save(Password password) async {
    print('Adding the password');
    await ps.save(password);
  }

  Future<void> update(Password password) async {
    try {
      print('Updating the password');
      await ps.update(password);
      await getPasswords();
    } catch (error) {
      print('Error while updating the password :: $error');
    }
  }

  Future<void> delete(String id) async {
    try {
      print('Deleting the password');
      await ps.delete([id]);
      state = state.where((pwd) => pwd.id != id).toList();
    } catch (error) {
      print('Error while deleting the password :: $error');
    }
  }

  Future<void> deleteMultiple(List<String> ids) async {
    try {
      print('Deleting the passwords $ids');
      await ps.delete(ids);
      state = state.where((pwd) => !ids.contains(pwd.id)).toList();
    } catch (error) {
      print('Error while deleting the passwords :: $error');
    }
  }

  Future<void> import(List<Password> pwdsToImport) async {
    try {
      print('Importing the passwords');
      final newPwds = pwdsToImport
          .where(
            (pwd) => !state.contains(pwd),
          )
          .toList();
      for (var pwd in newPwds) {
        await save(pwd);
      }

      // Refreshing after import
      // TODO: This can be improved
      await getPasswords();
    } catch (error) {
      print('Error while importing the passwords :: $error');
    }
  }
}
