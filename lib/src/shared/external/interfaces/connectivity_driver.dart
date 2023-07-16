abstract class IConnectivityDriver {
  Future<bool> get isOnline;

  Stream<bool> get connectionStream;
}
