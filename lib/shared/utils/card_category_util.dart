import 'package:password_manager/models/card_category.dart';

class CardCategoryUtil {
  static CardCategory getById(List<CardCategory> categories, String id) {
    return categories.firstWhere(
      (cat) => cat.id == id,
      orElse: () => defaultCategory,
    );
  }

  static CardCategory getByName(List<CardCategory> categories, String name) {
    return categories.firstWhere(
      (cat) => cat.name.toLowerCase() == name.toLowerCase(),
      orElse: () => defaultCategory,
    );
  }

  static CardCategory get defaultCategory {
    return CardCategory(
      id: 'fc4ee338-96ff-44b7-b899-dcf1cee6cc97',
      name: 'Credit',
      icon: 'assets/ext_icons/card.png',
      darkIcon: 'assets/ext_icons/card_night.png',
    );
  }
}
