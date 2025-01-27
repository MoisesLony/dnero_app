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
  File? image, // Cambiado a File para trabajar con archivos
  required String token,
}) async {
  final data = {
    'firstName': firstName,
    'lastName': lastName,
    if (email != null) 'email': email,
  };

  if (image != null) {
    // Si hay imagen, configuramos `multipart/form-data`
    await _apiService.postMultipart(
      'user/update',
      data,
      fileFieldName: 'image', // Nombre del campo que espera el backend
      file: image, // Archivo a enviar
      token: token, // Token para autenticación
    );
  } else {
    // Si no hay imagen, usamos un POST normal
    await _apiService.post(
      'user/update',
      data,
      token: token,
    );
  }
}



}
