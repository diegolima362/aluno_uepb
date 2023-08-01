import 'package:collection/collection.dart';
import 'package:result_dart/result_dart.dart';

import '../../../../modules/auth/models/user.dart';
import '../../../../modules/courses/models/models.dart';
import '../../../../modules/profile/models/profile.dart';
import '../../../data/datasources/remote_datasource.dart';
import '../../../data/types/types.dart';
import '../../drivers/http_client.dart';
import 'constants.dart' as consts;
import 'parser.dart';

class CaUfcgRemoteDataSource implements AcademicRemoteDataSource {
  //
  final AppHttpClient client;
  User? _user;

  CaUfcgRemoteDataSource(this.client);

  @override
  void setUser(User? user) {
    _user = user;
    if (user == null) {
      client.clearCache();
    }
  }

  AsyncResult<User, AppException> _refreshAuth() async {
    final user = _user;
    if (user == null) {
      return Failure(AppException('Usuário não logado.'));
    }

    return await signInWithUserAndPassword(user.username, user.password);
  }

  Future<bool> _checkAuth() async {
    try {
      final response = await client.get(consts.historyUrl);
      final loginForm = response.getElementById('login_form');

      return loginForm == null;
    } on AppException {
      return false;
    }
  }

  @override
  AsyncResult<User, AppException> signInWithUserAndPassword(
    String user,
    String password,
  ) async {
    if (_user != null && await _checkAuth()) {
      return Success(_user!);
    }

    final data = {
      'command': 'AlunoLogin',
      'login': user,
      'senha': password,
    };

    await client.get(consts.baseUrl);

    final result = await client.post(consts.baseUrl, data);

    final body = result.body;

    if (body.contains(consts.wrongCredentialsError)) {
      return Failure(AppException('Matrícula ou senha não conferem.'));
    } else if (body.contains(consts.antiSpanError)) {
      return Failure(AppException(
        'Não é possível entrar no momento, tente novamente mais tarde.',
        code: 'anti_span',
      ));
    } else if (!(await _checkAuth())) {
      return Failure(AppException('Erro ao entrar.'));
    }

    _user = User(username: user, password: password);

    return Success(_user!);
  }

  @override
  AsyncResult<Profile, AppException> fetchProfile() async {
    return _refreshAuth().then((result) {
      return result.fold(
        (_) async {
          try {
            final response = await client.get(consts.historyUrl);
            return Success(parseProfile(response));
          } on AppException catch (e) {
            return Failure(e);
          }
        },
        (err) => Failure(err),
      );
    });
  }

  @override
  AsyncResult<List<Course>, AppException> fetchCourses() async {
    return _refreshAuth().then((result) {
      return result.fold(
        (_) async {
          try {
            var result = await client.get(consts.rdmUrl);

            final year = result.getElementById('ano')?.attributes['value'];
            final semester =
                result.getElementById('periodo')?.attributes['value'];

            if (year == null || semester == null) {
              return Failure(AppException('Error getting year and semester'));
            }

            final url = consts.scheduleUrl
                .replaceFirst('{year}', year)
                .replaceFirst('{semester}', semester);

            result = await client.get(url);

            final courses = parseCourses(result);

            final futureAbsences = getAbsences(courses, '$year.$semester');
            final futureGrades = getGrades(courses, '$year.$semester');
            final futureHistory = fetchHistory();

            final results = await Future.wait([
              futureAbsences,
              futureGrades,
              futureHistory,
            ]);

            final absencesResult =
                results[0] as Result<Map<String, (int, int)>, AppException>;
            final gradesResult =
                results[1] as Result<Map<String, List<Grade>>, AppException>;
            final historyResult =
                results[2] as Result<List<History>, AppException>;

            if (absencesResult.isError() ||
                gradesResult.isError() ||
                historyResult.isError()) {
              return Failure(AppException('Erro ao consultar dados.'));
            }

            final absences = absencesResult.getOrDefault({});
            final grades = gradesResult.getOrDefault({});
            final history = historyResult.getOrDefault([]);

            final reversed = history.reversed;

            final toReturn = <Course>[];
            for (var course in courses) {
              final h = reversed.firstWhereOrNull(
                (e) => e.code == course.courseCode,
              );

              toReturn.add(course.copyWith(
                absences: absences[course.courseCode]?.$1,
                absenceLimit: absences[course.courseCode]?.$2,
                grades: grades[course.courseCode],
                professors: h?.professors,
              ));
            }

            return Success(toReturn);
          } on AppException catch (e) {
            return Failure(e);
          }
        },
        (err) => Failure(err),
      );
    });
  }

  AsyncResult<Map<String, (int, int)>, AppException> getAbsences(
    List<Course> courses,
    String semester,
  ) async {
    final data = <String, (int, int)>{};
    AppException? exception;

    final futures = courses.map((c) async {
      var url = consts.inProgressAbsencesUrl;
      url = url.replaceFirst('{code}', c.courseCode);
      url = url.replaceFirst('{class}', c.classId);
      url = url.replaceFirst('{semester}', semester);
      final response = await client.get(url);

      parseAbsences(response).fold(
        (success) => data[c.courseCode] = success,
        (failure) => exception = failure,
      );
    });

    await Future.wait(futures);

    if (exception != null) {
      return Failure(exception!);
    }

    return Success(data);
  }

  AsyncResult<Map<String, List<Grade>>, AppException> getGrades(
    List<Course> courses,
    String semester,
  ) async {
    final data = <String, List<Grade>>{};
    AppException? exception;

    final futures = courses.map((c) async {
      var url = consts.inProgressGradesUrl;
      url = url.replaceFirst('{code}', c.courseCode);
      url = url.replaceFirst('{class}', c.classId);
      url = url.replaceFirst('{semester}', semester);
      final response = await client.get(url);

      parseGrades(response).fold(
        (success) => data[c.courseCode] = success,
        (failure) => exception = failure,
      );
    });

    await Future.wait(futures);

    if (exception != null) {
      return Failure(exception!);
    }

    return Result.success(data);
  }

  @override
  AsyncResult<List<History>, AppException> fetchHistory() async {
    return _refreshAuth().then((result) {
      return result.fold(
        (_) async {
          try {
            final response = await client.get(consts.historyUrl);
            return Success(parseHistory(response));
          } on AppException catch (e) {
            return Failure(e);
          }
        },
        (err) => Failure(err),
      );
    });
  }
}
