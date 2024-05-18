import 'package:flutter_test/flutter_test.dart';
import 'package:password_manager/models/category.dart';
import 'package:password_manager/shared/utils/category_util.dart';

void main() {
  group('Category utils tests', () {
    List<Category> categories = [
      Category(id: 'fc278f16-d247-45e2-abb1-4f8d733e1249', name: 'Other'),
      Category(id: '11b5a726-3dd3-45cf-b07e-8be7865b49ef', name: 'Personal'),
      Category(id: '2472fde2-0b3e-4ccd-b4c4-4a2d51f8bfff', name: 'Work'),
    ];
    test('Should return category by id', () {
      final result = CategoryUtil.getById(
        categories,
        '11b5a726-3dd3-45cf-b07e-8be7865b49ef',
      );
      expect(result.name, 'Personal');
    });

    test('Should return default category if no match found with id', () {
      final result = CategoryUtil.getById([], 'xyz');
      expect(result.name, 'Other');
    });

    test('Should get category by name', () {
      final result = CategoryUtil.getByName(categories, 'work');
      expect(result.name, 'Work');
    });

    test('Should return default category if no match found with name', () {
      final result = CategoryUtil.getByName(categories, 'sports');
      expect(result.name, 'Other');
    });

  });
}
