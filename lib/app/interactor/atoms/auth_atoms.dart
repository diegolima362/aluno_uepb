import 'package:asp/asp.dart';
import 'package:result_dart/result_dart.dart';

import '../../core/exceptions/app_exception.dart';
import '../models/user.dart';

// atoms.dart
final userState = atom<User?>(null);
final authLoadingState = atom<bool>(false);
final authResultState = atom<Result<String, AppException>?>(null);

// selectors

final isLoggedIn = selector<bool>(
  (get) => !get(authLoadingState) && get(userState) != null,
);

// setters
final setUserState = atomAction1<User?>(
  (set, value) => set<User?>(userState, value),
);

final setAuthLoading = atomAction1<bool>(
  (set, value) => set<bool>(authLoadingState, value),
);

final setAuthResult = atomAction1<Result<String, AppException>?>(
  (set, value) => set<Result<String, AppException>?>(authResultState, value),
);
