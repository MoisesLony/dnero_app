import 'dart:io';

import 'package:dnero_app_prueba/domain/repositories/auth_repository.dart';
import 'package:dnero_app_prueba/infrastructure/datasources/remote/aut_service.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthService authService;

  AuthRepositoryImpl(this.authService);

  /* =======================================================
    Method to verify phone number and request an OTP
     ======================================================= */
  @override
  Future<void> verifyPhone(String phone) async {
    await authService.verifyPhone(phone);
  }

  /* =======================================================
    Method to verify OTP and retrieve JWT token
     ======================================================= */
  @override
  Future<String> verifyOtp(String phone, String otp) async {
    return await authService.verifyOtp(phone, otp);
  }

  /* =======================================================
    Method to update user information
     ======================================================= */
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

  /* =======================================================
    Method to fetch user information
     ======================================================= */
  @override
  Future<Map<String, dynamic>> fetchUserInfo(String token) async {
    try {
      return await authService.fetchUserInfo(token);
    } catch (e) {
      throw Exception('Error fetching user information: $e');
    }
  }

  /* =======================================================
    Method to fetch categories
     ======================================================= */
  @override
  Future<List<Map<String, dynamic>>> getCategory(String token) async {
    try {
      return await authService.getCategory(token);
    } catch (e) {
      throw Exception('Error fetching categories: $e');
    }
  }

  /* =======================================================
    Method to fetch recommendations based on selected categories
     ======================================================= */
  @override
  Future<List<Map<String, dynamic>>> getRecommendations(List<String> categoryIds, String token) async {
    return await authService.getRecommendations(categoryIds, token);
  }
}