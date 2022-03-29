import '../repositories/academic_repository.dart';
import '../types/types.dart';

abstract class IGetProfile {
  Future<EitherProfile> call({bool cached = true});
}

class GetProfile implements IGetProfile {
  final IProfileRepository repository;

  GetProfile(this.repository);

  @override
  Future<EitherProfile> call({bool cached = true}) async {
    return await repository.getProfile(cached: cached);
  }
}
