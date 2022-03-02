import '../types/types.dart';

abstract class IConnectivityService {
  Future<EitherBool> get isOnline;

  Future<EitherStreamFutureBool> get connectionStream;
}
