import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';

/* =======================================================
  Selected Categories Provider: Manage category selection
   ======================================================= */
final selectedCategoriesProvider = StateNotifierProvider<SelectedCategoriesNotifier, Set<String>>(
  (ref) => SelectedCategoriesNotifier(),
);

class SelectedCategoriesNotifier extends StateNotifier<Set<String>> {
  SelectedCategoriesNotifier() : super({});

  /* =======================================================
    Toggle category selection (Max: 5 categories)
     ======================================================= */
  void toggleCategory(String categoryId) {
    final updatedSet = Set<String>.from(state);

    if (updatedSet.contains(categoryId)) {
      updatedSet.remove(categoryId);
    } else {
      if (updatedSet.length < 5) {
        updatedSet.add(categoryId);
      } else {
        return; // Prevent updating if already 5 categories selected
      }
    }

    // ✅ Update only if the state changes
    if (!setEquals(updatedSet, state)) {
      state = updatedSet;
    }
  }
}
