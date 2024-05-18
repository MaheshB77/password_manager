import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:password_manager/screens/home_screen/widgets/category_chips.dart';

import '../../../data/dummy_data.dart';

void main() {
  testWidgets("Test category chips", (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CategoryChips(
            categories: dummyCategories,
            updateSelectedCategories: (category, selected) {},
          ),
        ),
      ),
    );
    
    expect(find.byType(FilterChip), findsNWidgets(dummyCategories.length));

    for (var category in dummyCategories) {
      expect(find.text(category.name), findsOneWidget);
    }
  });
}
