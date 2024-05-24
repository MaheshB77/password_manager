import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';

class CardsScreen extends StatefulWidget {
  const CardsScreen({super.key});

  @override
  State<CardsScreen> createState() => _CardsScreenState();
}

class _CardsScreenState extends State<CardsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cards'),
      ),
      body: CreditCardWidget(
        cardNumber: '123467890',
        bankName: 'Deutsche Bank',
        expiryDate: 'expiryDate',
        cardHolderName: 'Mahesh Bansode',
        isHolderNameVisible: true,
        cvvCode: 'cvvCode',
        showBackView: true,
        enableFloatingCard: true,
        cardType: CardType.mastercard,
        onCreditCardWidgetChange:
            (brand) {}, // Callback for anytime credit card brand is changed
      ),
    );
  }
}