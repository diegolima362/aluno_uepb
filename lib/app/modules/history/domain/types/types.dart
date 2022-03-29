import 'package:fpdart/fpdart.dart';

import '../entities/entities.dart';
import '../errors/errors.dart';

typedef EitherHistory = Either<HistoryFailure, List<HistoryEntity>>;
