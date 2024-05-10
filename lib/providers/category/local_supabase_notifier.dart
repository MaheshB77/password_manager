import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:password_manager/models/category.dart';
import 'package:password_manager/services/category_service.dart';

class LocalCategoryNotifier extends StateNotifier<List<Category>> {
  final catService = CategoryService();

  LocalCategoryNotifier() : super([]);

  Future<void> getCategories() async {
    print('Getting all categories');
    final categories = await catService.getCategories();
    state = categories;
  }
}