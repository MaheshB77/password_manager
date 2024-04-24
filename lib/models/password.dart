class Password {
  final String title;
  final String username;
  final String password;
  String? id;
  String? email;
  String? note;
  List<Field>? fields;
  DateTime? createdAt;
  DateTime? updatedAt;

  Password({
    required this.title,
    required this.username,
    required this.password,
    this.id,
    this.email,
    this.note,
    this.fields,
    this.createdAt,
    this.updatedAt,
  });
}

class Field {
  final String name;
  final String value;

  const Field({required this.name, required this.value});
}
