import '../types/types.dart';

abstract class IProfileRepository {
  Future<EitherProfile> getProfile({bool cached = true});
}
