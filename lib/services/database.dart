import 'dart:async';

import 'package:erdm/controller/scraper.dart';
import 'package:erdm/models/course.dart';
import 'package:erdm/models/user.dart';
import 'package:erdm/services/connection_state.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:html/dom.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

class BoxesName {
  static const DARK_MODE_BOX = 'themePreference';
  static const LOGIN_BOX = 'login';
  static const COURSES_BOX = 'courses';
}

abstract class Database {
  Future<void> clearData();

  Future<void> clearBox(String boxName);

  ValueListenable coursesStream();

  Stream<Course> courseStream({@required String courseId});

  Future<Box> getRemoteData();

  Future<Box> getLocalData();
}

String documentIdFromCurrentDate() => DateTime.now().toIso8601String();

class HiveDatabase implements Database {
  @override
  Future<void> clearData() async {
    await Hive.box(BoxesName.COURSES_BOX).clear();
    await Hive.box(BoxesName.LOGIN_BOX).clear();
    await Hive.box(BoxesName.DARK_MODE_BOX).clear();
  }

  @override
  Future<void> clearBox(String boxName) async {
    await Hive.box(boxName).clear();
  }

  Future<Box> getRemoteData() async {
    try {
      if (!await CheckConnection.checkCoonection()) {
        throw PlatformException(
          message: 'Sem conexão com a internet',
          code: 'error_connection',
        );
      }
    } catch (e) {
      rethrow;
    }

    final box = Hive.box(BoxesName.COURSES_BOX);
    await box.clear();
    final user = _getCurrentUser();

    // final dom = await requestDOMFake(baseURL: 'http://192.168.0.113:8000');
    List<Document> dom;

    try {
      dom = await requestDOM(user: user.user, password: user.password);
    } catch (e) {
      rethrow;
    }

    if (dom == null) {
      return box;
    }

    List<Course> courses = extractProfile(dom).courses;

    final mapCourses = List<Map<String, dynamic>>();

    courses.forEach((element) {
      mapCourses.add(element.toMap());
    });

    print('> saving data');
    box.put(BoxesName.COURSES_BOX, mapCourses);

    return box;
  }

  User _getCurrentUser() {
    final data = Hive.box(BoxesName.LOGIN_BOX).get('user');
    return _userFromDatabase(data);
  }

  User _userFromDatabase(Map data) =>
      User(user: data['user'], password: data['password']);

  Future<Box> getLocalData() async {
    return Hive.box(BoxesName.COURSES_BOX);
  }

  @override
  Stream<Course> courseStream({@required String courseId}) =>
      Stream.value(Hive.box(BoxesName.COURSES_BOX).get(courseId));

  @override
  ValueListenable coursesStream() =>
      Hive.box(BoxesName.COURSES_BOX).listenable();

  static Future<void> initDatabase() async {
    print('init');
    final appDocumentDirectory =
        await path_provider.getApplicationDocumentsDirectory();

    Hive.init(appDocumentDirectory.path);

    await Hive.openBox(BoxesName.DARK_MODE_BOX);
    await Hive.openBox(BoxesName.LOGIN_BOX);
    await Hive.openBox(BoxesName.COURSES_BOX);
  }
}
