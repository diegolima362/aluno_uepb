import 'package:asp/asp.dart';
import 'package:result_dart/result_dart.dart';

import '../../../../shared/domain/models/app_exception.dart';
import '../../models/models.dart';

// atoms
final fullScheduleState = Atom<List<ScheduleAtWeekDay>>([]);
final fullScheduleLoadingState = Atom<bool>(true);
final fullScheduleResultState = Atom<Result<String, AppException>?>(null);

// actions
final fetchFullScheduleAction = Atom.action();
