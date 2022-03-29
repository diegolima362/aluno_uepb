import 'package:aluno_uepb/app/core/external/drivers/drift_database.dart';

import '../../../../../infra/models/user_model.dart';

UserModel userFromTable(User u) {
  return UserModel(
    id: u.id,
    credentials: u.credentials,
  );
}

UsersTableCompanion userToTable(UserModel u) {
  return UsersTableCompanion.insert(
    id: u.id,
    credentials: u.credentials,
  );
}
