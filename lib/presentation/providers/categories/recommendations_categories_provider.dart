import 'dart:convert';

import 'package:dnero_app_prueba/infrastructure/datasources/remote/aut_service.dart';
import 'package:dnero_app_prueba/infrastructure/repositories/auth_repository_impl.dart';
import 'package:dnero_app_prueba/presentation/providers/token_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:dnero_app_prueba/presentation/providers/selected_categories_provider.dart';

final recommendationsProvider = FutureProvider.autoDispose<List<Map<String, dynamic>>>((ref) async {
  final authRepository = AuthRepositoryImpl(AuthService());
  final selectedCategories = ref.watch(selectedCategoriesProvider).toList();
  final token = ref.watch(tokenProvider);
  if (selectedCategories.isEmpty || token == null) {
    print("⚠️ No categories selected or token is null.");
    return [];
  }

  print("🚀 Fetching recommendations with categories: $selectedCategories");

  final rawRecommendations = await authRepository.getRecommendations(selectedCategories, token);

  print("📥 API Response BEFORE Processing: $rawRecommendations");

  if (rawRecommendations.isEmpty) {
    print("⚠️ No recommendations received from API.");
    return [];
  }

  // ✅ Convert base64 images to Uint8List and handle `calification`
  final processedRecommendations = rawRecommendations.map((recommendation) {
    // Procesar la imagen
    if (recommendation['image'] != null && recommendation['image'] is String) {
      try {
        final imageData = base64Decode(recommendation['image']);
        recommendation['decodedImage'] = imageData.isNotEmpty ? imageData : null;
      } catch (e) {
        print("❌ Error decoding base64 image for ${recommendation['id']}: $e");
        recommendation['decodedImage'] = null;
      }
    } else {
      recommendation['decodedImage'] = null;
    }

    // ✅ Manejar calificación correctamente
    recommendation['rating'] = (recommendation['calification'] as num?)?.toDouble() ?? 5.0;

    return recommendation;
  }).toList();

  print("✅ Final Processed Recommendations: $processedRecommendations");
  return processedRecommendations;
});
