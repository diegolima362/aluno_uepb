import 'package:asp/asp.dart';
import 'package:result_dart/result_dart.dart';

import '../../core/exceptions/app_exception.dart';
import '../models/profile.dart';

// atoms.dart
final profileState = atom<Profile?>(null);
final profileLoadingState = atom<bool>(false);
final profileResultState = atom<Result<String, AppException>?>(null);

// setters
final setProfileState = atomAction1<Profile?>(
  (set, user) => set<Profile?>(profileState, user),
);

final setProfileLoading = atomAction1<bool>(
  (set, value) => set<bool>(profileLoadingState, value),
);

final setProfileResult = atomAction1<Result<String, AppException>?>(
  (set, result) => set<Result<String, AppException>?>(
    profileResultState,
    result,
  ),
);
