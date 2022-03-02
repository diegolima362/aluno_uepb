import 'package:asuka/asuka.dart' as asuka;
import 'package:asuka/snackbars/asuka_snack_bar.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';

import '../../../../../core/presenter/stores/auth_store.dart';
import '../../../domain/entities/login_credential.dart';
import '../../../domain/errors/errors.dart';
import '../../../domain/usecases/usecases.dart';
import '../../utils/loading_indicator.dart';

class LoginStore extends NotifierStore<AuthFailure, LoginCredential> {
  final ISignIn signIn;
  final AuthStore authStore;

  LoginStore(this.signIn, this.authStore)
      : super(LoginCredential.withRegisterAndPassword(
            register: '', password: ''));

  void setRegister(String value) => update(state.copyWith(register: value));

  void setPassword(String value) => update(state.copyWith(password: value));

  void toggleObscure() => update(state.copyWith(obscure: !state.obscure));

  Future<void> enterRegister() async {
    final entry = loadingIndicator;

    asuka.addOverlay(entry);

    var result = await signIn(state);

    entry.remove();

    result.fold((failure) {
      AsukaSnackbar.alert(failure.message).show();
    }, (user) {
      AsukaSnackbar.success('Bem-vindo').show();
      authStore.setUser(user.toNullable());
      Modular.to.navigate('/');
    });
  }
}
