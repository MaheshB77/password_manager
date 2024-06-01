class CardCategory {
  String? id;
  String name;
  String icon;
  String darkIcon;

  CardCategory({
    required this.name,
    required this.icon,
    required this.darkIcon,
    this.id,
  });

  factory CardCategory.fromMap(Map<String, dynamic> json) {
    return CardCategory(
      id: json['id'],
      name: json['name'],
      icon: json['icon'],
      darkIcon: json['dark_icon'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
      'dark_icon': darkIcon,
    };
  }

  static List<Map<String, dynamic>> toJsonArray(List<CardCategory>? list) {
    if (list == null) return [];
    return list.map((e) => e.toMap()).toList();
  }
}
