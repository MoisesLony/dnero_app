import 'dart:typed_data';
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final imageCacheProvider = StateNotifierProvider<ImageCacheNotifier, Map<String, Uint8List>>(
  (ref) => ImageCacheNotifier(),
);

class ImageCacheNotifier extends StateNotifier<Map<String, Uint8List>> {
  ImageCacheNotifier() : super({});

  void cacheImage(String id, String base64String) {
    if (!state.containsKey(id) && base64String.isNotEmpty) {
      try {
        final decodedImage = base64Decode(base64String);
        state = {...state, id: decodedImage};
      } catch (e) {
        print("🚨 Error decoding image for ID: $id");
      }
    }
  }

  Uint8List? getImage(String id) {
    return state[id];
  }
}
