import 'package:fpdart/fpdart.dart';

import '../../domain/errors/errors.dart';
import '../../domain/repositories/academic_repository.dart';
import '../../domain/types/types.dart';
import '../datasources/academic_datasource.dart';

class AcademicRepository implements IAcademicRepository {
  final IAcademicLocalDatasource localDatasource;
  final IAcademicRemoteDatasource remoteDatasource;

  AcademicRepository({
    required this.localDatasource,
    required this.remoteDatasource,
  });

  @override
  Future<EitherProfile> getProfile({bool cached = true}) async {
    if (cached) {
      try {
        final result = (await localDatasource.getProfile());

        if (result.isSome()) {
          return Right(result);
        }
      } on RDMFailure catch (e) {
        return Left(e);
      }
    }

    try {
      final result = await remoteDatasource.getProfile();

      if (result.isSome()) {
        // await localDatasource.saveProfile(result.toNullable()!);
      }

      return Right(result);
    } on RDMFailure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<EitherCourses> getCourses({bool cached = true}) async {
    if (cached) {
      try {
        final result = (await localDatasource.getCourses());

        if (result.isNotEmpty) {
          result.sort((a, b) => b.name.compareTo(a.name));
          return Right(result);
        }
      } on RDMFailure catch (e) {
        return Left(e);
      }
    }

    try {
      final result = await remoteDatasource.getCourses();

      // await localDatasource.saveCourses(result);

      result.sort((a, b) => b.name.compareTo(a.name));

      return Right(result);
    } on RDMFailure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<EitherHistory> getHistory({bool cached = true}) async {
    if (cached) {
      try {
        final result = (await localDatasource.getHistory());

        if (result.isNotEmpty) {
          result.sort((a, b) => b.semester.compareTo(a.semester));
          return Right(result);
        }
      } on RDMFailure catch (e) {
        return Left(e);
      }
    }

    try {
      final result = await remoteDatasource.getHistory();

      // await localDatasource.saveHistory(result);

      result.sort((a, b) => b.semester.compareTo(a.semester));

      return Right(result);
    } on RDMFailure catch (e) {
      return Left(e);
    }
  }
}
