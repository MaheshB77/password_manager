class User {
  String? id;
  final String masterPassword;
  DateTime? createdAt;
  DateTime? updatedAt;

  User({
    this.id,
    required this.masterPassword,
    this.createdAt,
    this.updatedAt,
  });

  factory User.fromMap(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      masterPassword: json['master_password'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'master_password': masterPassword,
      'createdAt': createdAt != null ? createdAt!.toIso8601String() : '',
      'updatedAt': updatedAt != null ? updatedAt!.toIso8601String() : '',
    };
  }
}
