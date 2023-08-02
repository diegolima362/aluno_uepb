import 'package:asp/asp.dart';
import 'package:result_dart/result_dart.dart';

import '../../../preferences/atoms/preferences_atom.dart';
import '../../data/repositories/course_repository.dart';
import '../atoms/courses_atom.dart';

const _refreshIntervalInHours = 6;

class CourseReducer extends Reducer {
  final CourseRepository _courseRepository;

  CourseReducer(this._courseRepository) {
    on(() => [fetchCourses], _fetchCourses);
    on(() => [refreshCourses], _refreshData);
    on(() => [clearCoursesData], _clearCoursesData);
  }

  void _fetchCourses([bool refresh = false]) async {
    coursesLoadingState.value = true;
    coursesResultState.value = null;
    coursesState.value = [];

    final lastSync = lastSyncState.value;
    final now = DateTime.now();
    final shouldRefresh = refresh ||
        lastSync == null ||
        now.difference(lastSync).inHours >= _refreshIntervalInHours;

    if (shouldRefresh) {
      _refreshData();
    }

    final result = await _courseRepository.fetchCourses();

    result.fold(
      coursesState.setValue,
      (failure) => coursesResultState.value = Result.failure(failure),
    );

    coursesLoadingState.value = false;
  }

  Future<void> _refreshData() async {
    coursesLoadingState.value = true;

    final result = await _courseRepository.fetchCourses(true);

    result.fold(
      (success) {
        coursesState.value = success;
        coursesResultState.value = Result.success('Cursos atualizados!');
        setLastSync.value = DateTime.now();
      },
      (failure) => coursesResultState.value = Result.failure(failure),
    );

    coursesLoadingState.value = false;
  }

  void _clearCoursesData() {
    coursesState.value = [];
    coursesResultState.value = null;
    _courseRepository.clear();
  }
}
