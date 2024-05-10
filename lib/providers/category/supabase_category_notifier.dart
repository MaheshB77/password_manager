import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:password_manager/models/category.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseCategoryNotifier extends StateNotifier<List<Category>> {
  final supabase = Supabase.instance.client;
  SupabaseCategoryNotifier() : super([]);

  Future<void> getCategories() async {
    print('Getting all categories');
    final response = await supabase.from('category').select('*');
    state = response.map(
      (c) => Category(
        id: c['id'],
        name: c['name'],
      ),
    ).toList();
  }
}