import 'package:fpdart/fpdart.dart';

import '../entities/entities.dart';
import '../errors/errors.dart';

typedef EitherCourses = Either<RDMFailure, List<CourseEntity>>;

typedef EitherProfile = Either<RDMFailure, Option<ProfileEntity>>;

typedef EitherHistory = Either<RDMFailure, List<HistoryEntity>>;
