import 'package:aluno_uepb/app/shared/models/models.dart';
import 'package:aluno_uepb/app/shared/notifications/interfaces/notifications_manager_interface.dart';
import 'package:aluno_uepb/app/shared/repositories/data_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';

part 'rdm_details_controller.g.dart';

@Injectable()
class RDMDetailsController = _DetailsControllerBase with _$RDMDetailsController;

abstract class _DetailsControllerBase with Store {
  @observable
  CourseModel course = Modular.args!.data;

  @observable
  ObservableList<NotificationModel> reminders =
      ObservableList<NotificationModel>();

  @observable
  ObservableList<TaskModel> tasks = ObservableList<TaskModel>();

  @observable
  bool isLoading = true;

  @observable
  String title = '';

  @observable
  bool extended = true;

  late final INotificationsManager _manager;

  late final DataController _storage;

  _DetailsControllerBase() {
    _manager = Modular.get();
    _storage = Modular.get();

    final CourseModel r = Modular.args!.data;
    print(r);

    course = r;
    setExtended(true);
    loadData();
  }

  @computed
  bool get hasReminders => reminders.isNotEmpty;

  @computed
  bool get hasTasks => tasks.isNotEmpty;

  @action
  Future<void> deleteReminder(NotificationModel notification) async {
    await _manager.cancelNotification(notification.id);
    final data = await _manager.getAllNotifications();
    reminders.clear();
    reminders.addAll(data
        .cast<NotificationModel>()
        .where((x) => x.courseId == course.id && !x.taskReminder)
        .toList());
  }

  @action
  Future<void> loadData() async {
    isLoading = true;

    final List<List> data = await Future.wait([
      _manager.getAllNotifications(),
      _storage.getTasks(),
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

  @action
  void setExtended(bool value) {
    extended = value;
  }

  @action
  Future<void> showDetails(TaskModel task) async {
    await Modular.to.pushNamed('/home/reminders/task/details', arguments: task);
    await loadData();
  }

  @action
  Future<void> showScheduler() async {
    await Modular.to.pushNamed('details/scheduler', arguments: course);
  }
}
