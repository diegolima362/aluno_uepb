import '../models/user_model.dart';

abstract class IAuthDatasource {
  Future<UserModel> signIn(String register, String password);

  Future<UserModel?> get currentUser;

  Future<void> logout();
}
