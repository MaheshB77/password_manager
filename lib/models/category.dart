class Category {
  final String id;
  final String name;

  Category({required this.id, required this.name});

  factory Category.fromMap(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }

  static List<Map<String, dynamic>> toJsonArray(List<Category>? list) {
    if (list == null) return [];
    return list.map((e) => e.toMap()).toList();
  }
}
