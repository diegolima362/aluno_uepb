import 'package:result_dart/result_dart.dart';

import '../../core/exceptions/app_exception.dart';
import '../models/preferences.dart';

abstract class PreferencesRepository {
  AsyncResult<Preferences, AppException> fetchPreferences();

  AsyncResult<Unit, AppException> savePreferences(Preferences data);

  AsyncResult<Unit, AppException> clearPreferences();
}
