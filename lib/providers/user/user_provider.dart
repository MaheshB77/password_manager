import 'package:password_manager/db/database_service.dart';
import 'package:password_manager/models/user.dart';
import 'package:password_manager/shared/utils/date_util.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sqflite/sqflite.dart';

part 'user_provider.g.dart';

@riverpod
class UserRepo extends _$UserRepo {
  @override
  Future<User> build() async {
    print('Getting user from DB');
    Database db = await DatabaseService.instance.db;
    var rows = await db.query('user');
    List<User> users = rows.map((e) => User.fromMap(e)).toList();
    return users.single;
  }

  Future<void> updateUser(User user) async {
    Database db = await DatabaseService.instance.db;
    user.updatedAt = DateTime.now();
    await db.update('user', {
      'fingerprint': user.fingerprint,
      'theme': user.theme,
      'master_password': user.masterPassword,
      'updatedAt': getDateString(user.updatedAt),
    });

    // Updating the state
    ref.invalidateSelf();
    await future;
  }
}
