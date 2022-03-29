import 'package:aluno_uepb/app/modules/courses/domain/errors/errors.dart';
import 'package:aluno_uepb/app/modules/courses/domain/usecases/usecases.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/external/drivers/fpdart_either_adapter.dart';
import '../../domain/entities/entities.dart';

class TodayStore extends NotifierStore<CoursesFailure, List<CourseEntity>> {
  final IGetTodaysClasses usecase;

  TodayStore(this.usecase) : super([]);

  Future<Unit> getData() async {
    setLoading(true);

    executeEither(() => FpdartEitherAdapter.adapter(usecase()));

    return unit;
  }
}
