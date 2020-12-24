import 'package:aluno_uepb/app/shared/models/course_model.dart';
import 'package:aluno_uepb/app/shared/models/models.dart';
import 'package:flutter_modular/flutter_modular.dart';

abstract class IDataRepository implements Disposable {
  Future<List<CourseModel>> getCourses();

  Future<ProfileModel> getProfile();
}
