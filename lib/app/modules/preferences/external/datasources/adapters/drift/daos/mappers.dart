import 'package:aluno_uepb/app/core/external/drivers/drift_database.dart';
import 'package:drift/drift.dart';

import '../../../../../infra/models/preferences_model.dart';

PreferencesModel prefsFromTable(Preferences p) {
  return PreferencesModel(
    themeIndex: p.themeIndex,
    allowAutoDownload: p.allowAutoDownload,
    allowNotifications: p.allowNotifications,
    seedColor: p.seedColor,
  );
}

PreferencesTableCompanion prefsToTable(PreferencesModel p) {
  return PreferencesTableCompanion.insert(
    themeIndex: p.themeIndex,
    allowAutoDownload: Value(p.allowAutoDownload),
    allowNotifications: Value(p.allowNotifications),
    seedColor: p.seedColor,
  );
}
