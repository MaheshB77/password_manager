import 'package:password_manager/models/password.dart';
import 'package:password_manager/services/database_service.dart';
import 'package:sqflite/sqflite.dart';

class PasswordService {
  Future<List<Password>> getPasswords() async {
    Database db = await DatabaseService.instance.db;
    var rows = await db.query('passwords', orderBy: 'title');
    return rows.isEmpty ? rows.map((e) => Password.fromMap(e)).toList() : [];
  }
}
