class User {
  String? id;
  String masterPassword;
  int fingerprint;
  String theme;
  String passwordHint;
  DateTime? createdAt;
  DateTime? updatedAt;

  User({
    this.id,
    required this.masterPassword,
    required this.passwordHint,
    this.theme = 'system',
    this.fingerprint = 0,
    this.createdAt,
    this.updatedAt,
  });

  factory User.fromMap(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      masterPassword: json['master_password'],
      passwordHint: json['password_hint'] ?? '',
      fingerprint: json['fingerprint'],
      theme: json['theme'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'master_password': masterPassword,
      'password_hint': passwordHint,
      'fingerprint': fingerprint,
      'theme': theme,
      'createdAt': createdAt != null ? createdAt!.toIso8601String() : '',
      'updatedAt': updatedAt != null ? updatedAt!.toIso8601String() : '',
    };
  }
}
