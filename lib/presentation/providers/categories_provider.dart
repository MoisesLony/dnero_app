import 'package:dnero_app_prueba/infrastructure/datasources/remote/aut_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Provider for categories
final categoriesProvider = StateNotifierProvider<CategoriesNotifier, AsyncValue<List<Map<String, String>>>>(
  (ref) => CategoriesNotifier(),
);

class CategoriesNotifier extends StateNotifier<AsyncValue<List<Map<String, String>>>> {
  CategoriesNotifier() : super(const AsyncValue.loading());

  // Method to fetch categories
  Future<void> fetchCategories(String token) async {
      try {
      // Validate token
      if (token.isEmpty || token == null) {
        throw Exception('Invalid or missing token');
      }

      // Show loading state
      state = const AsyncValue.loading();

      // API call to fetch categories
      final response = await AuthService().getCategory(token);

      // Decode base64 images in the category data
      final categories = response.map((category) {
        return {
          "id": category["id"].toString(),
          "name": category["name"].toString(),
          "image": category["image"].toString(),
        };
      }).toList();

      // Validate categories
      if (categories.isEmpty) {
        throw Exception('No categories found');
      }

      // Update state with fetched categories
      state = AsyncValue.data(categories);

    } catch (e, stackTrace) {
      // Handle errors and update state
      state = AsyncValue.error(e, stackTrace);
      print("Error fetching categories: $e");
    }
  }
}
