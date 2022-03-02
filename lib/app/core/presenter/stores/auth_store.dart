import 'package:asuka/asuka.dart';

import '../../../modules/auth/domain/entities/logged_user_info.dart';
import '../../../modules/auth/domain/usecases/usecases.dart';

abstract class IAuthStore {
  bool get isLogged;

  LoggedUserInfo? get user;

  void setUser(LoggedUserInfo? user);

  Future<void> checkLogin();

  Future signOut();
}

class AuthStore implements IAuthStore {
  final IGetLoggedUser getLoggedUser;
  final ILogout logout;

  LoggedUserInfo? _user;

  AuthStore(this.getLoggedUser, this.logout);

  @override
  bool get isLogged => _user != null;

  @override
  LoggedUserInfo? get user => _user;

  @override
  void setUser(LoggedUserInfo? user) => _user = user;

  @override
  Future<void> checkLogin() async {
    var result = await getLoggedUser();
    return result.fold(
      (l) => AsukaSnackbar.warning(l.message),
      (u) => _user = u.toNullable(),
    );
  }

  @override
  Future signOut() async {
    var result = await logout();
    result.fold((l) {
      AsukaSnackbar.alert(l.message.split(':').last.trim()).show();
    }, (r) {
      _user = null;
    });
  }
}
