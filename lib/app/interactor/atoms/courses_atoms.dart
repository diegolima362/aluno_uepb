import 'package:asp/asp.dart';
import 'package:result_dart/result_dart.dart';

import '../../core/exceptions/app_exception.dart';
import '../models/course.dart';

// atoms.dart
final coursesState = atom<List<Course>>([]);
final coursesLoadingState = atom<bool>(true);
final coursesResultState = atom<Result<String, AppException>?>(null);

// setters

final setCoursesState = atomAction1<List<Course>>(
  (set, value) => set<List<Course>>(coursesState, value),
);

final setCoursesLoading = atomAction1<bool>(
  (set, value) => set<bool>(coursesLoadingState, value),
);

final setCoursesResult = atomAction1<Result<String, AppException>?>(
  (set, value) => set<Result<String, AppException>?>(coursesResultState, value),
);
