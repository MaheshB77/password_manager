import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:password_manager/providers/password/local_password_notifier.dart';
import 'package:password_manager/services/password_service.dart';

import '../../data/dummy_data.dart';
import 'local_password_notifier_test.mocks.dart';

@GenerateMocks([PasswordService])
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final pwds = dummyPwds;
  late MockPasswordService ps;
  late PasswordNotifierLocal notifier;

  setUp(() {
    ps = MockPasswordService();
    notifier = PasswordNotifierLocal();
    notifier.ps = ps;
  });

  group('Test local password notifier', () {
    test('Get passwords', () async {
      // When
      when(ps.getPasswords()).thenAnswer((_) async => pwds);
      await notifier.getPasswords();

      // Then
      expect(notifier.state, pwds);
    });

    test('Delete the single password', () async {
      // Given
      notifier.state = pwds;

      // When
      when(ps.delete(['testId2'])).thenAnswer((_) async => 1);
      await notifier.delete('testId2');

      // Then
      expect(notifier.state.length, 2);
    });

    test('Delete multiple passwords', () async {
      // Given
      notifier.state = pwds;

      // When
      when(ps.delete(['testId3', 'testId2'])).thenAnswer((_) async => 1);
      await notifier.deleteMultiple(['testId3', 'testId2']);

      // Then
      verify(ps.delete(['testId3', 'testId2'])).called(1);
      expect(notifier.state.length, 1);
    });
  });
}
