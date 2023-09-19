import 'package:asp/asp.dart';
import 'package:result_dart/result_dart.dart';

import '../../../../shared/domain/models/app_exception.dart';
import '../../models/models.dart';

// atoms
final todayScheduleState = Atom<List<ClassAtDay>>([]);
final todayScheduleLoadingState = Atom<bool>(false);
final todayScheduleResultState = Atom<Result<String, AppException>?>(null);

// actions
final fetchTodayScheduleAction = Atom.action();
