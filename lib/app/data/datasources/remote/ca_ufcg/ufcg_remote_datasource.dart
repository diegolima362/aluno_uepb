import 'package:collection/collection.dart';
import 'package:result_dart/result_dart.dart';

import '../../../../core/exceptions/app_exception.dart';
import '../../../../interactor/datasources/academic_datasource.dart';
import '../../../../interactor/models/models.dart';
import '../../../services/http_client.dart';
import 'constants.dart' as consts;
import 'parser.dart';

class CaUfcgRemoteDataSource implements AppRemoteDataSource {
  final AppHttpClient client;
  User? _user;

  CaUfcgRemoteDataSource(this.client);

  Future<User> getCurrentUser() async {
    if (_user == null) {
      throw AppException('Usuário não logado.');
    }
    if (!await checkAuth()) {
      return await refreshAuth();
    }
    return _user!;
  }

  @override
  void setToken(String token) {
    _user = User.fromJson(token);
  }

  @override
  void clearToken() {
    _user = null;
  }

  Future<bool> checkAuth() async {
    try {
      final response = await client.get(consts.historyUrl);
      final loginForm = response.getElementById('login_form');

      return loginForm == null;
    } on AppException {
      return false;
    }
  }

  Future<User> refreshAuth() async {
    final user = _user;
    if (user == null) {
      throw AppException('Usuário não logado.');
    }

    return await login(user.username, user.password);
  }

  @override
  Future<User> login(
    String user,
    String password,
  ) async {
    if (_user != null && await checkAuth()) {
      return _user!;
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
      throw AppException('Matrícula ou senha não conferem.');
    } else if (body.contains(consts.antiSpanError)) {
      throw AppException(
        'Não é possível entrar no momento, tente novamente mais tarde.',
        code: 'anti_span',
      );
    } else if (!(await checkAuth())) {
      throw AppException('Erro ao logar.');
    }

    _user = User(username: user, password: password);

    return _user!;
  }

  @override
  Future<Profile> fetchProfile() async {
    await getCurrentUser();

    final response = await client.get(consts.historyUrl);
    return parseProfile(response);
  }

  @override
  Future<List<Course>> fetchCourses() async {
    await getCurrentUser();

    var result = await client.get(consts.rdmUrl);

    final year = result.getElementById('ano')?.attributes['value'];
    final semester = result.getElementById('periodo')?.attributes['value'];

    if (year == null || semester == null) {
      throw AppException('Error getting year and semester');
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
        results[2] as Result<List<HistoryEntry>, AppException>;

    if (absencesResult.isError() ||
        gradesResult.isError() ||
        historyResult.isError()) {
      throw AppException('Erro ao buscar dados.');
    }

    final absences = absencesResult.getOrDefault({});
    final grades = gradesResult.getOrDefault({});
    final history = historyResult.getOrDefault([]);

    final reversed = history.reversed;

    final toReturn = <Course>[];
    for (var course in courses) {
      final h = reversed.firstWhereOrNull(
        (e) => e.code == course.code,
      );

      toReturn.add(course.copyWith(
        absences: absences[course.code]?.$1,
        absenceLimit: absences[course.code]?.$2,
        grades: grades[course.code],
        professors: h?.professors,
      ));
    }

    return toReturn;
  }

  AsyncResult<Map<String, (int, int)>, AppException> getAbsences(
    List<Course> courses,
    String semester,
  ) async {
    final data = <String, (int, int)>{};
    AppException? exception;

    final futures = courses.map((c) async {
      var url = consts.inProgressAbsencesUrl;
      url = url.replaceFirst('{code}', c.code);
      url = url.replaceFirst('{class}', c.classId);
      url = url.replaceFirst('{semester}', semester);
      final response = await client.get(url);

      parseAbsences(response).fold(
        (success) => data[c.code] = success,
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
      url = url.replaceFirst('{code}', c.code);
      url = url.replaceFirst('{class}', c.classId);
      url = url.replaceFirst('{semester}', semester);
      final response = await client.get(url);

      parseGrades(response).fold(
        (success) => data[c.code] = success,
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
  Future<List<HistoryEntry>> fetchHistory() async {
    await getCurrentUser();
    final response = await client.get(consts.historyUrl);
    return parseHistory(response);
  }
}
