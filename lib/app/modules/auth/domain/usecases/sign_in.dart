import 'package:fpdart/fpdart.dart';

import '../../../../core/domain/services/connectivity_service.dart';
import '../entities/login_credential.dart';
import '../errors/errors.dart';
import '../repositories/auth_repository.dart';
import '../types/types.dart';

abstract class ISignIn {
  Future<EitherLoggedInfo> call(LoginCredential credential);
}

class SignIn implements ISignIn {
  final IAuthRepository repository;
  final IConnectivityService service;

  SignIn(this.repository, this.service);

  @override
  Future<EitherLoggedInfo> call(LoginCredential credential) async {
    var result = await service.isOnline;

    if (!credential.isValidRegister) {
      return Left(ErrorLoginEmail(message: "Matricula inválida"));
    } else if (!credential.isValidPassword) {
      return Left(ErrorLoginEmail(message: "Senha inválida"));
    }

    if (result.isLeft()) {
      return Left(AuthConnectionError(message: 'Erro de conexão'));
    }

    return await repository.signIn(credential.register, credential.password);
  }
}
