import 'package:aluno_uepb/app/shared/models/course_model.dart';
import 'package:aluno_uepb/app/shared/repositories/data_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';

part 'full_schedule_controller.g.dart';

@Injectable()
class FullScheduleController = _FullScheduleBase with _$FullScheduleController;

abstract class _FullScheduleBase with Store {
  final DataController storage;

  @observable
  var courses = ObservableList<CourseModel>();

  @observable
  bool isLoading = true;

  _FullScheduleBase(this.storage) {
    loadData();
  }

  @action
  void setIsLoading(bool value) => isLoading = value;

  @action
  Future<void> loadData() async {
    try {
      isLoading = true;
      final data = await storage.getCourses();

      if (data != null) {
        courses.clear();
        courses.addAll(data);
        courses.sort((a, b) => a.name.compareTo(b.name));
      }
    } catch (e) {
      print('FullScheduleController> \n$e');
    } finally {
      isLoading = false;
    }
  }

  List<CourseModel> classesAtDay(int day) {
    final c = courses.where((c) => c.hasClassAtDay(day)).toList();
    c.sort((a, b) => a.startTimeAtDay(day)!.compareTo(b.startTimeAtDay(day)!));
    return c;
  }
}
