import 'package:drift/drift.dart';

import '../../../../infra/models/preferences_model.dart';
import 'drift_database.dart';

PreferencesModel prefsFromTable(Preference p) {
  return PreferencesModel(
    themeIndex: p.themeIndex,
    allowAutoDownload: p.allowAutoDownload,
    allowNotifications: p.allowNotifications,
  );
}

PreferencesTableCompanion prefsToTable(PreferencesModel p) {
  return PreferencesTableCompanion.insert(
    themeIndex: p.themeIndex,
    allowAutoDownload: Value(p.allowAutoDownload),
    allowNotifications: Value(p.allowNotifications),
  );
}
