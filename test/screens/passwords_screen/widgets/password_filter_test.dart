import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:password_manager/screens/passwords_screen/widgets/password_filter.dart';

import '../../../data/dummy_data.dart';

void main() {
  testWidgets("Should display all given categories", (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PasswordFilter(
            selectedCategories: const [],
            categories: dummyCategories,
            updateSelectedCategories: (cat, sel) {},
          ),
        ),
      ),
    );

    expect(find.text('Choose category'), findsOneWidget);

    for (var cat in dummyCategories) {
      expect(find.text(cat.name), findsOneWidget);
    }
  });
}
