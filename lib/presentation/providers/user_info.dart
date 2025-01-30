import 'dart:convert';
import 'package:dnero_app_prueba/infrastructure/datasources/remote/aut_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dnero_app_prueba/presentation/image/image_cache_provider.dart';

final userInfoProvider = StateNotifierProvider<UserInfoNotifier, Map<String, dynamic>>(
  (ref) => UserInfoNotifier(ref),
);

class UserInfoNotifier extends StateNotifier<Map<String, dynamic>> {
  final Ref ref;

  UserInfoNotifier(this.ref) : super({});

  Future<void> fetchUserInfo(String token) async {
    try {
      final response = await AuthService().fetchUserInfo(token);

      // Check if an image exists in the response
      if (response.containsKey('image') && response['image'] is String) {
        final base64Image = response['image'] as String;
        final imageCache = ref.read(imageCacheProvider.notifier);

        // Check if the image is already cached
        if (imageCache.getImage("user_profile") == null) {
          imageCache.cacheImage("user_profile", base64Image);
        }

        // Attach the cached image to the user info state
        response['decodedImage'] = imageCache.getImage("user_profile");
      }

      state = response;
    } catch (e) {
      print("🚨 Error fetching user info with images: $e");
    }
  }
}
