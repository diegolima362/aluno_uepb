import 'package:aluno_uepb/app/shared/event_logger/interfaces/event_logger_interface.dart';
import 'package:aluno_uepb/app/shared/models/user_model.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';

import 'repositories/interfaces/auth_repository_interface.dart';

part 'auth_controller.g.dart';

enum AuthStatus { waiting, loggedOn, loggedOut }

@Injectable()
class AuthController = _AuthControllerBase with _$AuthController;

abstract class _AuthControllerBase with Store {
  late final IAuthRepository _authRepository;

  @observable
  AuthStatus status = AuthStatus.waiting;

  @observable
  UserModel? user;

  _AuthControllerBase() {
    _authRepository = Modular.get();

    _authRepository.onAuthStateChanged.listen((u) => setUser(u));

    setUser(_authRepository.currentUser);
  }

  Stream<UserModel?> get onAuthStateChanged =>
      _authRepository.onAuthStateChanged;

  @action
  void setUser(UserModel? value) {
    print('> _AuthControllerBase: set user: $value');

    user = value;
    if (value == null || !value.logged)
      status = AuthStatus.loggedOut;
    else
      status = AuthStatus.loggedOn;
  }

  @action
  void alertHandled() => status = AuthStatus.loggedOut;

  @action
  Future signInWithIdPassword(
      {required String id, required String password}) async {
    status = AuthStatus.waiting;

    try {
      user = await _authRepository.signInWithIdPassword(id, password);

      print('> _AuthControllerBase: returned user: $user');

      status = AuthStatus.loggedOn;
      setUser(user);
      Modular.get<IEventLogger>().logSignIn();
    } on PlatformException {
      status = AuthStatus.loggedOut;
      rethrow;
    }
  }

  @action
  Future<void> signOut() async {
    try {
      status = AuthStatus.waiting;
      await _authRepository.signOut();
      status = AuthStatus.loggedOut;


    } on PlatformException {
      status = AuthStatus.loggedOut;
      rethrow;
    }
  }
}
