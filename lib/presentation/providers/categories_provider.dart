import 'package:dnero_app_prueba/infrastructure/datasources/remote/aut_service.dart';
import 'package:dnero_app_prueba/presentation/image/image_cache_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final categoriesProvider = StateNotifierProvider<CategoriesNotifier, AsyncValue<List<Map<String, String>>>>(
  (ref) => CategoriesNotifier(ref),
);

class CategoriesNotifier extends StateNotifier<AsyncValue<List<Map<String, String>>>> {
  final Ref ref;
  CategoriesNotifier(this.ref) : super(const AsyncValue.loading());

  Future<void> fetchCategories(String token) async {
    try {
      if (state is AsyncData && (state as AsyncData).value.isNotEmpty) {
        print("📌 Categorías ya en caché, evitando recarga...");
        return;
      }

      if (token.isEmpty) throw Exception('Invalid or missing token');

      state = const AsyncValue.loading();
      print("🔄 Fetching categories...");

      final response = await AuthService().getCategory(token);

      if (response == null || response.isEmpty) {
        throw Exception("No categories found or API error");
      }

      final imageCache = ref.read(imageCacheProvider.notifier);

      final List<Map<String, String>> categories = response.map((category) {
        final id = category["id"].toString();
        final imageBase64 = category["image"].toString();

        // ✅ Guarda la imagen en caché
        imageCache.cacheImage(id, imageBase64);

        return {
          "id": id,
          "name": category["name"].toString(),
          "image": imageBase64,
        };
      }).toList();

      state = AsyncValue.data(categories);
      print("✅ Categorías cargadas correctamente: ${categories.length}");

    } catch (e, stackTrace) {
      print("🚨 Error fetching categories: $e");
      state = AsyncValue.error(e, stackTrace);
    }
  }
}
