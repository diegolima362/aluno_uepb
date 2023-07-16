import 'package:result_dart/result_dart.dart';

import '../../../modules/auth/models/user.dart';
import '../../../modules/courses/models/course.dart';
import '../../../modules/courses/models/history.dart';
import '../../../modules/profile/models/profile.dart';
import '../types/types.dart';

abstract class AcademicRemoteDataSource {
  void setUser(User? user);

  AsyncResult<User, AppException> signInWithUserAndPassword(
    String user,
    String password,
  );

  AsyncResult<Profile, AppException> fetchProfile();

  AsyncResult<List<Course>, AppException> fetchCourses();

  AsyncResult<List<History>, AppException> fetchHistory();
}

class GenericAcadamicRemoteDataSource implements AcademicRemoteDataSource {
  AcademicRemoteDataSource? _implementation;

  void setImplementation(AcademicRemoteDataSource? implementation) {
    _implementation = implementation;
  }

  @override
  AsyncResult<List<Course>, AppException> fetchCourses() async {
    if (_implementation != null) {
      return _implementation!.fetchCourses();
    }
    return Failure(AppException('Não implementado.'));
  }

  @override
  AsyncResult<List<History>, AppException> fetchHistory() async {
    if (_implementation != null) {
      return _implementation!.fetchHistory();
    }
    return Failure(AppException('Não implementado.'));
  }

  @override
  AsyncResult<Profile, AppException> fetchProfile() async {
    if (_implementation != null) {
      return _implementation!.fetchProfile();
    }
    return Failure(AppException('Não implementado.'));
  }

  @override
  void setUser(User? user) {
    if (_implementation != null) {
      _implementation!.setUser(user);
    }
  }

  @override
  AsyncResult<User, AppException> signInWithUserAndPassword(
    String user,
    String password,
  ) async {
    if (_implementation != null) {
      return _implementation!.signInWithUserAndPassword(user, password);
    }
    return Failure(AppException('Não implementado.'));
  }
}
