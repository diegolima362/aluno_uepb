import 'package:aluno_uepb/app/shared/models/models.dart';
import 'package:aluno_uepb/app/shared/repositories/data_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';

part 'home_content_controller.g.dart';

@Injectable()
class HomeContentController = _HomeContentBase with _$HomeContentController;

abstract class _HomeContentBase with Store {
  late final DataController storage;

  @observable
  ObservableList<CourseModel> courses = ObservableList<CourseModel>();

  @observable
  bool extended = true;

  @observable
  bool isLoading = true;

  _HomeContentBase() {
    storage = Modular.get();
    loadData();
  }

  @computed
  bool get canPush => courses.isNotEmpty;

  @action
  Future<void> loadData() async {
    setIsLoading(true);
    courses.clear();

    final data = await storage.getCourses();
    final today = DateTime.now().weekday;

    if (data != null) {
      courses.addAll(data
          .where(
              (e) => e.schedule.map((e) => e.weekDay).toList().contains(today))
          .toList());

      courses.sort(
        (a, b) => a.startTimeAtDay(today)!.compareTo(b.startTimeAtDay(today)!),
      );
    }

    setIsLoading(false);
  }

  @action
  void setIsLoading(bool value) => isLoading = value;

  @action
  void setExtended(bool value) => extended = value;

  @action
  void showDetails(CourseModel course) {
    Modular.to.pushNamed('rdm/details', arguments: course);
  }

  @action
  void showFullSchedule() {
    Modular.to.pushNamed('content/details');
  }
}