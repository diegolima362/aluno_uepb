import 'package:aluno_uepb/app/shared/models/models.dart';
import 'package:aluno_uepb/app/shared/models/user_model.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:hive/hive.dart';

import 'interfaces/auth_repository_interface.dart';

@Injectable()
class AuthRepository implements IAuthRepository {
  AuthRepository() {
    _box = Hive.box(LOGIN_BOX);

    _localLogin();
  }

  Future _localLogin() async {
    if (_box.isEmpty) {
      print('> box isEmpty');
      _user = null;
    } else {
      print('> box not Empty');
      final data = _box.get('user', defaultValue: null);

      Map<String, String> map = {
        'id': data['id'],
        'password': data['password'],
      };

      _user = UserModel.fromMap(map);

      await _box.delete('user');

      await _box.put('user', {
        'id': map['id'],
        'password': map['password'],
        'accessed': DateTime.now().microsecondsSinceEpoch.toString(),
      }).then((value) {
        print('> login updated');
      });

      _box.get('user', defaultValue: null);
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
      });
    }
    return _user;
  }

  @override
  Stream<UserModel> get onAuthStateChanged =>
      _box.watch(key: 'user').map((map) => _userFromDatabase(map.value));

  @override
  Future<UserModel> signInWithIdPassword(String id, String password) async {
    // return UserModel(id: 'id', password: 'password');

    // try {
    //   if (!await CheckConnection.checkConnection()) {
    //     throw PlatformException(
    //         message: 'Sem conexão com a internet', code: 'error_connection');
    //   }
    // } catch (e) {
    //   rethrow;
    // }

    // final session = Session();
    //
    // final String loginURL =
    //     "https://academico.uepb.edu.br/ca/index.php/usuario/autenticar";
    //
    // Map<String, String> formData = {
    //   'nome_usuario': id,
    //   'senha_usuario': password
    // };
    //
    // try {
    //   await session.signIn(loginURL, formData);
    // } catch (e) {
    //   rethrow;
    // }

    // final service = Analytics.instance;
    // await service.onLogin();

    Map<String, String> map = {
      'user': id,
      'password': password,
    };
    final user = UserModel.fromMap(map);
    await _box.put('user', {
      'id': id,
      'password': password,
    });

    _box.get('user', defaultValue: null);

    return user;
  }

  @override
  Future<void> signOut() async {
    await _box.clear();
  }

  UserModel _userFromDatabase(Map user) {
    return user == null
        ? null
        : UserModel.fromMap({
            'id': user['id'],
            'password': user['password'],
          });
  }

  Future<UserModel> getCurrentUser() async {
    final user = _box.get('user');
    return _userFromDatabase(user);
  }

  @override
  void dispose() {
    print('> close box: auth');
    _box.close();
  }
}
