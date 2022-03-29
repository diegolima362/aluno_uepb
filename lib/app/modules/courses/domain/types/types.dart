import 'package:fpdart/fpdart.dart';

import '../entities/entities.dart';
import '../errors/errors.dart';

typedef EitherCourses = Either<CoursesFailure, List<CourseEntity>>;

typedef EitherString = Either<CoursesFailure, String>;

typedef EitherUnit = Either<CoursesFailure, Unit>;
