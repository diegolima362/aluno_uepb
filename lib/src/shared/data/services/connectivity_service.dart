import '../../external/interfaces/connectivity_driver.dart';

class ConnectivityService {
  final IConnectivityDriver driver;

  ConnectivityService(this.driver);

  Future<bool> get isOnline async {
    return await driver.isOnline;
  }
}
