import 'package:aluno_uepb/app/shared/models/models.dart';

abstract class IAuthenticator {
  Future<UserModel?> signIn(String register, String password);
}
