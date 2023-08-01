import 'package:asp/asp.dart';

import '../models/user.dart';

// atoms
final userState = Atom<User?>(null);

// actions
final fetchCurrentUser = Atom.action();
final signOutAction = Atom.action();
final resetAuthAction = Atom.action();
