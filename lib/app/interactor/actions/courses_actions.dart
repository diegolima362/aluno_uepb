import 'package:result_dart/result_dart.dart';

import '../../injector.dart';
import '../../interactor/atoms/atoms.dart';
import '../repositories/repositories.dart';

const _refreshIntervalInHours = 6;

final _repository = injector.get<CoursesRepository>();

void fetchCourses() async {
  setCoursesLoading(true);
  setCoursesResult(null);
  setCoursesState([]);

  await _repository.fetchCourses().fold(
        (courses) => setCoursesState(courses),
        (err) => setCoursesResult(Failure(err)),
      );

  setCoursesLoading(false);
}

Future<void> refreshCourses() async {
  setCoursesLoading(true);
  setCoursesResult(null);
  setCoursesState([]);

  setCoursesResult(await _repository.refreshCourses().map(
    (courses) {
      setCoursesState(courses);
      setLastSync(DateTime.now());

      return 'Cursos atualizados!';
    },
  ));

  setCoursesLoading(false);
}
