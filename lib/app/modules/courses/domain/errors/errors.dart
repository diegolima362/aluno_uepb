abstract class CoursesFailure implements Exception {
  String get message;

  @override
  String toString() => '$runtimeType: $message';
}

class AlertFailure implements CoursesFailure {
  @override
  final String message;
  AlertFailure({this.message = ''});
}

class GetCoursesError implements CoursesFailure {
  @override
  final String message;
  GetCoursesError({this.message = ''});
}
