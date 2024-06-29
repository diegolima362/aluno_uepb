import 'package:result_dart/result_dart.dart';

import '../../injector.dart';
import '../atoms/profile_atoms.dart';
import '../repositories/profile_repository.dart';

final _repository = injector.get<ProfileRepository>();

Future<void> fetchProfile() async {
  setProfileLoading(true);
  setProfileResult(null);
  setProfileState(null);

  setProfileResult(await _repository.fetchProfile().map(
    (profile) {
      setProfileState(profile);
      return 'Perfil atualizado!';
    },
  ));

  setProfileLoading(false);
}

Future<void> refreshProfile() async {
  setProfileLoading(true);
  setProfileResult(null);
  setProfileState(null);

  setProfileResult(await _repository.refreshProfile().map(
    (profile) {
      setProfileState(profile);
      return 'Perfil atualizado!';
    },
  ));

  setProfileLoading(false);
}

Future<void> clearProfileData() async {
  setProfileLoading(true);
  setProfileState(null);
  setProfileResult(null);
  setProfileLoading(false);
}
