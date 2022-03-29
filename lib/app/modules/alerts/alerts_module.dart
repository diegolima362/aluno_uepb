import 'package:aluno_uepb/app/modules/alerts/presenter/reminders/remiders_details_page.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'domain/usecases/usecases.dart';
import 'external/datasources/alerts_datasource.dart';
import 'infra/repositories/alerts_repository.dart';
import 'presenter/alerts/alert_edit_page.dart';
import 'presenter/alerts/alerts_store.dart';
import 'presenter/reminders/reminder_edit_page.dart';
import 'presenter/reminders/reminders_page.dart';
import 'presenter/reminders/reminders_store.dart';

class AlertsModule extends Module {
  static List<Bind> export = [
    //usecases
    Bind.lazySingleton((i) => CreateRecurringAlert(i())),
    Bind.lazySingleton((i) => GetRecurringAlerts(i())),
    Bind.lazySingleton((i) => UpdateRecurringAlert(i())),
    Bind.lazySingleton((i) => RemoveAlerts(i())),

    Bind.lazySingleton((i) => CreateReminder(i())),
    Bind.lazySingleton((i) => GetReminders(i())),
    Bind.lazySingleton((i) => UpdateReminder(i())),
    Bind.lazySingleton((i) => RemoveReminders(i())),

    // datasources
    Bind.lazySingleton((i) => AlertsDatasource(i())),

    // repositories
    Bind.lazySingleton((i) => AlertsRepository(i(), i(), i())),

    //stores
    Bind.lazySingleton((i) => RemindersStore(i(), i(), i(), i(), i())),
    Bind.lazySingleton((i) => RecurringAlertsStore(i(), i(), i(), i(), i())),
  ];

  @override
  final List<Bind> binds = [];

  @override
  final List<ModularRoute> routes = [
    ChildRoute('/', child: (_, __) => const RemindersPage()),
    ChildRoute(
      '/reminder/edit/',
      child: (_, args) => ReminderEditPage(
        reminder: args.data['reminder'],
        courseId: args.data['course'],
      ),
    ),
    ChildRoute(
      '/reminder/details/',
      child: (_, args) => ReminderDetailsPage(reminder: args.data),
    ),
    ChildRoute(
      '/recurring/edit/',
      child: (_, args) => AlertEditPage(
        alert: args.data['alert'],
        course: args.data['course'],
      ),
    ),
  ];
}
