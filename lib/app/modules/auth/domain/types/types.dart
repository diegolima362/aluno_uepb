import 'package:aluno_uepb/app/core/external/drivers/session.dart';
import 'package:fpdart/fpdart.dart';

import '../entities/logged_user_info.dart';
import '../errors/errors.dart';

typedef EitherLoggedInfo = Either<AuthFailure, Option<LoggedUserInfo>>;

typedef EitherSession = Either<AuthFailure, Session>;
