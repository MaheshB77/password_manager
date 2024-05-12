import 'package:password_manager/db/database_service.dart';
import 'package:password_manager/models/user.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

class UserService {
  final _uuid = const Uuid();

  Future<int> create(User user) async {
    Database db = await DatabaseService.instance.db;
    user.id = _uuid.v4();
    user.createdAt = DateTime.now();
    user.updatedAt = DateTime.now();
    return await db.insert(
      'user',
      user.toMap(),
    );
  }

  Future<bool> isCreated() async {
    Database db = await DatabaseService.instance.db;
    var rows = await db.query('user');
    return rows.isNotEmpty;
  }

  Future<bool> validate(String masterPassword) async {
    Database db = await DatabaseService.instance.db;
    var rows = await db.query('user');
    List<User> users = rows.map((e) => User.fromMap(e)).toList();
    User currentUser = users[0];
    return currentUser.masterPassword == masterPassword;
  }
}
