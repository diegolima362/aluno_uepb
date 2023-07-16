import 'package:asp/asp.dart';
import 'package:result_dart/result_dart.dart';

import '../../../../shared/data/types/types.dart';
import '../../models/models.dart';

// atoms
final coursesState = Atom<List<Course>>([]);
final coursesLoadingState = Atom<bool>(true);
final coursesResultState = Atom<Result<String, AppException>?>(null);

// actions
final fetchCourses = Atom.action();
final refreshCourses = Atom.action();
