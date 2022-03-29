abstract class ProfileFailure implements Exception {
  String get message;

  @override
  String toString() => '$runtimeType: $message';
}

class GetProfileError implements ProfileFailure {
  @override
  final String message;
  GetProfileError({this.message = ''});
}

class UpdateProfileError implements ProfileFailure {
  @override
  final String message;
  UpdateProfileError({this.message = ''});
}
