import 'dart:async';

import 'package:aluno_uepb/app/shared/event_logger/interfaces/event_logger_interface.dart';
import 'package:aluno_uepb/app/shared/models/course_model.dart';
import 'package:aluno_uepb/app/shared/repositories/data_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';

part 'rdm_controller.g.dart';

@Injectable()
class RdmController = _RdmControllerBase with _$RdmController;

abstract class _RdmControllerBase with Store {
  DataController storage = Modular.get();

  @observable
  ObservableList<CourseModel> courses = ObservableList<CourseModel>();

  @observable
  bool isLoading = true;

  @observable
  bool extended = true;

  _RdmControllerBase() {
    loadData();
  }

  @action
  Future<void> loadData() async {
    setIsLoading(true);
    setCourses(await storage.getCourses() ?? <CourseModel>[]);
    setIsLoading(false);
  }

  @action
  void setCourses(List<CourseModel>? value) {
    if (value != null) {
      print('> RDMController: set courses');

      courses = ObservableList<CourseModel>();
      courses.addAll(value);
      courses
          .sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    }
  }

  @action
  void setExtended(bool value) => extended = value;

  @action
  void setIsLoading(bool value) => isLoading = value;

  @action
  Future<void> showDetails(CourseModel course) async {
    await Modular.to.pushNamed('rdm/details', arguments: course);
  }

  @action
  void update() {
    courses.clear();
    storage.updateCourses().then(setCourses);
    Modular.get<IEventLogger>().logEvent('logUpdateCourses');
  }
}
