import 'package:asp/asp.dart';

import '../models/profile.dart';

// atoms
final profileState = Atom<Profile?>(null);
final profileLoadingState = Atom<bool>(false);

// actions
final fetchProfile = Atom.action();
final refreshProfile = Atom.action();
