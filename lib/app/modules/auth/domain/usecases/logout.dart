import '../repositories/auth_repository.dart';
import '../types/types.dart';

abstract class ILogout {
  Future<EitherLoggedInfo> call();
}

class Logout implements ILogout {
  final IAuthRepository repository;

  Logout(this.repository);

  @override
  Future<EitherLoggedInfo> call() async {
    return await repository.logout();
  }
}
