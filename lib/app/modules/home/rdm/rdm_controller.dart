import 'dart:async';

import 'package:aluno_uepb/app/shared/models/models.dart';
import 'package:aluno_uepb/app/shared/repositories/data_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';

part 'rdm_controller.g.dart';

@Injectable()
class RdmController = _RdmControllerBase with _$RdmController;

abstract class _RdmControllerBase with Store {
  final DataController storage;

  @observable
  var courses = ObservableList<CourseModel>();

  @observable
  var isLoading = true;

  @observable
  var hasError = false;

  _RdmControllerBase(this.storage) {
    loadData();
  }

  @action
  Future<void> loadData() async {
    try {
      isLoading = true;
      setCourses(await storage.getCourses());
    } catch (e) {
      print('RDMController > \n$e');
      hasError = true;
    } finally {
      isLoading = false;
    }
  }

  @action
  void setCourses(List<CourseModel>? value) {
    if (value != null) {
      print('> RDMController: set courses');
      courses.clear();
      courses.addAll(value);
      courses.sort(
        (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
      );
    }
  }

  @action
  Future<void> update() async {
    try {
      isLoading = true;
      setCourses(await storage.updateCourses());
    } catch (e) {
      print('RDMController > \n$e');
      hasError = true;
    } finally {
      isLoading = false;
    }
  }

  @action
  void setLoading(bool value) => isLoading = value;
}
