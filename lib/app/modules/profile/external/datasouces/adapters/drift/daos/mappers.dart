import 'package:aluno_uepb/app/core/external/drivers/drift_database.dart';

import '../../../../../infra/models/profile_model.dart';

ProfileModel profileFromTable(Profiles profile) {
  return ProfileModel(
    register: profile.register,
    name: profile.name,
    program: profile.program,
    campus: profile.campus,
    cra: profile.cra,
    cumulativeHours: profile.cumulativeHours,
  );
}

ProfilesTableCompanion profileToTable(ProfileModel profile) {
  return ProfilesTableCompanion.insert(
    register: profile.register,
    name: profile.name,
    program: profile.program,
    campus: profile.campus,
    cra: profile.cra,
    cumulativeHours: profile.cumulativeHours,
  );
}
