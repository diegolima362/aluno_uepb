import 'package:asp/asp.dart';
import 'package:result_dart/result_dart.dart';

import '../../core/exceptions/app_exception.dart';
import '../models/schedule.dart';

// atoms.dart
final scheduleState = atom<Map<int, DailySchedule>>({});
final scheduleLoadingState = atom<bool>(false);
final scheduleResultState = atom<Result<String, AppException>?>(null);

// selectors

final todayScheduleState = selector((get) {
  final schedule = get(scheduleState);
  final today = DateTime.now().weekday;
  return schedule[today]?.schedule ?? [];
});

// setters

final setScheduleState = atomAction1<Map<int, DailySchedule>>(
  (set, value) => set<Map<int, DailySchedule>>(scheduleState, value),
);

final setScheduleLoading = atomAction1<bool>(
  (set, value) => set<bool>(scheduleLoadingState, value),
);

final setScheduleResult = atomAction1<Result<String, AppException>?>(
  (set, value) =>
      set<Result<String, AppException>?>(scheduleResultState, value),
);
