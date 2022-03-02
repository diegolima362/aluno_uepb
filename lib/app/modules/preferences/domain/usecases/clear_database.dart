import 'package:fpdart/fpdart.dart';

import '../repositories/preferences_repository.dart';
import '../types/types.dart';

mixin IClearDatabase {
  Future<EitherUnit> call();
}

class ClearDatabase implements IClearDatabase {
  final IPreferencesRepository respository;

  ClearDatabase(this.respository);

  @override
  Future<EitherUnit> call() async {
    final result = await respository.clearDatabase();
    return result.fold((l) => Left(l), (r) => Right(r));
  }
}
