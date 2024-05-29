
class CardItem {
  String title;
  String cardCategoryId;
  String cardNumber;
  String cardHolderName;
  DateTime? issueDate;
  DateTime? expiryDate;
  String? id;
  String? pin;
  String? cvv;
  DateTime? createdAt;
  DateTime? updatedAt;

  CardItem({
    required this.title,
    required this.cardCategoryId,
    required this.cardNumber,
    required this.cardHolderName,
    this.issueDate,
    this.expiryDate,
    this.id,
    this.pin,
    this.cvv,
    this.createdAt,
    this.updatedAt,
  });

  factory CardItem.fromMap(Map<String, dynamic> json) {
    return CardItem(
      title: json['title'],
      cardCategoryId: json['card_category_id'],
      cardNumber: json['card_number'],
      cardHolderName: json['card_holder_name'],
      id: json['id'],
      pin: json['pin'],
      cvv: json['cvv'],
      issueDate: DateTime.parse(json['issue_date']),
      expiryDate: DateTime.parse(json['expiry_date']),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'card_category_id': cardCategoryId,
      'card_number': cardNumber,
      'card_holder_name': cardHolderName,
      'id': id,
      'pin': pin,
      'cvv': cvv,
      'issue_date': issueDate != null ? issueDate!.toIso8601String() : '',
      'expiry_date': expiryDate != null ? expiryDate!.toIso8601String() : '',
      'created_at': createdAt != null ? createdAt!.toIso8601String() : '',
      'updated_at': updatedAt != null ? updatedAt!.toIso8601String() : '',
    };
  }
}
