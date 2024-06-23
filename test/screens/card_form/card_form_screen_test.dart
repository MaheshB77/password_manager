import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:password_manager/screens/card_form/card_form_screen.dart';

void main() {
  testWidgets("Card form screen with new card", (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: CardFormScreen(),
        ),
      ),
    );
    expect(find.text('Card'), findsOneWidget);
  });
}
