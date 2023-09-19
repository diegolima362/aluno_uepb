import 'package:asp/asp.dart';
import 'package:result_dart/result_dart.dart';

import '../../../../shared/data/repositories/social_repository.dart';
import '../../../auth/atoms/auth_atom.dart';
import '../../data/repositories/profile_repository.dart';
import '../atoms/profile_atom.dart';

class ProfileReducer extends Reducer {
  final ProfileRepository _profileRepository;
  final SocialRepository _socialRepository;

  ProfileReducer(this._profileRepository, this._socialRepository) {
    on(() => [fetchProfile], _fetchProfile);
    on(() => [refreshProfile], () => _fetchProfile(true));
    on(() => [clearProfileData], _clearProfileData);
    on(() => [createSocialProfileAction], _createSocialProfile);
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

  void _createSocialProfile() async {
    final profile = profileState.value;
    final user = userState.value;
    if (profile == null || user == null) return;

    profileLoadingState.value = true;
    profileResultState.value = null;
    final result = await _socialRepository.createUser(user);

    result.fold(
      (success) {
        profileState.value = profile.copyWith(socialProfile: true);
        _profileRepository.save(profile.copyWith(socialProfile: true));

        profileResultState.value = const Success('Perfil criado com sucesso!');
      },
      (failure) => profileResultState.value = Failure(failure),
    );

    profileLoadingState.value = false;
  }

  void _clearProfileData() {
    profileState.value = null;
    _profileRepository.clear();
  }
}
