import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';

import '../repositories/preferences_repository.dart';
import '../types/types.dart';

mixin IStoreThemeMode {
  Future<EitherUnit> call(ThemeMode val);
}

class StoreThemeMode implements IStoreThemeMode {
  final IPreferencesRepository respository;

  StoreThemeMode(this.respository);

  @override
  Future<EitherUnit> call(ThemeMode val) async {
    final result = await respository.setThemeMode(val.index);
    return result.fold((l) => Left(l), (r) => Right(r));
  }
}
