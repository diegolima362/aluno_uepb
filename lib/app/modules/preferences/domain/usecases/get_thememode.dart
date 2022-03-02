import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';

import '../repositories/preferences_repository.dart';
import '../types/types.dart';

mixin IGetThemeMode {
  Future<EitherThemeMode> call();
}

class GetThemeMode implements IGetThemeMode {
  final IPreferencesRepository respository;

  GetThemeMode(this.respository);

  @override
  Future<EitherThemeMode> call() async {
    final result = await respository.getThemeMode();
    return result.fold((l) => Left(l), (r) => Right(ThemeMode.values[r]));
  }
}
