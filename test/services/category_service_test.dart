import 'package:flutter_test/flutter_test.dart';
import 'package:password_manager/db/initial_data.dart';
import 'package:password_manager/db/queries.dart';
import 'package:password_manager/services/category_service.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void sqfliteTestInit() {
  // Initialize ffi implementation
  sqfliteFfiInit();
  // Set global factory
  databaseFactory = databaseFactoryFfi;
}

Future main() async {
  sqfliteTestInit();
  test('Should have default categories', () async {
    var db = await openDatabase(inMemoryDatabasePath);
    await db.execute(createCategoriesTable);
    for (var cat in defaultCategories) {
      await db.insert('categories', cat);
    }
    var result = await db.query('categories');
    expect(result.length, 7);
    await db.close();
  });
}