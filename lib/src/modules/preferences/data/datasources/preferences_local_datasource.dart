import 'package:result_dart/result_dart.dart';

import '../../../../shared/domain/models/app_exception.dart';
import '../../../../shared/domain/models/open_protocol.dart';
import '../../models/preferences.dart';

abstract class PreferencesLocalDataSource {
  AsyncResult<Preferences, AppException> load();
  AsyncResult<Preferences, AppException> save(Preferences preferences);
  AsyncResult<Unit, AppException> clear();
}

abstract class PreferencesRemoteDataSource {
  AsyncResult<List<OpenProtocolSpec>, AppException> fetchProtocols();
}
