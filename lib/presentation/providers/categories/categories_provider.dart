import 'package:dnero_app_prueba/infrastructure/datasources/remote/aut_service.dart';
import 'package:dnero_app_prueba/presentation/providers/provider_barril.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/* =======================================================
  Categories Provider: Fetch and cache category data
   ======================================================= */
final categoriesProvider = StateNotifierProvider<CategoriesNotifier, AsyncValue<List<Map<String, String>>>>(
  (ref) => CategoriesNotifier(ref),
);

class CategoriesNotifier extends StateNotifier<AsyncValue<List<Map<String, String>>>> {
  final Ref ref;
  CategoriesNotifier(this.ref) : super(const AsyncValue.loading());

  /* =======================================================
    Fetch categories from API and cache images
     ======================================================= */
  Future<void> fetchCategories(String token) async {
    try {
      if (state is AsyncData && (state as AsyncData).value.isNotEmpty) {
        return;
      }

      if (token.isEmpty) throw Exception('Invalid or missing token');

      state = const AsyncValue.loading();
      final response = await AuthService().getCategory(token);

      if (response == null || response.isEmpty) {
        throw Exception("No categories found or API error");
      }

      final imageCache = ref.read(imageCacheProvider.notifier);

      final List<Map<String, String>> categories = response.map((category) {
        final id = category["id"].toString();
        final imageBase64 = category["image"].toString();

        // Cache image
        imageCache.cacheImage(id, imageBase64);

        return {
          "id": id,
          "name": category["name"].toString(),
          "image": imageBase64,
        };
      }).toList();

      state = AsyncValue.data(categories);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }
}