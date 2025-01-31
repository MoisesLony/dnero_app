import 'package:dnero_app_prueba/infrastructure/datasources/remote/aut_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dnero_app_prueba/presentation/providers/provider_barril.dart';

/* =======================================================
  User Info Provider: Fetch and cache user information
   ======================================================= */
final userInfoProvider = StateNotifierProvider<UserInfoNotifier, Map<String, dynamic>>(
  (ref) => UserInfoNotifier(ref),
);

class UserInfoNotifier extends StateNotifier<Map<String, dynamic>> {
  final Ref ref;

  UserInfoNotifier(this.ref) : super({});

  /* =======================================================
    Fetch user info and cache profile image
     ======================================================= */
    Future<void> fetchUserInfo(String token) async {
  try {
    final response = await AuthService().fetchUserInfo(token);

    // ✅ Ensure the image updates in cache without removing the existing one
    if (response.containsKey('image') && response['image'] is String) {
      final base64Image = response['image'] as String;
      final imageCache = ref.read(imageCacheProvider.notifier);

      // ✅ Directly update the cache without clearing it first
      imageCache.cacheImage("user_profile", base64Image);

      // ✅ Immediately use the updated cached image
      response['decodedImage'] = imageCache.getImage("user_profile");
    }

    state = response;
  } catch (e) {
    print("🚨 Error fetching user info: $e");
  }
}
}
