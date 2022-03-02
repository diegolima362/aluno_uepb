import 'package:aluno_uepb/app/core/external/drivers/session.dart';

import '../../domain/errors/errors.dart';
import '../../infra/datasources/auth_datasource.dart';
import '../../infra/models/user_model.dart';
import 'adapters/drift/drift_database.dart';
import 'adapters/drift/mappers.dart';
import 'utils/encoders.dart' as encoders;

class AuthDatasource implements IAuthDatasource {
  final Session client;
  final AuthDatabase db;
  UserModel? _user;

  AuthDatasource(this.client, this.db);

  @override
  Future<UserModel?> get currentUser async {
    if (_user != null) return _user;

    try {
      final result = await db.currentUser;
      if (result != null) {
        _user = userFromTable(result);
      } else {
        _user = null;
      }

      return _user;
    } catch (e) {
      throw ErrorGetLoggedUser(
        message: 'Erro ao obter usuário: ' + e.toString(),
      );
    }
  }

  @override
  Future<UserModel> signIn(String register, String password) async {
    try {
      _user = UserModel(
        id: register,
        credentials: encoders.encodeCredentials(register, password),
      );

      await db.saveUser(userToTable(_user!));

      return _user!;
    } on AuthFailure catch (e) {
      throw ErrorLoginEmail(message: 'Erro ao logar com email: ' + e.message);
    } catch (e) {
      throw ErrorLoginEmail(
        message: 'Erro ao logar com email: ' + e.toString(),
      );
    }
  }

  @override
  Future<void> logout() async {
    try {
      await db.clearDatabase();
    } catch (e) {
      throw ErrorLogout(message: 'Erro ao fazer logout: ' + e.toString());
    } finally {
      _user = null;
    }
  }
}
