import 'package:flutter_triple/flutter_triple.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/external/drivers/fpdart_either_adapter.dart';
import '../../domain/entities/entities.dart';
import '../../domain/errors/errors.dart';
import '../../domain/usecases/usecases.dart';

class ProfileStore
    extends NotifierStore<ProfileFailure, Option<ProfileEntity>> {
  final IGetProfile usecase;

  ProfileStore(this.usecase) : super(none());

  Future<Unit> getData() async {
    executeEither(() => FpdartEitherAdapter.adapter(usecase()));
    return unit;
  }

  Future<Unit> updateData() async {
    update(none());
    setLoading(true);

    executeEither(() => FpdartEitherAdapter.adapter(usecase(cached: false)));

    return unit;
  }
}
