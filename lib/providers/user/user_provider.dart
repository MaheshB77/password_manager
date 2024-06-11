import 'package:password_manager/db/database_service.dart';
import 'package:password_manager/models/user.dart';
import 'package:password_manager/shared/utils/date_util.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

part 'user_provider.g.dart';

const _uuid = Uuid();

@riverpod
class UserRepo extends _$UserRepo {
  @override
  Future<User> build() async {
    print('Getting user from DB');
    Database db = await DatabaseService.instance.db;
    var rows = await db.query('user');
    print('rows : $rows');
    List<User> users = rows.map((e) => User.fromMap(e)).toList();
    return users.single;
  }

  Future<void> create(User user) async {
    Database db = await DatabaseService.instance.db;
    user.id = _uuid.v4();
    user.createdAt = DateTime.now();
    user.updatedAt = DateTime.now();
    await db.insert(
      'user',
      user.toMap(),
    );

    // Updating the state
    ref.invalidateSelf();
    await future;
  }

  Future<void> updateUser(User user) async {
    Database db = await DatabaseService.instance.db;
    user.updatedAt = DateTime.now();
    await db.update(
      'user',
      {
        'fingerprint': user.fingerprint,
        'theme': user.theme,
        'master_password': user.masterPassword,
        'password_hint': user.passwordHint,
        'updatedAt': getDateString(user.updatedAt),
      },
    );

    // Updating the state
    ref.invalidateSelf();
    await future;
  }

  Future<bool> isCreated() async {
    Database db = await DatabaseService.instance.db;
    var rows = await db.query('user');
    return rows.isNotEmpty;
  }

  Future<bool> validate(String masterPassword) async {
    final currentUser = state.value!;
    return currentUser.masterPassword == masterPassword;
  }
}
