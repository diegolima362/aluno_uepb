import 'package:aluno_uepb/app/shared/models/user_model.dart';
import 'package:aluno_uepb/app/shared/repositories/scraper/session.dart';
import 'package:aluno_uepb/app/utils/connection_state.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:hive/hive.dart';

import 'interfaces/auth_repository_interface.dart';

@Injectable()
class AuthRepository implements IAuthRepository {
  AuthRepository() {
    _box = Hive.box(LOGIN_BOX);

    Future.sync(_localLogin);
  }

  Future _localLogin() async {
    if (_box.isEmpty) {
      _user = null;
      await _box.put('user', {
        'logged': false,
        'accessed': DateTime.now().microsecondsSinceEpoch.toString(),
      }).then((value) {
        print('> AuthRepository: login empty');
      });
    } else {
      final data = _box.get('user', defaultValue: null);
      print('> AuthRepository: data = ');
      print(data);

      if (data['logged'] ?? false == true) {
        final map = {
          'id': data['id'],
          'password': data['password'],
          'logged': data['logged'],
        };

        _user = UserModel.fromMap(map);

        await _box.delete('user');

        await _box.put('user', {
          'id': map['id'],
          'password': map['password'],
          'logged': true,
          'accessed': DateTime.now().microsecondsSinceEpoch.toString(),
        }).then((value) {
          print('> AuthRepository: login updated');
        });

        _box.get('user', defaultValue: null);
      } else {
        _user = null;
      }
    }
  }

  Box _box;
  static const LOGIN_BOX = 'login';

  UserModel _user;

  @override
  UserModel get currentUser {
    if (_user == null) {
      final map = _box.get('user');
      if (map == null) return null;
      _user = UserModel.fromMap({
        'id': map['id'],
        'password': map['password'],
        'logged': map['logged'],
        'accessed': map['accessed'],
      });
    }

    return _user;
  }

  @override
  Stream<UserModel> get onAuthStateChanged =>
      _box.watch(key: 'user').map((e) => _userFromDatabase(e.value));

  @override
  Future<UserModel> signInWithIdPassword(String id, String password) async {
    try {
      if (!await CheckConnection.checkConnection()) {
        throw PlatformException(
            message: 'Sem conexão com a internet', code: 'error_connection');
      }
    } catch (e) {
      rethrow;
    }

    final session = Session();

    final String loginURL =
        "https://academico.uepb.edu.br/ca/index.php/usuario/autenticar";

    Map<String, String> formData = {
      'nome_usuario': id,
      'senha_usuario': password
    };

    try {
      await session.post(loginURL, formData);
    } catch (e) {
      rethrow;
    }

    // final service = Analytics.instance;
    // await service.onLogin();

    final map = {
      'id': id,
      'password': password,
      'logged': true,
    };

    final user = UserModel.fromMap(map);

    await _box.put('user', {
      'id': id,
      'password': password,
      'logged': true,
      'accessed': DateTime.now().microsecondsSinceEpoch.toString(),
    });

    _box.get('user', defaultValue: null);
    _user = user;

    return user;
  }

  @override
  Future<void> signOut() async {
    final map = {
      'logged': false,
      'accessed': DateTime.now().microsecondsSinceEpoch.toString(),
    };

    final user = UserModel.fromMap(map);

    await _box.delete('user');

    await _box.put('user', {
      'logged': false,
      'accessed': DateTime.now().microsecondsSinceEpoch.toString(),
    });

    _box.get('user', defaultValue: null);
    _user = user;
  }

  UserModel _userFromDatabase(Map user) {
    return user == null
        ? null
        : UserModel.fromMap({
            'id': user['id'],
            'password': user['password'],
            'logged': user['logged'],
          });
  }

  UserModel getCurrentUser() {
    final user = _box.get('user');
    return _userFromDatabase(user);
  }

  @override
  void dispose() {
    print('> AuthRepository: dispose > close database');
    _box.close();
  }
}
