import 'package:fpdart/fpdart.dart';

import '../entities/logged_user_info.dart';
import '../errors/errors.dart';

typedef EitherLoggedInfo = Either<AuthFailure, Option<LoggedUserInfo>>;

typedef EitherToken = Either<AuthFailure, Option<String>>;
