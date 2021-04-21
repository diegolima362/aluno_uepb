import 'package:aluno_uepb/app/shared/auth/auth_controller.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';

part 'login_controller.g.dart';

@Injectable()
class LoginController = _LoginControllerBase with _$LoginController;

abstract class _LoginControllerBase with Store {
  final FormErrorState error = FormErrorState();

  final AuthController _auth = Modular.get();

  // @observable
  // CustomColor color;

  @observable
  bool loading = false;

  @observable
  String id = '';

  @observable
  String password = '';

  _LoginControllerBase() {
    final auth = Modular.get<AuthController>();

    auth.onAuthStateChanged.listen((e) {
      if (e != null && auth.status == AuthStatus.loggedOn)
        Modular.to.navigate('/home/content');
    });
  }

  @action
  void editId(String value) => id = value;

  @action
  void editPassword(String value) => password = value;

  @computed
  bool get idIdValid => id.isNotEmpty;

  @computed
  bool get isPasswordValid => password.length >= 6;

  @computed
  bool get canSubmit =>
      id.isNotEmpty && password.isNotEmpty && !error.hasErrors && !loading;

  late final List<ReactionDisposer> _disposers;

  void setupValidations() {
    _disposers = [
      reaction((_) => id, validateId),
      reaction((_) => password, validatePassword)
    ];
  }

  @action
  void validatePassword(String value) {
    error.password = value.isEmpty ? 'Senha inválida' : '';
  }

  @action
  void validateId(String value) {
    error.id = value.isEmpty ? 'Matrícula inválida' : '';
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

  void close() {
    print('> LoginController: close login page');
    Modular.to.navigate('/');
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
  String id = '';

  @observable
  String password = '';

  @computed
  bool get hasErrors => id.isNotEmpty || password.isNotEmpty;
}
