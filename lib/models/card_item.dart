class CardItem {
  CardCategory cardCategory;
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
    required this.cardCategory,
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
}

class CardCategory {
  String? id;
  String name;
  CardCategory({required this.name, this.id});
}
