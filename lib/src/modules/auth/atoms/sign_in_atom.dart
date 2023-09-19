// atoms
import 'package:asp/asp.dart';
import 'package:result_dart/result_dart.dart';

import '../../../shared/domain/models/app_exception.dart';
import '../models/user.dart';

final usernameState = Atom<String>('');
final passwordState = Atom<String>('');

final signInLoadingState = Atom<bool>(false);
final signInResultState = Atom<Result<User, AppException>?>(null);

bool get isValid =>
    !signInLoadingState.value &&
    usernameState.value.isNotEmpty &&
    passwordState.value.isNotEmpty;

// actions
final signInAction = Atom.action();
