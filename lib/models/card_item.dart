class CardItem {
  String cardCategoryId;
  String cardNumber;
  String cardHolderName;
  DateTime issueDate;
  DateTime expiryDate;
  String? id;
  String? pin;
  String? cvv;
  DateTime? createdAt;
  DateTime? updatedAt;

  CardItem({
    required this.cardCategoryId,
    required this.cardNumber,
    required this.cardHolderName,
    required this.issueDate,
    required this.expiryDate,
    this.id,
    this.pin,
    this.cvv,
    this.createdAt,
    this.updatedAt,
  });

  factory CardItem.fromMap(Map<String, dynamic> json) {
    return CardItem(
      cardCategoryId: json['card_category_id'],
      cardNumber: json['card_number'],
      cardHolderName: json['card_holder_name'],
      issueDate: json['issue_date'],
      expiryDate: json['expiry_date'],
      id: json['id'],
      pin: json['pin'],
      cvv: json['cvv'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'card_category_id': cardCategoryId,
      'card_number': cardNumber,
      'card_holder_name': cardHolderName,
      'issue_date': issueDate,
      'expiry_date': expiryDate,
      'id': id,
      'pin': pin,
      'cvv': cvv,
      'created_at': createdAt != null ? createdAt!.toIso8601String() : '',
      'updated_at': updatedAt != null ? updatedAt!.toIso8601String() : '',
    };
  }
}

class CardCategory {
  String? id;
  String name;
  String icon;
  CardCategory({
    required this.name,
    required this.icon,
    this.id,
  });

  factory CardCategory.from(Map<String, dynamic> json) {
    return CardCategory(
      id: json['id'],
      name: json['name'],
      icon: json['icon'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
    };
  }
}
