import 'package:asp/asp.dart';
import 'package:result_dart/result_dart.dart';

import '../../../../shared/domain/models/app_exception.dart';
import '../models/profile.dart';

// atoms
final profileState = Atom<Profile?>(null);
final profileLoadingState = Atom<bool>(false);
final profileResultState = Atom<Result<String, AppException>?>(null);

// actions
final fetchProfile = Atom.action();
final refreshProfile = Atom.action();

final clearProfileData = Atom.action();

final createSocialProfileAction = Atom.action();
