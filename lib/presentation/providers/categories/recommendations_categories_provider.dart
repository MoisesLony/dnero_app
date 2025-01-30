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
    return [];
  }

  final rawRecommendations = await authRepository.getRecommendations(selectedCategories, token);

  if (rawRecommendations.isEmpty) {
    return [];
  }

  /* =======================================================
    Process recommendations: Convert base64 images and handle rating
     ======================================================= */
  final processedRecommendations = rawRecommendations.map((recommendation) {
    // Process image
    if (recommendation['image'] != null && recommendation['image'] is String) {
      try {
        final imageData = base64Decode(recommendation['image']);
        recommendation['decodedImage'] = imageData.isNotEmpty ? imageData : null;
      } catch (e) {
        recommendation['decodedImage'] = null;
      }
    } else {
      recommendation['decodedImage'] = null;
    }

    // Handle rating correctly
    recommendation['rating'] = (recommendation['calification'] as num?)?.toDouble() ?? 5.0;
    return recommendation;
  }).toList();

  return processedRecommendations;
});