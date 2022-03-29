import 'package:fpdart/fpdart.dart';

import '../entities/notification_entity.dart';
import '../errors/erros.dart';

typedef EitherString = Either<ConnectivityFailure, String>;

typedef EitherConnectivityBool = Either<ConnectivityFailure, bool>;

typedef EitherNotificationUnit = Either<NotificationFailure, Unit>;

typedef EitherNotifications
    = Either<NotificationFailure, List<NotificationEntity>>;

typedef EitherWorkUnit = Either<WorkerFailure, Unit>;

typedef EitherStreamFutureBool
    = Either<ConnectivityFailure, Stream<Future<bool>>>;
