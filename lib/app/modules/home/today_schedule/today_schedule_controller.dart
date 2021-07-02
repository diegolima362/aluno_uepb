import 'package:aluno_uepb/app/shared/models/models.dart';
import 'package:aluno_uepb/app/shared/repositories/data_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';

part 'today_schedule_controller.g.dart';

@Injectable()
class TodayScheduleController = _TodayScheduleControllerBase
    with _$TodayScheduleController;

abstract class _TodayScheduleControllerBase with Store {
  final DataController storage;

  @observable
  var courses = ObservableList<CourseModel>();

  @observable
  var isLoading = true;

  @observable
  var hasError = false;

  @observable
  var hasAlerts = false;

  @observable
  var alerts = '';

  _TodayScheduleControllerBase(this.storage) {
    print('TodayScheduleControllerBase > created');
    loadData();
  }

  @computed
  bool get canPush => courses.isNotEmpty;

  @action
  Future<void> loadData() async {
    setIsLoading(true);
    courses.clear();

    await _loadAlerts();

    try {
      final data = await storage.getCourses();
      final today = DateTime.now().weekday;

      if (data != null) {
        courses.addAll(data
            .where((e) =>
                e.schedule.map((e) => e.weekDay).toList().contains(today))
            .toList());

        courses.sort(
          (a, b) =>
              a.startTimeAtDay(today)!.compareTo(b.startTimeAtDay(today)!),
        );
      }

      setIsLoading(false);
    } catch (e) {
      print('HomeContentController > \n$e');
      hasError = true;
      setIsLoading(false);
    }
  }

  Future<void> _loadAlerts() async {
    final _alerts = await storage.getAlerts();
    if (_alerts != null) alerts = _alerts;
    hasAlerts = alerts.isNotEmpty;
  }

  @action
  void setIsLoading(bool value) => isLoading = value;
}
