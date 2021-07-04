import 'package:aluno_uepb/app/shared/auth/auth_controller.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';

part 'login_controller.g.dart';

@Injectable()
class LoginController = _LoginControllerBase with _$LoginController;

abstract class _LoginControllerBase with Store {
  final AuthController auth;

  @observable
  bool loading = false;

  @observable
  String id = '';

  @observable
  String? errorMsg;

  @observable
  String password = '';

  @observable
  String? idError;

  @observable
  String? passwordError;

  _LoginControllerBase(this.auth);

  @action
  void editId(String value) => id = value;

  @action
  void editPassword(String value) => password = value;

  void validateAll() {
    if (id.isEmpty) {
      idError = 'Matrícula inválida';
    } else {
      idError = null;
    }

    if (password.isEmpty) {
      passwordError = 'Senha inválida';
    } else {
      passwordError = null;
    }
  }

  @action
  Future<void> submit() async {
    loading = true;

    try {
      await auth.signInWithIdPassword(
        id: id.trim(),
        password: password.trim(),
      );

      loading = false;
    } on PlatformException catch (e) {
      loading = false;
      errorMsg = e.message;
      rethrow;
    } on Exception catch (e) {
      loading = false;

      throw PlatformException(
        code: 'ERROR_SIGN_IN',
        details: e.toString(),
      );
    }
  }
}
