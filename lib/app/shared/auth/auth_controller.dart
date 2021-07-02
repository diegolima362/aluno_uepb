import 'package:aluno_uepb/app/shared/models/user_model.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';

import 'authenticator/interfaces/authenticator_interface.dart';
import 'repositories/interfaces/auth_repository_interface.dart';

part 'auth_controller.g.dart';

enum AuthStatus { waiting, loggedOn, loggedOut }

@Injectable()
class AuthController = _AuthControllerBase with _$AuthController;

abstract class _AuthControllerBase with Store {
  final IAuthRepository authRepository;
  final IAuthenticator authenticator;

  UserModel? user;

  final status = Observable<AuthStatus>(AuthStatus.waiting);

  _AuthControllerBase(this.authRepository, this.authenticator) {
    authRepository
        .getCurrentUser()
        .then((u) => setUser(u != null ? UserModel.fromMap(u) : null));
  }

  @action
  void setUser(UserModel? value) {
    status.value = AuthStatus.waiting;

    if (value != null) {
      status.value = AuthStatus.loggedOn;
      user = value;
    } else {
      status.value = AuthStatus.loggedOut;
    }
  }

  Future<UserModel?> getUser() async {
    if (user != null) return user;
    final result = await authRepository.getCurrentUser();
    final u = result != null ? UserModel.fromMap(result) : null;
    setUser(u);
    return u;
  }

  Future signInWithIdPassword({
    required String id,
    required String password,
  }) async {
    status.value = AuthStatus.waiting;

    try {
      final result = await authenticator.signIn(id, password);
      if (result != null) {
        await authRepository.storeAuthData(result.toMap());
      }
      setUser(result);
    } catch (e) {
      status.value = AuthStatus.loggedOut;
      rethrow;
    }
  }

  @action
  Future<void> signOut() async {
    try {
      status.value = AuthStatus.waiting;
      await authRepository.clearAuthData();
      setUser(null);
      status.value = AuthStatus.loggedOut;
    } on PlatformException {
      status.value = AuthStatus.loggedOut;
      rethrow;
    }
  }
}
