import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:password_manager/models/card_category.dart';
import 'package:password_manager/providers/card/card_category_provider.dart';
import 'package:password_manager/shared/widgets/pm_dropdown_menu.dart';
import 'package:password_manager/shared/widgets/pm_text_field.dart';
import 'package:password_manager/shared/widgets/spinner.dart';

class CardFormScreen extends ConsumerStatefulWidget {
  const CardFormScreen({super.key});

  @override
  ConsumerState<CardFormScreen> createState() => _CardFormScreenState();
}

class _CardFormScreenState extends ConsumerState<CardFormScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _new = false;
  bool _adding = false;
  String _title = '';
  String _cardNumber = '';
  String _cardHolderName = '';
  String _pin = '';
  String _cvv = '';
  CardCategory? _selectedCategory;

  @override
  void initState() {
    super.initState();
  }

  String? _fieldValidator(String? value, int min, int max, String field) {
    if (value == null ||
        value.isEmpty ||
        value.trim().length <= min ||
        value.trim().length > max) {
      return '$field should be between $min to $max characters';
    }
    return null;
  }

  void _onAdd() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
    }
  }

  @override
  Widget build(BuildContext context) {
    final categories = ref.watch(cardCategoryListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Card'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 4),
                PMTextField(
                  initialValue: _title,
                  labelText: 'Title',
                  validator: (value) => _fieldValidator(value, 1, 50, 'Title'),
                  onSaved: (value) => {_title = value!},
                ),
                const SizedBox(height: 12),
                categories.hasValue
                    ? PMDropdownMenu(
                        entries: categories.value!,
                        initialSelection: categories.value![0],
                        label: 'Card Category',
                        onEntrySelection: (cat) {
                          _selectedCategory = cat;
                        },
                      )
                    : const Spinner(),
                const SizedBox(height: 22),
                PMTextField(
                  initialValue: _cardNumber,
                  labelText: 'Card number',
                  keyboardType: TextInputType.number,
                  validator: (value) =>
                      _fieldValidator(value, 1, 50, 'Card number'),
                  onSaved: (value) => {_cardNumber = value!},
                ),
                const SizedBox(height: 12),
                PMTextField(
                  initialValue: _cardHolderName,
                  labelText: 'Card holder name',
                  validator: (value) {
                    return _fieldValidator(value, 1, 50, 'Card holder name');
                  },
                  onSaved: (value) => {_cardHolderName = value!},
                ),
                const SizedBox(height: 12),
                PMTextField(
                  initialValue: _pin,
                  labelText: 'PIN',
                  keyboardType: TextInputType.number,
                  onSaved: (value) => {_pin = value!},
                ),
                const SizedBox(height: 12),
                PMTextField(
                  initialValue: _cvv,
                  labelText: 'CVV',
                  keyboardType: TextInputType.number,
                  onSaved: (value) => {_cvv = value!},
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 0.7),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: ListTile(
                          leading: const Icon(Icons.date_range),
                          title: const Text('Issued Date'),
                          onTap: () {
                            showDatePicker(
                              context: context,
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2050),
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 18),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 0.7),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: ListTile(
                          leading: const Icon(Icons.date_range),
                          title: const Text('Expiry Date'),
                          onTap: () {
                            showDatePicker(
                              context: context,
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2050),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 22),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _onAdd,
                    child: const Text('Add'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// CreditCardWidget(
//         cardNumber: '123467890',
//         bankName: 'Deutsche Bank',
//         expiryDate: 'expiryDate',
//         cardHolderName: 'Mahesh Bansode',
//         isHolderNameVisible: true,
//         cvvCode: 'cvvCode',
//         showBackView: true,
//         cardType: CardType.mastercard,
//         onCreditCardWidgetChange:
//             (brand) {}, // Callback for anytime credit card brand is changed
//       ),
//     );
