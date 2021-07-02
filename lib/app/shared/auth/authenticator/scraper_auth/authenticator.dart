import 'dart:async';

import 'package:aluno_uepb/app/shared/models/user_model.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import '../interfaces/authenticator_interface.dart';

class ScraperAuthenticator implements IAuthenticator {
  final bool debugMode;

  final mockUser = UserModel(
    id: 'id',
    password: 'password',
    logged: true,
  );

  final String loginURL =
      'https://academico.uepb.edu.br/ca/index.php/usuario/autenticar';

  final _error = PlatformException(
    message: 'Sistema de Controle Acadêmico está indisponivel',
    code: 'error_login',
  );

  final error1 = '<p>Usuário ou senha não conferem.</p>';
  final error2 = '<p>Matrícula ou senha não conferem.</p>';
  final error3 = '<p>Erro inesperado na autenticação do aluno.</p>';

  ScraperAuthenticator({this.debugMode = false});

  Future<UserModel?> signIn(String register, String password) async {
    if (debugMode) return mockUser;

    final form = {'nome_usuario': register, 'senha_usuario': password};
    final response = await http.post(Uri.parse(loginURL), body: form);
    final str = response.body.toString();

    if (str.contains(error3)) {
      throw _error;
    }

    if (str.contains(error1) || str.contains(error2)) {
      throw PlatformException(
          message: 'Matrícula ou senha não conferem', code: 'error_login');
    }

    return UserModel(
      id: register,
      password: password,
      logged: true,
    );
  }
}
