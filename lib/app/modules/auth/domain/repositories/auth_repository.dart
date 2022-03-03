import '../types/types.dart';

abstract class IAuthRepository {
  Future<EitherLoggedInfo> signIn(String register, String password);

  Future<EitherLoggedInfo> loggedUser();

  Future<EitherLoggedInfo> logout();

  Future<EitherSession> signedSession(String credentials);
}
