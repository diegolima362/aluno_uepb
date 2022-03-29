import 'package:fpdart/fpdart.dart';

import '../entities/entities.dart';
import '../errors/erros.dart';

typedef EitherRecurring = Either<AlertFailure, List<RecurringAlertEntity>>;

typedef EitherReminders = Either<AlertFailure, List<TaskReminderEntity>>;

typedef EitherString = Either<AlertFailure, String>;

typedef EitherUnit = Either<AlertFailure, Unit>;

typedef EitherStreamRecurring
    = Either<AlertFailure, Stream<List<RecurringAlertEntity>>>;
