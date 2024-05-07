import 'package:sqflite/sqflite.dart';

class LocalAuthService {

  Future<Database> _getConnection() async {
    return await openDatabase('password_manager.db');
  }
}