import 'package:password_manager/models/category.dart';

class CategoryUtil {
  static Category getById(List<Category> categories, String id) {
    return categories.firstWhere((cat) => cat.id == id);
  }

  static Category getByName(List<Category> categories, String name) {
    return categories.firstWhere(
      (cat) => cat.name.toLowerCase() == name.toLowerCase(),
    );
  }
}
