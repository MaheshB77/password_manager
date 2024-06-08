import 'package:password_manager/db/database_service.dart';
import 'package:password_manager/models/user.dart';
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
}
