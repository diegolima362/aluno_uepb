import '../repositories/history_repository.dart';
import '../types/types.dart';

abstract class IGetHistory {
  Future<EitherHistory> call({bool cached = true});
}

class GetHistory implements IGetHistory {
  final IHistoryRepository repository;

  GetHistory(this.repository);

  @override
  Future<EitherHistory> call({bool cached = true}) async {
    return await repository.getHistory(cached: cached);
  }
}
