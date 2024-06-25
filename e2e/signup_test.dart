import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:password_manager/providers/card/card_provider.dart';
import 'package:password_manager/screens/card_form/card_form_screen.dart';

void main() {
  testWidgets('Test the sign-up flow', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          cardListProvider.overrideWith(CardListMock.new),
        ],
        child: const MaterialApp(
          home: CardFormScreen(),
        ),
      ),
    );

    expect(find.text('Title'), findsOneWidget);
    expect(find.text('Card number'), findsOneWidget);
    expect(find.text('Card holder name'), findsOneWidget);
    expect(find.text('PIN'), findsOneWidget);
    expect(find.text('CVV'), findsOneWidget);
    expect(find.text('Issued Date'), findsOneWidget);
    expect(find.text('Expiry Date'), findsOneWidget);
    expect(find.text('Add'), findsOneWidget);

    // await tester.tap(find.text('Add'));
    // await tester.pump();

    // expect(
    //   find.text('Title should be between 1 to 50 characters'),
    //   findsOneWidget,
    // );
    // expect(
    //   find.text('Card number should be between 1 to 50 characters'),
    //   findsOneWidget,
    // );
    // expect(
    //   find.text('Card holder name should be between 1 to 50 characters'),
    //   findsOneWidget,
    // );

    // await tester.pumpAndSettle();
  });
}
