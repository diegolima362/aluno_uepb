import '../../../../core/external/drivers/session.dart';
import '../models/user_model.dart';

abstract class IAuthDatasource {
  Future<UserModel> signIn(String register, String password);

  Future<UserModel?> get currentUser;

  Future<void> logout();

  Future<Session> signedSession(String credentials);
}
