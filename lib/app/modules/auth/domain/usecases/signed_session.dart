import 'package:fpdart/fpdart.dart';

import '../../../../core/domain/services/connectivity_service.dart';
import '../errors/errors.dart';
import '../repositories/auth_repository.dart';
import '../types/types.dart';

abstract class ISignedSession {
  Future<EitherSession> call();
}

class SignedSession implements ISignedSession {
  final IAuthRepository repository;
  final IConnectivityService service;

  SignedSession(this.repository, this.service);

  @override
  Future<EitherSession> call() async {
    final user = await repository.loggedUser();

    return await user.fold((l) => left(l), (r) async {
      if (r.isNone()) {
        return Left(NotSignedUser(message: 'Sem usuários logados'));
      } else {
        final result = await service.isOnline;

        if (result.isLeft()) {
          return Left(AuthConnectionError(message: 'Erro de conexão'));
        }

        return await repository.signedSession(r.toNullable()!.credentials);
      }
    });
  }
}
