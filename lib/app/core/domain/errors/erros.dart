abstract class NotificationFailure implements Exception {
  String get message;

  @override
  String toString() => '$runtimeType: $message';
}

class ScheduleNotificationError implements NotificationFailure {
  @override
  final String message;
  ScheduleNotificationError({required this.message});
}

class DisplayNotificationError implements NotificationFailure {
  @override
  final String message;
  DisplayNotificationError({required this.message});
}

class ErrorGetNotifications implements NotificationFailure {
  @override
  final String message;
  ErrorGetNotifications({required this.message});
}

class CancelNotificationError implements NotificationFailure {
  @override
  final String message;
  CancelNotificationError({required this.message});
}

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

abstract class WorkerFailure implements Exception {
  String get message;

  @override
  String toString() => '$runtimeType: $message';
}

class ScheduleWorkerError implements WorkerFailure {
  @override
  final String message;
  ScheduleWorkerError({required this.message});
}

class CancelWorkerError implements WorkerFailure {
  @override
  final String message;
  CancelWorkerError({required this.message});
}
