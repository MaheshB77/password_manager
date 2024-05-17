import 'package:flutter_test/flutter_test.dart';
import 'package:password_manager/constants/icons.dart';
import 'package:password_manager/utils/icon_util.dart';

void main() {
  final icons = pmIcons;

  group('Test icon utils', () {
    test('Should get icon by id', () {
      final result = IconUtil.getById(
        icons,
        '31eb50d2-4cbf-4fd2-ae1a-c7adaa4ec370',
      );
      expect(result.name, 'Airtel');
    });

    test('Should get default icon if not found by id', () {
      final result = IconUtil.getById(icons, 'xyz');
      expect(result.name, 'Default');
    });

    test('Should get icon by name', () {
      final result = IconUtil.getByName(icons, 'apple');
      expect(result.name, 'Apple');
    });

    test('Should get default icon if not found by name', () {
      final result = IconUtil.getByName(icons, 'xyz');
      expect(result.name, 'Default');
    });
  });
}
