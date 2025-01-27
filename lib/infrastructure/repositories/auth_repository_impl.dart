
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
}

