import 'package:asp/asp.dart';

import '../atoms/profile_atom.dart';
import '../data/repositories/profile_repository.dart';

class ProfileReducer extends Reducer {
  final ProfileRepository _profileRepository;

  ProfileReducer(this._profileRepository) {
    on(() => [fetchProfile], _fetchProfile);
    on(() => [refreshProfile], () => _fetchProfile(true));
    on(() => [clearProfileData], _clearProfileData);
  }

  void _fetchProfile([bool refresh = false]) async {
    profileLoadingState.value = true;
    final result = await _profileRepository.getProfile(refresh);

    result.fold(
      (success) => profileState.value = success,
      (failure) => null,
    );

    profileLoadingState.value = false;
  }

  void _clearProfileData() {
    profileState.value = null;
    _profileRepository.clear();
  }
}
