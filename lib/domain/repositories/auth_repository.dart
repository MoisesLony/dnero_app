import 'dart:io';

abstract class AuthRepository {
  Future<void> verifyPhone(String phone);
  Future<String> verifyOtp(String phone, String otp);
  Future<void> updateUser({
    required String firstName,
    required String lastName,
    String? email,
    File? image,
    required String token,
  });
  
}