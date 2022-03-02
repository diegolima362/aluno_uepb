import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';

import '../erros/erros.dart';

typedef EitherInt = Either<PreferencesFailure, int>;

typedef EitherThemeMode = Either<PreferencesFailure, ThemeMode>;

typedef EitherUnit = Either<PreferencesFailure, Unit>;
