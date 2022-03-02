abstract class PreferencesFailure implements Exception {
  String get message;

  @override
  String toString() => '$runtimeType: $message';
}

class ErrorGetThemeMode extends PreferencesFailure {
  @override
  final String message;
  ErrorGetThemeMode({this.message = 'Erro ao obter tema'});
}

class ErrorStoreThemeMode extends PreferencesFailure {
  @override
  final String message;
  ErrorStoreThemeMode({this.message = 'Erro ao armazenar tema'});
}

class ErrorClearDatabase extends PreferencesFailure {
  @override
  final String message;
  ErrorClearDatabase({this.message = 'Erro ao limpar dados'});
}
