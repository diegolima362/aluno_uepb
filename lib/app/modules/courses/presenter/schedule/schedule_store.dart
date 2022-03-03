import 'package:aluno_uepb/app/modules/courses/domain/entities/course_entity.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/external/drivers/fpdart_either_adapter.dart';
import '../../domain/entities/entities.dart';
import '../../domain/errors/errors.dart';
import '../../domain/usecases/usecases.dart';

class ScheduleStore extends NotifierStore<RDMFailure, List<CourseEntity>> {
  final IGetCourses usecase;

  ScheduleStore(this.usecase) : super([]);

  Future<Unit> getData() async {
    executeEither(() => FpdartEitherAdapter.adapter(usecase()));
    return unit;
  }
}
