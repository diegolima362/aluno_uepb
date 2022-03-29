import 'package:aluno_uepb/app/modules/courses/domain/entities/course_entity.dart';
import 'package:asuka/snackbars/asuka_snack_bar.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:fpdart/fpdart.dart';
import 'package:open_file/open_file.dart';

import '../../../../core/external/drivers/fpdart_either_adapter.dart';
import '../../domain/entities/entities.dart';
import '../../domain/errors/errors.dart';
import '../../domain/usecases/usecases.dart';

class CoursesStore extends NotifierStore<CoursesFailure, List<CourseEntity>> {
  final IGetCourses usecase;
  final IGetRDM getRDM;

  CoursesStore(this.usecase, this.getRDM) : super([]);

  Future<Unit> getData() async {
    setLoading(true);
    executeEither(() => FpdartEitherAdapter.adapter(usecase()));
    return unit;
  }

  Future<Unit> updateData() async {
    if (isLoading) return unit;

    update([]);
    setLoading(true);

    executeEither(() => FpdartEitherAdapter.adapter(usecase(cached: false)));
    return unit;
  }

  Future<Unit> openRDM() async {
    update([]);
    setLoading(true);

    final result = await getRDM();

    await getData();

    result.fold(
      (l) => AsukaSnackbar.alert(l.message).show(),
      (r) async => await OpenFile.open(r),
    );

    return unit;
  }
}
