import 'package:asp/asp.dart';

import '../atoms/profile_atom.dart';
import '../data/repositories/profile_repository.dart';

class ProfileReducer extends Reducer {
  final ProfileRepository _profileRepository;

  ProfileReducer(this._profileRepository) {
    on(() => [fetchProfile], _fetchProfile);
    on(() => [refreshProfile], () => _fetchProfile(true));
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
}
