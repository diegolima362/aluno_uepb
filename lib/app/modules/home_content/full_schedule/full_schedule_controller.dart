import 'package:aluno_uepb/app/shared/models/course_model.dart';
import 'package:aluno_uepb/app/shared/repositories/data_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';

part 'full_schedule_controller.g.dart';

@Injectable()
class FullScheduleController = _FullScheduleBase with _$FullScheduleController;

abstract class _FullScheduleBase with Store {
  _FullScheduleBase() {
    storage = Modular.get();
    extended = true;
    loadData();
  }

  DataController storage;

  @observable
  ObservableList<CourseModel> courses;

  @observable
  bool extended;

  @action
  void setExtended(bool value) {
    extended = value;
  }

  @action
  Future<void> loadData() async {
    final data = await storage.getCourses();

    if (data != null) {
      courses = ObservableList<CourseModel>();

      courses.addAll(data);

      courses.sort((a, b) => a.name.compareTo(b.name));
    }
  }

  List<CourseModel> classesAtDay(int day) {
    final c = courses.where((c) => c.hasClassAtDay(day)).toList();

    c.sort((a, b) => a.startTimeAtDay(day).compareTo(b.startTimeAtDay(day)));

    return <CourseModel>[...c];
  }

  @action
  void showDetails(CourseModel course) {
    Modular.to.pushNamed('rdm/details', arguments: course);
  }
}
