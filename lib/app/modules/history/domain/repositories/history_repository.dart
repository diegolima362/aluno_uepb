import '../types/types.dart';

abstract class IHistoryRepository {
  Future<EitherHistory> getHistory({bool cached = true});
}
