class Password {
  final String title;
  final String username;
  final String password;
  final String categoryId;
  String? id;
  String? email;
  String? note;
  String? iconId;
  List<Field>? fields; // Dynamic fields
  DateTime? createdAt;
  DateTime? updatedAt;

  // Transient fields
  bool selected;

  Password({
    required this.title,
    required this.username,
    required this.password,
    required this.categoryId,
    this.id,
    this.email,
    this.note,
    this.fields,
    this.createdAt,
    this.updatedAt,
    this.iconId,
    this.selected = false,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Password && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  factory Password.fromMap(Map<String, dynamic> json) {
    return Password(
      id: json['id'],
      title: json['title'],
      username: json['username'],
      password: json['password'],
      categoryId: json['categoryId'],
      email: json['email'],
      note: json['note'],
      iconId: json['iconId'],
      fields: json['fields'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'username': username,
      'password': password,
      'categoryId': categoryId,
      'email': email,
      'note': note,
      'iconId': iconId,
      'createdAt': createdAt != null ? createdAt!.toIso8601String() : '',
      'updatedAt': updatedAt != null ? updatedAt!.toIso8601String() : '',
    };
  }

  static List<Map<String, dynamic>> toJsonArray(List<Password>? list) {
    if (list == null) return [];
    return list.map((e) => e.toMap()).toList();
  }
}

class Field {
  final String name;
  final String value;

  const Field({required this.name, required this.value});
}
