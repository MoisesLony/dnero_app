import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';

class SelectedCategoriesNotifier extends StateNotifier<Set<String>> {
  SelectedCategoriesNotifier() : super({});

void toggleCategory(String categoryId) {
  final updatedSet = Set<String>.from(state);

  if (updatedSet.contains(categoryId)) {
    updatedSet.remove(categoryId);
  } else {
    if (updatedSet.length < 5) {
      updatedSet.add(categoryId);
    } else {
      print("⚠️ Máximo de 5 categorías alcanzado");
      return; // Evita actualizar si ya hay 5 categorías seleccionadas
    }
  }

  // ✅ SOLO ACTUALIZA SI EL ESTADO CAMBIA
  if (!setEquals(updatedSet, state)) {
    state = updatedSet;
    print("🔄 Estado actual de categorías seleccionadas: ${state.toList()}"); // <-- IMPRIME AQUÍ
  }
}
}
final selectedCategoriesProvider =
    StateNotifierProvider<SelectedCategoriesNotifier, Set<String>>((ref) => SelectedCategoriesNotifier());
