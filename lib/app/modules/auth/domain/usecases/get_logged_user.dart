import '../repositories/auth_repository.dart';
import '../types/types.dart';

abstract class IGetLoggedUser {
  Future<EitherLoggedInfo> call();
}

class GetLoggedUser implements IGetLoggedUser {
  final IAuthRepository repository;

  GetLoggedUser(this.repository);

  @override
  Future<EitherLoggedInfo> call() async {
    return await repository.loggedUser();
  }
}
