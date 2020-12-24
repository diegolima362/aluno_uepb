import 'package:aluno_uepb/app/shared/models/user_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:hive/hive.dart';

abstract class IAuthRepository implements Disposable {
  UserModel get currentUser;

  Future<UserModel> signInWithIdPassword(String id, String password);

  Future<void> signOut();

  Stream<UserModel> get onAuthStateChanged;
}
