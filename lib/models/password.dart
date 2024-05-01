class Password {
  final String title;
  final String username;
  final String password;
  final String categoryId;
  String? id;
  String? email;
  String? note;
  List<Field>? fields;
  DateTime? createdAt;
  DateTime? updatedAt;
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
    this.selected = false,
  });
}

class Field {
  final String name;
  final String value;

  const Field({required this.name, required this.value});
}
