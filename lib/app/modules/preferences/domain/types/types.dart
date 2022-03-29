import 'package:aluno_uepb/app/modules/preferences/domain/entities/preferences_entity.dart';
import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';

import '../erros/erros.dart';

typedef EitherInt = Either<PreferencesFailure, int>;

typedef EitherThemeMode = Either<PreferencesFailure, ThemeMode>;

typedef EitherPreferences = Either<PreferencesFailure, PreferencesEntity>;

typedef EitherUnit = Either<PreferencesFailure, Unit>;
