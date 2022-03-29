import 'package:fpdart/fpdart.dart';

import '../entities/entities.dart';
import '../errors/errors.dart';

typedef EitherProfile = Either<ProfileFailure, Option<ProfileEntity>>;
