import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:password_manager/models/card_category.dart';
import 'package:password_manager/models/card_item.dart';
import 'package:password_manager/providers/card/card_category_provider.dart';
import 'package:password_manager/providers/card/card_provider.dart';
import 'package:password_manager/screens/cards_screen/cards_screen.dart';
import 'package:password_manager/shared/utils/card_category_util.dart';
import 'package:password_manager/shared/utils/snackbar_util.dart';
import 'package:password_manager/shared/widgets/pm_dropdown_menu.dart';
import 'package:password_manager/shared/widgets/pm_text_field.dart';
import 'package:password_manager/shared/widgets/spinner.dart';

class CardFormScreen extends ConsumerStatefulWidget {
  final CardItem? cardItem;
  const CardFormScreen({super.key, this.cardItem});

  @override
  ConsumerState<CardFormScreen> createState() => _CardFormScreenState();
}

class _CardFormScreenState extends ConsumerState<CardFormScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _newCard = true;
  bool _adding = false;
  String _title = '';
  String _cardNumber = '';
  String _cardHolderName = '';
  String _pin = '';
  String _cvv = '';
  DateTime? _issueDate;
  DateTime? _expiryDate;
  late CardCategory _selectedCategory;

  @override
  void initState() {
    super.initState();
    final categories =
        ref.read(cardCategoryListProvider).value; // TODO: Can be improved
    _selectedCategory = CardCategoryUtil.getByName(
      categories,
      'Credit',
    ); // Default category

    _newCard = widget.cardItem == null;

    if (!_newCard) {
      _selectedCategory = CardCategoryUtil.getById(
        categories!,
        widget.cardItem!.cardCategoryId,
      );
      _title = widget.cardItem!.title;
      _cardHolderName = widget.cardItem!.cardHolderName;
      _cardNumber = widget.cardItem!.cardNumber;
      _pin = widget.cardItem!.pin ?? '';
      _cvv = widget.cardItem!.cvv ?? '';
      _issueDate = widget.cardItem!.issueDate;
      _expiryDate = widget.cardItem!.expiryDate;
    }
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
      setState(() => _adding = true);
      _formKey.currentState!.save();
      final cardItem = CardItem(
        title: _title,
        cardCategoryId: _selectedCategory.id!,
        cardNumber: _cardNumber,
        cardHolderName: _cardHolderName,
        issueDate: _issueDate,
        expiryDate: _expiryDate,
        cvv: _cvv,
        pin: _pin,
      );
      try {
        if (_newCard) {
          await ref.read(cardListProvider.notifier).save(cardItem);
        } else {
          cardItem.id = widget.cardItem!.id;
          await ref.read(cardListProvider.notifier).updateCard(cardItem);
        }
        setState(() => _adding = false);
        if (!mounted) return;
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (ctx) => const CardsScreen()),
          (route) => false,
        );
      } catch (e) {
        setState(() => _adding = false);
        if (!mounted) return;
        String errorMsg = 'Something went wrong!';
        SnackBarUtil.showError(context, errorMsg);
      }
    }
  }

  void _selectIssueDate(BuildContext context) async {
    final selectedDate = await _selectDate(context);
    if (selectedDate == null && _expiryDate != null) return;
    setState(() => _issueDate = selectedDate);
  }

  void _selectExpiryDate(BuildContext context) async {
    final selectedDate = await _selectDate(context);
    if (selectedDate == null && _expiryDate != null) return;
    setState(() => _expiryDate = selectedDate);
  }

  Future<DateTime?> _selectDate(BuildContext context) async {
    return await showDatePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2050),
    );
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
                categories.when(
                  data: (cardCategories) {
                    return PMDropdownMenu<CardCategory>(
                      entries: cardCategories,
                      initialSelection: _selectedCategory,
                      label: 'Card Category',
                      onEntrySelection: (cat) {
                        if (cat != null) {
                          _selectedCategory = cat;
                        }
                      },
                    );
                  },
                  error: (error, stackTrace) => const SizedBox(
                    height: double.infinity,
                    child: Center(
                      child: Text('Something went wrong'),
                    ),
                  ),
                  loading: () => const Spinner(),
                ),
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
                          dense: true,
                          subtitle: _issueDate != null
                              ? Text(_issueDate.toString().substring(0, 10))
                              : null,
                          onTap: () => _selectIssueDate(context),
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
                          dense: true,
                          subtitle: _expiryDate != null
                              ? Text(_expiryDate.toString().substring(0, 10))
                              : null,
                          onTap: () => _selectExpiryDate(context),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 22),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _adding ? null : _onAdd,
                    child: Text(_newCard ? 'Add' : 'Update'),
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
