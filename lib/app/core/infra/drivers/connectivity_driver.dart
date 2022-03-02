abstract class IConnectivityDriver {
  Future<bool> get isOnline;

  Stream<Future<bool>> get connectionStream;
}
