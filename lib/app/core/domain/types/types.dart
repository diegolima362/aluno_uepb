import 'package:fpdart/fpdart.dart';

import '../errors/erros.dart';

typedef EitherString = Either<ConnectivityFailure, String>;

typedef EitherBool = Either<ConnectivityFailure, bool>;

typedef EitherStreamFutureBool
    = Either<ConnectivityFailure, Stream<Future<bool>>>;
