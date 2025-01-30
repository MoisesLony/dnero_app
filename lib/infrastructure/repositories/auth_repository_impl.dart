
import 'dart:io';

import 'package:dnero_app_prueba/domain/repositories/auth_repository.dart';
import 'package:dnero_app_prueba/infrastructure/datasources/remote/aut_service.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthService authService;

  AuthRepositoryImpl(this.authService);

  @override
  Future<void> verifyPhone(String phone) async{
    await authService.verifyPhone(phone);
  }

  @override
  Future<String> verifyOtp(String phone, String otp) async{
    return await authService.verifyOtp(phone, otp);
  }
  
@override
Future<void> updateUser({
  required String firstName,
  required String lastName,
  String? email,
  File? image,
  required String token,
}) async {
  await authService.updateUser(
    firstName: firstName,
    lastName: lastName,
    email: email,
    image: image,
    token: token,
  );
}

  @override
  Future<Map<String, dynamic>> fetchUserInfo(String token) async {
    try{
      return await authService.fetchUserInfo(token);
    } catch (e){
      throw Exception('Error fetching categories: $e');
    }
  }
  
  @override
  Future<List<Map<String, dynamic>>> getCategory(String token) async {
  try {
    return await authService.getCategory(token);
  } catch (e, stackTrace) {
    print("❌ Error fetching recommendations: $e");
    print("📌 Stack Trace: $stackTrace"); // Useful for debugging

    throw Exception('Error fetching recommendations: $e');
  }
}

  @override
   Future<List<Map<String, dynamic>>> getRecommendations(List<String> categoryIds, String token) async {
    print("📤 Sending API request for recommendations with categories: $categoryIds");

    final response = await authService.getRecommendations(categoryIds, token);

    print("📥 Received API response: $response");

    return response;
  }
}
  
