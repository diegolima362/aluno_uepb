import '../types/types.dart';

abstract class IConnectivityService {
  Future<EitherConnectivityBool> get isOnline;

  Future<EitherStreamFutureBool> get connectionStream;
}
