abstract class RDMFailure implements Exception {
  String get message;

  @override
  String toString() => '$runtimeType: $message';
}

class WrongCredentials implements RDMFailure {
  @override
  final String message;
  WrongCredentials({this.message = 'Matrícula ou senha não conferem!'});
}

class ServerError implements RDMFailure {
  @override
  final String message;
  ServerError({this.message = 'Problema na comunicação com o servidor!'});
}
