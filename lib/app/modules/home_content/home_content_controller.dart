import 'package:aluno_uepb/app/shared/event_logger/interfaces/event_logger_interface.dart';
import 'package:aluno_uepb/app/shared/models/course_model.dart';
import 'package:aluno_uepb/app/shared/repositories/data_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';

part 'home_content_controller.g.dart';

@Injectable()
class HomeContentController = _HomeContentBase with _$HomeContentController;

abstract class _HomeContentBase with Store {
  DataController storage;

  @observable
  ObservableList<CourseModel> courses;

  @observable
  bool extended;

  _HomeContentBase() {
    storage = Modular.get();
    setExtended(true);

    loadData();
  }

  @computed
  bool get canPush => courses != null;

  @action
  Future<void> loadData() async {
    courses = ObservableList<CourseModel>();

    final data = await storage.getCourses();
    final today = DateTime.now().weekday;

    if (data != null) {
      courses.addAll(data
          .where(
              (e) => e.schedule.map((e) => e.weekDay).toList().contains(today))
          .toList());

      courses.sort(
        (a, b) => a.startTimeAtDay(today).compareTo(b.startTimeAtDay(today)),
      );
    }
  }

  @action
  void setExtended(bool value) {
    extended = value;
  }

  @action
  Future<void> showDetails(CourseModel course) async {
    await Modular.to.pushNamed('rdm/details', arguments: course);
  }

  @action
  Future<void> showFullSchedule() async {
    Modular.get<IEventLogger>().logEvent('logViewFullSchedule');
    await Modular.to.pushNamed('content/all');
  }
}
