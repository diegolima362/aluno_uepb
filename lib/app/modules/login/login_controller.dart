import 'package:aluno_uepb/app/shared/auth/auth_controller.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';

part 'login_controller.g.dart';

@Injectable()
class LoginController = _LoginControllerBase with _$LoginController;

abstract class _LoginControllerBase with Store {
  _LoginControllerBase() {
    final auth = Modular.get<AuthController>();

    auth.onAuthStateChanged.listen((e) {
      if (e != null && auth.status == AuthStatus.loggedOn)
        Modular.to.pushReplacementNamed('/home');
    });
  }

  final FormErrorState error = FormErrorState();

  AuthController _auth = Modular.get();

  // @observable
  // CustomColor color;

  @observable
  bool loading = false;

  @observable
  String id = '';

  @observable
  String password = '';

  @computed
  bool get idIdValid => id != null && id.isNotEmpty;

  @computed
  bool get isPasswordValid => password != null && password.length >= 6;

  @computed
  bool get canSubmit =>
      id.isNotEmpty && password.isNotEmpty && !error.hasErrors && !loading;

  List<ReactionDisposer> _disposers;

  void setupValidations() {
    _disposers = [
      reaction((_) => id, validateId),
      reaction((_) => password, validatePassword)
    ];
  }

  @action
  void validatePassword(String value) {
    error.password = value == null || value.isEmpty ? 'Senha inválida' : null;
  }

  @action
  void validateId(String value) {
    error.id = value == null || value.isEmpty ? 'Matrícula inválida' : null;
  }

  void dispose() {
    for (final d in _disposers) {
      d();
    }
  }

  void validateAll() {
    validatePassword(password);
    validateId(id);
  }

  Future<void> close() async {
    print('> LoginController: close login page');
    await Modular.to.pushReplacementNamed('/');
  }

  @action
  Future<void> submit() async {
    loading = true;

    try {
      await _auth.signInWithIdPassword(
        id: id.trim(),
        password: password.trim(),
      );

      loading = false;
    } on PlatformException {
      loading = false;
      rethrow;
    } on Exception catch (e) {
      loading = false;
      throw PlatformException(
        code: 'ERROR_SIGN_IN',
        details: e.toString(),
      );
    }
  }

  bool get loggedIn => _auth.status == AuthStatus.loggedOn;

  void alertHandled() => _auth.alertHandled();
}

class FormErrorState = _FormErrorState with _$FormErrorState;

abstract class _FormErrorState with Store {
  @observable
  String id;

  @observable
  String password;

  @computed
  bool get hasErrors => id != null || password != null;
}
