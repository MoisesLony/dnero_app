



import 'package:dnero_app_prueba/domain/repositories/auth_repository.dart';

class VerifyPhoneUsecase {

  final AuthRepository repository;

  VerifyPhoneUsecase(this.repository);

  Future<void> execute(String phone) async{
    return await repository.verifyPhone(phone);
  }
}