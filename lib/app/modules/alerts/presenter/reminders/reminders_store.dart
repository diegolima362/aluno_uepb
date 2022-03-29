import 'package:aluno_uepb/app/core/external/drivers/fpdart_either_adapter.dart';
import 'package:aluno_uepb/app/modules/courses/domain/usecases/get_courses.dart';
import 'package:asuka/asuka.dart';
import 'package:flutter/material.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:fpdart/fpdart.dart';
import 'package:asuka/asuka.dart' as asuka;
import '../../domain/entities/task_reminder_entity.dart';
import '../../domain/errors/erros.dart';
import '../../domain/usecases/usecases.dart';

typedef Reminders = List<TaskReminderEntity>;

class RemindersStore extends NotifierStore<AlertFailure, Reminders> {
  final IGetTaskReminders getRemindersUsecase;
  final IUpdateTaskReminder updateReminderUsecase;
  final ICreateRemidner createReminderUsecase;
  final IRemoveTaskReminders removeRemindersUsecase;
  final IGetCourses getCoursesUsecase;

  RemindersStore(
    this.getRemindersUsecase,
    this.updateReminderUsecase,
    this.createReminderUsecase,
    this.getCoursesUsecase,
    this.removeRemindersUsecase,
  ) : super([]);

  Future<Unit> getData(String? course) async {
    setLoading(true);

    executeEither(
      () => FpdartEitherAdapter.adapter(getRemindersUsecase(course: course)),
    );

    return unit;
  }

  Future<Unit> createReminder(TaskReminderEntity reminder) async {
    final result = await createReminderUsecase(reminder);

    result.fold(
      (l) => AsukaSnackbar.alert(l.message),
      (r) => AsukaSnackbar.success('Lembrete criado'),
    );

    return unit;
  }

  Future<Unit> updateReminder(TaskReminderEntity reminder) async {
    final result = await updateReminderUsecase(reminder);

    result.fold(
      (l) => AsukaSnackbar.alert(l.message),
      (r) => AsukaSnackbar.success('Lembrete atualizado'),
    );

    return unit;
  }

  Future<Unit> removeReminder(int id) async {
    final result = await removeRemindersUsecase(id: id);

    result.fold(
      (l) => AsukaSnackbar.alert(l.message),
      (r) => asuka.showSnackBar(
        const SnackBar(content: Text('Lembrete removido')),
      ),
    );

    return unit;
  }
}
