import 'package:flutter/material.dart';
import 'package:password_manager/screens/card_form/card_form_screen.dart';
import 'package:password_manager/screens/cards_screen/widgets/card_search.dart';
import 'package:password_manager/shared/utils/theme_util.dart';

class CardsScreen extends StatefulWidget {
  const CardsScreen({super.key});

  @override
  State<CardsScreen> createState() => _CardsScreenState();
}

class _CardsScreenState extends State<CardsScreen> {
  final _searchController = TextEditingController();

  void _search(String value) {}

  void _onAdd() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (ctx) => const CardFormScreen(),
      ),
    );
    // _passwordFuture = ref.read(passwordProvider.notifier).getPasswords();
  }

  @override
  Widget build(BuildContext context) {
    String bankCard = ThemeUtil.isDark(context)
        ? 'assets/ext_icons/card_night.png'
        : 'assets/ext_icons/card.png';
    String gymCard = ThemeUtil.isDark(context)
        ? 'assets/ext_icons/gym_card_night.png'
        : 'assets/ext_icons/gym_card.png';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cards'),
      ),
      body: Column(
        children: [
          CardSearch(searchController: _searchController, search: _search),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: ListTile(
              leading: Image.asset(bankCard),
              title: Text(
                'Deutsche Bank',
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                '2347672842342734',
                style: Theme.of(context).textTheme.bodySmall!,
              ),
              onTap: () {},
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: ListTile(
              leading: Image.asset(gymCard),
              title: Text(
                'Rock Fit',
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                '2347672842342734',
                style: Theme.of(context).textTheme.bodySmall!,
              ),
              onTap: () {},
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onAdd,
        child: const Icon(Icons.add),
      ),
    );
  }
}
