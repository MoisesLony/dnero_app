import 'dart:convert';

import 'package:dnero_app_prueba/infrastructure/datasources/remote/aut_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userInfoProvider = StateNotifierProvider<UserInfoNotifier, Map<String, dynamic>>(
  (ref) => UserInfoNotifier(),
);

class UserInfoNotifier extends StateNotifier<Map<String, dynamic>> {
  UserInfoNotifier() : super({});

  Future<void> fetchUserInfo(String token) async {
    try {
      final response = await AuthService().fetchUserInfo(token);
      state = response;
    } catch (e) {
      print("Error fetching user info: $e");
    }
  }

   // New method to fetch user info and decode base64 images
  Future<void> fetchUserInfoWithImages(String token) async {
    try {
      // Fetch the user info
      final response = await AuthService().fetchUserInfo(token);

      // Decode the base64 image if it exists
      if (response.containsKey('image') && response['image'] is String) {
        final base64Image = response['image'] as String;
        final decodedImage = base64Decode(base64Image);
        response['decodedImage'] = decodedImage; // Add the decoded image to the response
      }

      state = response;
    } catch (e) {
      print("Error fetching user info with images: $e");
    }
  }
}
