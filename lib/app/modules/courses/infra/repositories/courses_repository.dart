import 'package:aluno_uepb/app/core/external/drivers/shared_prefs.dart';
import 'package:aluno_uepb/app/modules/courses/domain/entities/course_entity.dart';
import 'package:fpdart/fpdart.dart';

import '../../domain/errors/errors.dart';
import '../../domain/repositories/courses_repository.dart';
import '../../domain/types/types.dart';
import '../datasources/courses_datasource.dart';

class CoursesRepository implements ICoursesRepository {
  final ICoursesLocalDatasource localData;
  final ICoursesRemoteDatasource remoteData;
  final SharedPrefs prefsStorage;

  final coursesCache = <CourseEntity>[];
  final todayCache = <CourseEntity>[];

  CoursesRepository(this.localData, this.remoteData, this.prefsStorage);

  Future<bool> get updated async => DateTime.now()
      .add(const Duration(hours: 1))
      .isAfter(await prefsStorage.getLastCoursesUpdate());

  @override
  Future<EitherCourse> getCourseById(String id) async {
    final filtered = coursesCache.filter((t) => t.id == id);

    if (filtered.isNotEmpty) {
      return Right(Option.of(filtered.first));
    } else {
      return Right(Option.none());
    }
  }

  @override
  Future<EitherCourses> getCourses({String? id, bool cached = true}) async {
    final courses = <CourseEntity>[];

    if (cached) {
      if (coursesCache.isNotEmpty) {
        return Right(coursesCache);
      } else {
        try {
          final result = (await localData.getCourses(id: id));
          courses.addAll(result);
          coursesCache.clear();
          coursesCache.addAll(result);
        } on CoursesFailure catch (e) {
          return Left(e);
        }
      }
    }

    if (courses.isEmpty || !await updated) {
      try {
        if (courses.isEmpty) {
          final result = await remoteData.getCourses(id: id);
          await localData.saveCourses(result);
          courses.addAll(result);

          coursesCache.clear();
          coursesCache.addAll(result);
        } else {
          remoteData.getCourses(id: id).then(
            (r) async {
              coursesCache.clear();

              coursesCache.addAll(r);
              await localData.saveCourses(r);
            },
          );
        }

        await prefsStorage.setLastCoursesUpdate(DateTime.now());
      } on CoursesFailure catch (e) {
        return Left(e);
      }
    }

    todayCache.clear();

    return Right(courses);
  }

  @override
  Future<EitherCourses> getTodaysClasses() async {
    try {
      if (todayCache.isNotEmpty) return Right(todayCache);

      if (coursesCache.isEmpty) {
        final result = await getCourses();

        if (result.isLeft()) return Left(result.getLeft().toNullable()!);
      }

      final result = (await localData.getTodaysClasses());
      todayCache.addAll(result);

      return Right(result);
    } on CoursesFailure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<EitherString> getRDM({bool cached = true}) async {
    if (cached) {
      try {
        final result = (await localData.readRDM());

        if (result.isNotEmpty) {
          return Right(result);
        }
      } on CoursesFailure catch (e) {
        return Left(e);
      }
    }

    try {
      final result = await remoteData.downloadRDM();

      return await result.toEither(() => GetCoursesError()).fold(
        (l) => Left(l),
        (r) async {
          await localData.saveRDM(r);

          return Right(await localData.readRDM());
        },
      );
    } on CoursesFailure catch (e) {
      return Left(e);
    }
  }
}
