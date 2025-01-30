import 'dart:io';

/// Interface for handling authentication-related operations.
abstract class AuthRepository {
  /// Verifies the user's phone and requests an OTP.
  Future<void> verifyPhone(String phone);

  /// Verifies the OTP and retrieves a JWT token.
  Future<String> verifyOtp(String phone, String otp);

  /// Updates the user's information.
  Future<void> updateUser({
    required String firstName,
    required String lastName,
    String? email,
    File? image,
    required String token,
  });

  /// Fetches the user's information.
  Future<Map<String, dynamic>> fetchUserInfo(String token);

  /// Fetches all available categories.
  Future<List<Map<String, dynamic>>> getCategory(String token);

  /// Fetches all available recomendations.
  Future<List<Map<String, dynamic>>> getRecommendations(List<String> categoryIds,String token);
}
