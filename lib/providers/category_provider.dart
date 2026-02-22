import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/category.dart';
import '../data/repositories/category_repository.dart';

final categoryRepositoryProvider = Provider<CategoryRepository>((ref) {
  return CategoryRepository();
});

class CategoriesNotifier extends Notifier<AsyncValue<List<Category>>> {
  @override
  AsyncValue<List<Category>> build() {
    fetchCategories();
    return const AsyncValue.loading();
  }

  Future<void> fetchCategories() async {
    state = const AsyncValue.loading();
    try {
      final repository = ref.read(categoryRepositoryProvider);
      final categories = await repository.getAllCategories();
      state = AsyncValue.data(categories);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<Category?> createCategory(String name) async {
    try {
      final repository = ref.read(categoryRepositoryProvider);
      final existing = await repository.getCategoryByName(name);
      if (existing != null) {
        throw Exception('Category already exists');
      }

      final category = Category(name: name);
      final id = await repository.createCategory(category);
      await fetchCategories();

      return category.copyWith(id: id);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      rethrow;
    }
  }

  Future<void> updateCategory(Category category) async {
    try {
      final repository = ref.read(categoryRepositoryProvider);
      await repository.updateCategory(category);
      await fetchCategories();
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> deleteCategory(int id) async {
    try {
      final repository = ref.read(categoryRepositoryProvider);
      await repository.deleteCategory(id);
      await fetchCategories();
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}

final categoriesProvider = NotifierProvider<CategoriesNotifier, AsyncValue<List<Category>>>(() {
  return CategoriesNotifier();
});
