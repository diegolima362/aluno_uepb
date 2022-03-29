import 'package:fpdart/fpdart.dart';

abstract class IWorkManagerDriver {
  Future<Unit> scheduleWorker();

  Future<Unit> cancelWorker({String? id});
}
