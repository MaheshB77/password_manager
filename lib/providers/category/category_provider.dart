import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:password_manager/models/category.dart';
import 'package:password_manager/providers/category/local_supabase_notifier.dart';

final categoryProvider =
    StateNotifierProvider<LocalCategoryNotifier, List<Category>>((ref) {
  return LocalCategoryNotifier();
});
