abstract class AlertFailure implements Exception {
  String get message;

  @override
  String toString() => '$runtimeType: $message';
}

class CoursesError implements AlertFailure {
  @override
  final String message;
  CoursesError({this.message = 'Erro ao carregar cursos!'});
}

class LoadAlertsError implements AlertFailure {
  @override
  final String message;
  LoadAlertsError({this.message = 'Erro ao carregar alertas!'});
}

class CreateReminderError implements AlertFailure {
  @override
  final String message;
  CreateReminderError({this.message = 'Erro ao registrar lembrete!'});
}

class CreateAlertError implements AlertFailure {
  @override
  final String message;
  CreateAlertError({this.message = 'Erro ao registrar alertas!'});
}

class RemoveAlertError implements AlertFailure {
  @override
  final String message;
  RemoveAlertError({this.message = 'Erro ao cancelar alertas!'});
}

class UpdateAlertError implements AlertFailure {
  @override
  final String message;
  UpdateAlertError({this.message = 'Erro ao atualizar alerta!'});
}
