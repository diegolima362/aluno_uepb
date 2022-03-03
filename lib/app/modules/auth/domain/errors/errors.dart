abstract class AuthFailure implements Exception {
  String get message;

  @override
  String toString() => '$runtimeType: $message';
}

class NotSignedUser extends AuthFailure {
  @override
  final String message;
  NotSignedUser({required this.message});
}

class AuthConnectionError extends AuthFailure {
  @override
  final String message;
  AuthConnectionError({required this.message});
}

class SignInError extends AuthFailure {
  @override
  final String message;
  SignInError({required this.message});
}

class ErrorGuestSignIn extends AuthFailure {
  @override
  final String message;
  ErrorGuestSignIn({required this.message});
}

class ErrorGetLoggedUser extends AuthFailure {
  @override
  final String message;
  ErrorGetLoggedUser({this.message = 'Erro ao recuperar usuario'});
}

class ErrorGetToken extends AuthFailure {
  @override
  final String message;
  ErrorGetToken({this.message = 'Erro ao recuperar token'});
}

class ErrorRefreshToken extends AuthFailure {
  @override
  final String message;
  ErrorRefreshToken({this.message = 'Erro ao atualizar token'});
}

class ErrorLogout extends AuthFailure {
  @override
  final String message;
  ErrorLogout({required this.message});
}

class InternalError implements AuthFailure {
  @override
  final String message;
  InternalError({required this.message});
}
