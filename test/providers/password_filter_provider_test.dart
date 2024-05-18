import 'package:flutter_test/flutter_test.dart';
import 'package:password_manager/providers/password_filter_provider.dart';

import '../data/dummy_data.dart';

void main() {
  late PasswordFilterNotifier pwFilterNotifier;

  setUp(() {
    pwFilterNotifier = PasswordFilterNotifier([...dummyPwds]);
  });

  tearDown(() {
    pwFilterNotifier.clearSelected();
  });

  group('Test password search', () {
    test('Test search with known title', () {
      pwFilterNotifier.search('2');
      expect(pwFilterNotifier.state.length, 1);
    });

    test('Test search with empty string', () {
      pwFilterNotifier.search('');
      expect(pwFilterNotifier.state.length, dummyPwds.length);
    });

    test('Test search with unknown string', () {
      pwFilterNotifier.search('xyz');
      expect(pwFilterNotifier.state.length, 0);
    });
  });

  group('Test categories filter', () {
    test('Should filter passwords with single known category', () {
      pwFilterNotifier.withCategories([dummyCategories[0]]);
      expect(pwFilterNotifier.state.length, 1);
    });

    test('Should filter passwords with multiple known categories', () {
      pwFilterNotifier.withCategories([
        dummyCategories[0],
        dummyCategories[1],
      ]);
      expect(pwFilterNotifier.state.length, 2);
    });

    test('Should keep all passwords if empty filter provided', () {
      pwFilterNotifier.withCategories([]);
      expect(pwFilterNotifier.state.length, 3);
    });
  });

  group('Test password selection', () {
    test('Should select the given password', () {
      pwFilterNotifier.setSelected('testId3');
      var afterSelection = pwFilterNotifier.state.where((pwd) => pwd.selected);
      expect(afterSelection.length, 1);
    });

    test('Should select/deselect the given password', () {
      pwFilterNotifier.setSelected('testId3');

      pwFilterNotifier.setSelected('testId3');
      final afterSelection = pwFilterNotifier.state.where((pwd) => pwd.selected);
      expect(afterSelection.length, 0);
    });

    test('Should clear all selected passwords', () {
      pwFilterNotifier.setSelected('testId3');
      pwFilterNotifier.setSelected('testId2');

      pwFilterNotifier.clearSelected();
      final afterClearing = pwFilterNotifier.state.where((pwd) => pwd.selected);
      expect(afterClearing.length, 0);
    });

  });
}
