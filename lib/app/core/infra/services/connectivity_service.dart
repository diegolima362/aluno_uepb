import 'package:fpdart/fpdart.dart';

import '../../domain/errors/erros.dart';
import '../../domain/services/connectivity_service.dart';
import '../../domain/types/types.dart';
import '../drivers/connectivity_driver.dart';

class ConnectivityService implements IConnectivityService {
  final IConnectivityDriver driver;

  ConnectivityService(this.driver);

  @override
  Future<EitherConnectivityBool> get isOnline async {
    try {
      var check = await driver.isOnline;
      if (check) {
        return const Right(true);
      }
      throw ConnectionError(message: "Você está offline");
    } catch (e) {
      return Left(
        ConnectionError(
          message: "Erro ao recuperar informação de conexão",
        ),
      );
    }
  }

  @override
  Future<EitherStreamFutureBool> get connectionStream async {
    return Right(driver.connectionStream);
  }
}
