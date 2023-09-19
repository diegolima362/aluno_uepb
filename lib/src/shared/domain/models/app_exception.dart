class AppException implements Exception {
  final String message;
  final String? code;

  AppException(this.message, {this.code});

  @override
  String toString() {
    return 'AppError{message: $message, code: $code}';
  }
}
