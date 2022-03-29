import 'package:fpdart/fpdart.dart';

import '../entities/preferences_entity.dart';
import '../repositories/preferences_repository.dart';
import '../types/types.dart';

mixin ISetPreferences {
  Future<EitherUnit> call(PreferencesEntity preferences);
}

class SetPreferences implements ISetPreferences {
  final IPreferencesRepository respository;

  SetPreferences(this.respository);

  @override
  Future<EitherUnit> call(PreferencesEntity preferences) async {
    final result = await respository.updatePreferences(preferences);
    return result.fold((l) => Left(l), (r) => Right(r));
  }
}
