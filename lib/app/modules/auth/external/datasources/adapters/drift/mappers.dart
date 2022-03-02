import '../../../../infra/models/user_model.dart';
import 'drift_database.dart';

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
