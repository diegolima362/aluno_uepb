import 'package:aluno_uepb/app/shared/models/profile_model.dart';

abstract class IEventLogger {
  void logEvent(String event);

  void logSignIn();

  Future<void> setData(ProfileModel profile);
}
