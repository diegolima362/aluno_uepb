import 'package:aluno_uepb/app/core/external/drivers/drivers.dart';
import 'package:aluno_uepb/app/modules/alerts/domain/entities/entities.dart';
import 'package:aluno_uepb/app/modules/courses/domain/usecases/usecases.dart';
import 'package:asuka/asuka.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:fpdart/fpdart.dart';

import '../../domain/errors/erros.dart';
import '../../domain/usecases/usecases.dart';

typedef Alerts = List<RecurringAlertEntity>;

class RecurringAlertsStore extends NotifierStore<AlertFailure, Alerts> {
  final IGetRecurringAlerts getAlertsUsecase;
  final IUpdateRecurringAlert updateAlertUsecase;
  final ICreateRecurringAlert createAlertUsease;
  final IRemoveRecurringAlerts removeAlertsUsecase;
  final IGetCourses getCoursesUsecase;

  RecurringAlertsStore(
    this.getAlertsUsecase,
    this.updateAlertUsecase,
    this.createAlertUsease,
    this.getCoursesUsecase,
    this.removeAlertsUsecase,
  ) : super([]);

  Future<Unit> getData(String? course) async {
    setLoading(true);

    executeEither(
      () => FpdartEitherAdapter.adapter(getAlertsUsecase(course: course)),
    );

    return unit;
  }

  Future<Unit> createAlert(RecurringAlertEntity alert) async {
    final result = await createAlertUsease(alert);

    result.fold(
      (l) => AsukaSnackbar.alert(l.message),
      (r) => AsukaSnackbar.success('Lembrete criado'),
    );

    return unit;
  }

  Future<Unit> updateAlert(RecurringAlertEntity alert) async {
    final result = await updateAlertUsecase(alert);

    result.fold(
      (l) => AsukaSnackbar.alert(l.message),
      (r) => AsukaSnackbar.success('Lembrete atualizado'),
    );

    return unit;
  }

  Future<Unit> removeAlert(int id) async {
    final result = await removeAlertsUsecase(id: id);

    result.fold(
      (l) => AsukaSnackbar.alert(l.message),
      (r) => AsukaSnackbar.success('Lembrete removido'),
    );

    return unit;
  }
}
