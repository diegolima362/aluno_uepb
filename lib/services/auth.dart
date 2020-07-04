import 'dart:async';

import 'package:erdm/controller/session.dart';
import 'package:erdm/models/user.dart';
import 'package:erdm/services/connection_state.dart';
import 'package:erdm/services/database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

abstract class AuthBase {
  ValueListenable<Box> get onAuthStateChanged;

  Future<User> signInWithUserAndPassword(String user, String password);

  Future<User> currentUser();

  Future<void> signOut();
}

class Auth implements AuthBase {
  @override
  Future<User> signInWithUserAndPassword(String user, String password) async {
    try {
      if (!await CheckConnection.checkCoonection()) {
        throw PlatformException(
            message: 'Sem conexão com a internet', code: 'error_connection');
      }
    } catch (e) {
      rethrow;
    }

    final session = Session();

    final String loginURL =
        "https://academico.uepb.edu.br/ca/index.php/usuario/autenticar";

    Map<String, String> formData = {
      'nome_usuario': user,
      'senha_usuario': password
    };

    try {
      await session.signIn(loginURL, formData);
    } catch (e) {
      rethrow;
    }

    Hive.box(BoxesName.LOGIN_BOX).put('user', {
      'user': user,
      'password': password,
    });

    return currentUser();
  }

  @override
  Future<void> signOut() async {
    await Hive.box(BoxesName.LOGIN_BOX).clear();
    await Hive.box(BoxesName.COURSES_BOX).clear();
  }

  @override
  ValueListenable<Box> get onAuthStateChanged {
    HiveDatabase.initDatabase();
    final isOpen = Hive.isBoxOpen(BoxesName.LOGIN_BOX);
    if (!isOpen) {
      Hive.openBox(BoxesName.LOGIN_BOX);
    }
    return Hive.box(BoxesName.LOGIN_BOX).listenable();
  }

  User _userFromDatabase(Map user) {
    return user == null
        ? null
        : User.fromMap({
            'user': user['user'],
            'password': user['password'],
          });
  }

  @override
  Future<User> currentUser() async {
    final user = await Hive.box(BoxesName.LOGIN_BOX).get('user');
    return _userFromDatabase(user);
  }
}
