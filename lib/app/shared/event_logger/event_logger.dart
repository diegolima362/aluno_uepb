import 'package:aluno_uepb/app/shared/event_logger/interfaces/event_logger_interface.dart';
import 'package:aluno_uepb/app/shared/models/profile_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diacritic/diacritic.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

class EventLogger implements IEventLogger {
  FirebaseAnalytics _manager = FirebaseAnalytics();

  void logEvent(String event) {
    _manager
        .logEvent(name: event)
        .then((value) => print('> EventLogger : $event'))
        .catchError((e) => print('> EventLogger : $e'));
  }

  @override
  void logSignIn() {
    _manager
        .logSignUp(signUpMethod: 'signInWithIdPassword')
        .then((value) => print('> EventLogger : logSignIn'));
  }

  Future<void> setData(ProfileModel profile) async {
    final ref = FirebaseFirestore.instance.doc(_path(profile));
    return ref.set(profile.toMapDB()).then((value) {
      print('> EventLogger : profile synced');
    }).catchError((error) {
      print('> EventLogger : error =  $error');
    });
  }

  static String _path(ProfileModel profile) {
    final campus =
        removeDiacritics(profile.campus).toLowerCase().replaceAll(' ', '-');
    final register = profile.register;
    final building =
        removeDiacritics(profile.building).toLowerCase().split(' ');
    final program =
        removeDiacritics(profile.program).toLowerCase().replaceAll(' ', '-');

    final buffer = StringBuffer();

    building.forEach((e) {
      if (e.length > 2) buffer.write(e[0]);
    });

    return "users/$campus/building/${buffer.toString()}/$program/$register/";
  }
}
