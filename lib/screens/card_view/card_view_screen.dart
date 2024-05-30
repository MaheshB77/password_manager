import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:password_manager/models/card_item.dart';
import 'package:password_manager/providers/card/card_provider.dart';
import 'package:password_manager/screens/card_view/widgets/card_field_tile.dart';
import 'package:password_manager/screens/cards_screen/cards_screen.dart';
import 'package:password_manager/shared/utils/date_util.dart';
import 'package:password_manager/shared/utils/theme_util.dart';

class CardViewScreen extends ConsumerWidget {
  final CardItem cardItem;
  const CardViewScreen({super.key, required this.cardItem});

  String getFormattedDate(DateTime? date) {
    if (date == null) return '';
    String formattedDate = '${date.month}-${date.year}';
    return formattedDate;
  }

  void _deleteConfirmation(BuildContext context, WidgetRef ref) async {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Deleting'),
          content: const Text('Do you want to delete this card ?'),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => _onDelete(context, ref),
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  void _onDelete(BuildContext context, WidgetRef ref) async {
    // TODO (Improvement) : Add Spinner / Disable 'Yes' button 
    await ref.read(cardListProvider.notifier).delete([cardItem.id!]);
    if (!context.mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (ctx) => const CardsScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final darkTheme = ThemeUtil.isDark(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(cardItem.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _deleteConfirmation(context, ref),
          ),
        ],
      ),
      backgroundColor: darkTheme ? Colors.black : Colors.grey[200],
      body: Column(
        children: [
          CreditCardWidget(
            cardNumber: cardItem.cardNumber,
            bankName: cardItem.title,
            expiryDate: getMMYY(cardItem.expiryDate),
            cardHolderName: cardItem.cardHolderName,
            isHolderNameVisible: true,
            cvvCode: cardItem.cvv ?? '',
            obscureCardCvv: false,
            showBackView: false,
            cardType: CardType.mastercard,
            animationDuration: const Duration(milliseconds: 300),
            onCreditCardWidgetChange:
                (brand) {}, // Callback for anytime credit card brand is changed
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: darkTheme
                    ? const Color.fromARGB(50, 255, 255, 255)
                    : Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListView(
                children: [
                  const SizedBox(height: 12),
                  CardFieldTile(
                    heading: 'Card Title',
                    value: cardItem.title,
                  ),
                  const Divider(thickness: 0.4),
                  CardFieldTile(
                    heading: 'Holder Name',
                    value: cardItem.cardHolderName,
                  ),
                  const Divider(thickness: 0.4),
                  CardFieldTile(
                    heading: 'Card Number',
                    value: cardItem.cardNumber,
                  ),
                  const Divider(thickness: 0.4),
                  cardItem.issueDate != null
                      ? CardFieldTile(
                          heading: 'Issue Date',
                          value: getDDMMYYYY(cardItem.issueDate),
                        )
                      : Container(),
                  cardItem.issueDate != null
                      ? const Divider(thickness: 0.4)
                      : Container(),
                  cardItem.expiryDate != null
                      ? CardFieldTile(
                          heading: 'Expiry Date',
                          value: getDDMMYYYY(cardItem.expiryDate),
                        )
                      : Container(),
                  cardItem.expiryDate != null
                      ? const Divider(thickness: 0.4)
                      : Container(),
                  (cardItem.cvv != null && cardItem.cvv!.isNotEmpty)
                      ? CardFieldTile(
                          heading: 'CVV',
                          value: cardItem.cvv!,
                        )
                      : Container(),
                  (cardItem.cvv != null && cardItem.cvv!.isNotEmpty)
                      ? const Divider(thickness: 0.4)
                      : Container(),
                  (cardItem.pin != null && cardItem.pin!.isNotEmpty)
                      ? CardFieldTile(
                          heading: 'PIN',
                          value: cardItem.pin!,
                        )
                      : Container(),
                  (cardItem.pin != null && cardItem.pin!.isNotEmpty)
                      ? const Divider(thickness: 0.4)
                      : Container(),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
