abstract class ConnectivityFailure implements Exception {
  String get message;

  @override
  String toString() => '$runtimeType: $message';
}

class ConnectionError implements ConnectivityFailure {
  @override
  final String message;
  ConnectionError({required this.message});
}
