abstract class HistoryFailure implements Exception {
  String get message;

  @override
  String toString() => '$runtimeType: $message';
}

class GetHistoryError implements HistoryFailure {
  @override
  final String message;
  GetHistoryError({this.message = ''});
}
