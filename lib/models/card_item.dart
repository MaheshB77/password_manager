import 'package:password_manager/shared/utils/date_util.dart';

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

  // Transient fields
  bool selected;

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
    this.selected = false,
  });

  factory CardItem.fromMap(Map<String, dynamic> json) {
    String issueDateStr = json['issue_date'] as String;
    final issueDate =
        issueDateStr.isEmpty ? null : DateTime.parse(issueDateStr);

    String expiryDateStr = json['expiry_date'] as String;
    final expiryDate =
        expiryDateStr.isEmpty ? null : DateTime.parse(expiryDateStr);

    return CardItem(
      title: json['title'],
      cardCategoryId: json['card_category_id'],
      cardNumber: json['card_number'],
      cardHolderName: json['card_holder_name'],
      id: json['id'],
      pin: json['pin'],
      cvv: json['cvv'],
      issueDate: issueDate,
      expiryDate: expiryDate,
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
      'issue_date': getDateString(issueDate),
      'expiry_date': getDateString(expiryDate),
      'created_at': getDateString(createdAt),
      'updated_at': getDateString(updatedAt),
    };
  }
}
