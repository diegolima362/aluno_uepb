import 'package:aluno_uepb/app/shared/models/models.dart';
import 'package:aluno_uepb/app/shared/notifications/interfaces/notifications_manager_interface.dart';
import 'package:aluno_uepb/app/shared/repositories/data_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';

part 'rdm_details_controller.g.dart';

@Injectable()
class RDMDetailsController = _DetailsControllerBase with _$RDMDetailsController;

abstract class _DetailsControllerBase with Store {
  final CourseModel course;

  @observable
  var reminders = ObservableList<NotificationModel>();

  @observable
  int currentPage = 1;

  @observable
  var tasks = ObservableList<TaskModel>();

  @observable
  bool isLoading = true;

  @observable
  String title = '';

  final INotificationsManager notificationManager;

  final DataController storage;

  _DetailsControllerBase({
    required this.course,
    required this.storage,
    required this.notificationManager,
  }) {
    loadData();
  }

  @computed
  bool get hasReminders => reminders.isNotEmpty;

  @computed
  bool get hasTasks => tasks.isNotEmpty;

  @action
  void setPage(int value) => currentPage = value;

  @action
  Future<void> deleteReminder(NotificationModel notification) async {
    await notificationManager.cancelNotification(notification.id);
    final data = await notificationManager.getAllNotifications();
    reminders.clear();
    reminders.addAll(data
        .cast<NotificationModel>()
        .where((x) => x.courseId == course.id && !x.taskReminder)
        .toList());
  }

  @action
  Future<void> loadData() async {
    isLoading = true;

    final data = await Future.wait([
      notificationManager.getAllNotifications(),
      storage.getTasks(),
    ]);

    reminders.clear();
    tasks.clear();

    reminders.addAll(data[0]
        .cast<NotificationModel>()
        .where((x) => x.courseId == course.id && !x.taskReminder)
        .toList());

    tasks.addAll(data[1]
        .cast<TaskModel>()
        .where((x) => x.courseId == course.id)
        .toList());

    isLoading = false;
  }
}
