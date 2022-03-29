import 'package:aluno_uepb/app/core/external/drivers/drift_database.dart';
import 'package:aluno_uepb/app/core/external/drivers/session.dart';
import 'package:aluno_uepb/app/core/external/utils/urls.dart';
import 'package:flutter/foundation.dart';

import '../../domain/errors/errors.dart';
import '../../infra/datasources/auth_datasource.dart';
import '../../infra/models/user_model.dart';

import 'adapters/drift/daos/mappers.dart';
import 'utils/encoders.dart' as encoders;

class AuthDatasource implements IAuthDatasource {
  final Session client;
  final AppDriftDatabase db;

  static const Duration _expireTime = Duration(minutes: 5);

  UserModel? _user;

  final _cachedSession = <int, Session>{};

  AuthDatasource(this.client, this.db);

  @override
  Future<UserModel?> get currentUser async {
    if (_user != null) return _user;

    try {
      final result = await db.usersDao.currentUser;
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
      final data = {'nome_usuario': register, 'senha_usuario': password};

      await client.get(loginURL);

      final result = await client.post(loginURL, data);

      if (result.isNone()) {
        throw SignInError(message: 'Cliente ocupado.');
      } else {
        final body = result.toNullable()?.body ?? '';

        if (body.contains(error1) || body.contains(error2)) {
          throw SignInError(message: 'Matrícula ou senha não conferem.');
        }
        if (body.contains(error3)) {
          throw SignInError(message: 'Falha ao conectar com servidor.');
        }

        _cachedSession.clear();
        final now = DateTime.now().millisecondsSinceEpoch;
        _cachedSession[now] = client;

        _user = UserModel(
          id: register,
          credentials: encoders.encodeCredentials(register, password),
        );

        await db.usersDao.saveUser(userToTable(_user!));

        return _user!;
      }
    } on AuthFailure catch (e) {
      throw SignInError(message: 'Erro ao logar: ' + e.message);
    } catch (e) {
      throw SignInError(
        message: 'Erro ao logar: ' + e.toString(),
      );
    }
  }

  @override
  Future<Session> signedSession(String credentials) async {
    if (_cachedSession.isNotEmpty) {
      final session = _cachedSession.entries.first;
      final expiration = DateTime.now().add(_expireTime).millisecondsSinceEpoch;

      if (session.key < expiration) {
        return session.value;
      }
    }

    try {
      final options = encoders.decodeCredentials(credentials).split(':');

      final data = {'nome_usuario': options[0], 'senha_usuario': options[1]};

      client.clean();
      await client.get(loginURL);
      final result = await client.post(loginURL, data);

      if (result.isNone()) {
        throw SignInError(message: 'Cliente ocupado');
      } else {
        final body = result.toNullable()?.body ?? '';

        if (body.contains(error1) || body.contains(error2)) {
          throw SignInError(message: 'Erro de credenciais');
        }
        if (body.contains(error3)) {
          throw SignInError(message: 'Falha ao conectar com servidor');
        }

        _cachedSession.clear();
        final now = DateTime.now().millisecondsSinceEpoch;
        _cachedSession[now] = client;

        return client;
      }
    } on AuthFailure catch (e) {
      throw SignInError(message: 'Erro ao logar: ' + e.message);
    } catch (e) {
      debugPrint('> AuthRemoteDatasource: ${e.toString()}');
      throw SignInError(
        message: 'Erro ao entrar: ' + e.toString(),
      );
    }
  }

  @override
  Future<void> logout() async {
    try {
      _user = null;
      _cachedSession.clear();
      await db.usersDao.clearDatabase();
    } catch (e) {
      throw ErrorLogout(message: 'Erro ao fazer logout: ' + e.toString());
    } finally {
      _user = null;
    }
  }
}
