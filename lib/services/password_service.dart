import 'package:password_manager/models/password.dart';
import 'package:password_manager/services/database_service.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

class PasswordService {
  final uuid = const Uuid();

  Future<List<Password>> getPasswords() async {
    Database db = await DatabaseService.instance.db;
    var rows = await db.query('passwords', orderBy: 'title');
    print('Rows : $rows');
    return rows.isNotEmpty ? rows.map((e) => Password.fromMap(e)).toList() : [];
  }

  Future<int> save(Password pwd) async {
    Database db = await DatabaseService.instance.db;
    pwd.id = uuid.v4();
    pwd.createdAt = DateTime.now();
    pwd.updatedAt = DateTime.now();
    return await db.insert(
      'passwords',
      pwd.toMap(),
    );
  }

  Future<int> update(Password pwd) async {
    Database db = await DatabaseService.instance.db;
    pwd.updatedAt = DateTime.now();
    return await db.update(
      'passwords',
      {
        'title': pwd.title,
        'username': pwd.username,
        'password': pwd.password,
        'email': pwd.email,
        'categoryId': pwd.categoryId,
        'iconId': pwd.iconId,
      },
      where: 'id = ?',
      whereArgs: [pwd.id],
    );
  }

  Future<int> delete(List<String> ids) async {
    Database db = await DatabaseService.instance.db;
    var placeholders = ids.map((e) => '?').join(',');
    var condition = 'id IN ($placeholders)';
    return await db.delete(
      'passwords',
      where: condition,
      whereArgs: ids,
    );
  }
}
