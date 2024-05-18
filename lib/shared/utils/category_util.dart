import 'package:password_manager/models/category.dart';

class CategoryUtil {
  static Category getById(List<Category> categories, String id) {
    return categories.firstWhere(
      (cat) => cat.id == id,
      orElse: () => defaultCategory,
    );
  }

  static Category getByName(List<Category> categories, String name) {
    return categories.firstWhere(
      (cat) => cat.name.toLowerCase() == name.toLowerCase(),
      orElse: () => defaultCategory,
    );
  }

  static Category get defaultCategory {
    return Category(
      id: 'fc278f16-d247-45e2-abb1-4f8d733e1249',
      name: 'Other',
    );
  }
}
