import 'dart:convert';
import 'dart:io';

import 'api_service.dart';

class AuthService {
  final ApiService _apiService = ApiService();

  // Method to verify phone number and request an OTP
  Future<void> verifyPhone(String phone) async {
    await _apiService.post('user/verify/phone', {'phone': phone});
  }

  // Method to verify OTP and retrieve JWT token
  Future<String> verifyOtp(String phone, String otp) async {
    final response = await _apiService.post('user/otp/verify', {
      'phone': phone,
      'otp': otp,
    });
    return response['token']; // Return JWT token
  }

  // Method to update user information
  Future<void> updateUser({
    required String firstName,
    required String lastName,
    String? email,
    File? image, // Changed to File to work with file uploads
    required String token,
  }) async {
    final data = {
      'firstName': firstName,
      'lastName': lastName,
      if (email != null) 'email': email,
    };

    if (image != null) {
      // If an image is provided, use `multipart/form-data`
      await _apiService.postMultipart(
        'user/update',
        data,
        fileFieldName: 'image', // Field name expected by the backend
        file: image, // File to upload
        token: token, // Authentication token
      );
    } else {
      // If no image is provided, use a normal POST request
      await _apiService.post(
        'user/update',
        data,
        token: token,
      );
    }
  }

  // Method to get user information
  Future<Map<String, dynamic>> fetchUserInfo(String token) async {
    final response = await _apiService.get('user/info', token: token);
    return response['payload']; // Return user information payload
  }

  Future<List<Map<String, dynamic>>> getCategory(String token) async {
    final response = await _apiService.get('/category/all', token: token);
    print("🛠️ API Raw Response: $response");

    if (response['data'] is! List) {
      throw Exception('Unexpected response format: ${response['data']}');
    }

    return List<Map<String, dynamic>>.from(response['data']);
}

 // Get Recommendations based on selected categories
Future<List<Map<String, dynamic>>> getRecommendations(List<String> categoryIds, String token) async {
  if (categoryIds.isEmpty) {
    print("⚠️ No category IDs provided.");
    return [];
  }

  try {
    print("📤 Sending POST request to /recomendation/getByIds with: $categoryIds");

    final response = await _apiService.post(
      'recomendation/getByIds',
      {'ids': categoryIds},
      token: token,
    );

    print("📥 Raw API Response: $response"); // 🔥 DEBUG: Imprime la respuesta de la API

    if (response.containsKey('data') && response['data'] is List) {
      return List<Map<String, dynamic>>.from(response['data']);
    } else {
      throw Exception('Unexpected response format: ${response['data']}');
    }
  } catch (e) {
    print("❌ Error fetching recommendations: $e");
    return [];
  }
}
}