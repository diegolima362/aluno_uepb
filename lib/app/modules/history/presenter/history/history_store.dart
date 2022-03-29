import 'package:flutter_triple/flutter_triple.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/external/drivers/fpdart_either_adapter.dart';
import '../../domain/entities/entities.dart';
import '../../domain/errors/errors.dart';
import '../../domain/usecases/usecases.dart';

class HistoryStore extends NotifierStore<HistoryFailure, List<HistoryEntity>> {
  final IGetHistory usecase;

  HistoryStore(this.usecase) : super([]);

  Future<Unit> getData() async {
    setLoading(true);

    executeEither(() => FpdartEitherAdapter.adapter(usecase()));
    return unit;
  }

  Future<Unit> updateData() async {
    executeEither(() => FpdartEitherAdapter.adapter(usecase(cached: false)));
    return unit;
  }
}
