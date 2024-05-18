import 'package:password_manager/models/category.dart';
import 'package:password_manager/models/password.dart';

final List<Password> dummyPwds = [
  Password(
    id: 'testId',
    title: 'testTitle',
    username: 'testUsername',
    password: 'testPassword',
    categoryId: 'testCategoryId',
  ),
  Password(
    id: 'testId2',
    title: 'testTitle2',
    username: 'testUsername2',
    password: 'testPassword2',
    categoryId: 'testCategoryId2',
  ),
  Password(
    id: 'testId3',
    title: 'testTitle3',
    username: 'testUsername3',
    password: 'testPassword3',
    categoryId: 'testCategoryId3',
  ),
];

final List<Category> dummyCategories = [
  Category(id: 'testCategoryId', name: 'Test category'),
  Category(id: 'testCategoryId2', name: 'Test category 2'),
  Category(id: 'testCategoryId3', name: 'Test category 3'),
];
