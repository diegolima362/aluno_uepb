import 'package:html/parser.dart';
import 'package:result_dart/result_dart.dart';

import '../../../../modules/auth/models/user.dart';
import '../../../../modules/courses/models/models.dart';
import '../../../../modules/profile/models/profile.dart';
import '../../../data/datasources/remote_datasource.dart';
import '../../../data/types/types.dart';
import '../../drivers/http_client.dart';
import 'constants.dart' as consts;
import 'parser.dart';

class SuapUpebRemoteDataSource implements AcademicRemoteDataSource {
  final AppHttpClient client;
  User? _user;

  SuapUpebRemoteDataSource(this.client);

  @override
  void setUser(User? user) {
    _user = user;
  }

  @override
  AsyncResult<User, AppException> signInWithUserAndPassword(
    String user,
    String password,
  ) async {
    final data = {
      'username': user,
      'password': password,
      'this_is_the_login_form': '1',
    };

    client
      ..clearCache()
      ..setCookieParser(parseCookie)
      ..loadCookie();

    var homePage = await client.getResponse(consts.baseURL);
    String? sessionUser = homePage.headers['user'];
    if (sessionUser != null && sessionUser == user) {
      _user = User(username: user, password: password);
      return Success(_user!);
    }

    client
      ..clearCache()
      ..addToHeader({
        'Referer': 'https://suap.uepb.edu.br/accounts/login/',
        'Origin': 'https://suap.uepb.edu.br',
        'referrer-policy': 'same-origin',
      });

    final loginPage = await client.get(consts.loginURL);

    final inputElement =
        loginPage.querySelector('input[name="csrfmiddlewaretoken"]');

    final csrfToken = inputElement?.attributes['value'];

    data['csrfmiddlewaretoken'] = csrfToken ?? '';

    final result = await client.post(consts.loginURL, data);

    final body = parse(result.body);
    final errorNote = body.getElementsByClassName('errornote');

    if (errorNote.isNotEmpty) {
      var errorMessage = errorNote.first.text.replaceAll('  ', ' ').trim();
      if (errorMessage.toLowerCase().contains('captcha')) {
        errorMessage =
            'Usuário bloqueado. Acesse o portal pelo navegador para desbloqueio.';
      }
      return Failure(AppException(errorNote.first.text.trim()));
    }

    sessionUser = result.headers['user'];
    if (sessionUser == null || sessionUser != user) {
      return Failure(AppException('Falha ao entrar.'));
    }

    homePage = await client.getResponse(consts.baseURL);
    sessionUser = homePage.headers['user'];
    if (sessionUser == null || sessionUser != user) {
      return Failure(AppException('Falha ao entrar.'));
    }

    _user = User(username: user, password: password);

    return Success(_user!);
  }

  @override
  AsyncResult<Profile, AppException> fetchProfile() async {
    try {
      final user = _user;
      if (user == null) {
        return Failure(AppException('Usuário não logado.'));
      }

      await signInWithUserAndPassword(user.username, user.password);

      final url = '${consts.infoUrl}${user.username}/?tab=requisitos';

      final response = await client.getResponse(url);

      final redirectedUrl = response.headers['location'];
      if (redirectedUrl == consts.loginURL) {
        return Failure(AppException('Falha ao entrar.'));
      }

      final doc = parse(response.body);

      if (doc.body?.text.contains('Entrar') ?? true) {
        return Failure(AppException('Falha ao entrar, reinicie o app.'));
      }

      return Success(parseProfile(doc));
    } on AppException catch (e) {
      return Failure(e);
    }
  }

  @override
  AsyncResult<List<Course>, AppException> fetchCourses() async {
    final user = _user;
    if (user == null) {
      return Failure(AppException('Usuário não logado.'));
    }
    await signInWithUserAndPassword(user.username, user.password);

    try {
      final urlCoursesInfo = '${consts.infoUrl}${user.username}/?tab=boletim';
      final urlSchedule =
          '${consts.infoUrl}${user.username}/?tab=locais_aula_aluno';

      final infoResponse = await client.getResponse(urlCoursesInfo);
      final scheduleResponse = await client.getResponse(urlSchedule);

      if (infoResponse.headers['location'] == consts.loginURL ||
          infoResponse.headers['user'] != user.username ||
          scheduleResponse.headers['location'] == consts.loginURL ||
          scheduleResponse.headers['user'] != user.username) {
        return Failure(AppException('Falha ao entrar.'));
      }

      final courses = parseCourses(parse(infoResponse.body));
      final scheduleDoc =
          parseScheduleAndProfessor(parse(scheduleResponse.body));

      final formated = <Course>[];
      for (final course in courses) {
        final data = scheduleDoc[course.courseCode];
        if (data != null) {
          formated.add(course.copyWith(
            professors: data.$1,
            schedule: data.$2,
          ));
        }
      }

      return Success(formated);
    } on AppException catch (e) {
      return Failure(e);
    }
  }

  @override
  AsyncResult<List<History>, AppException> fetchHistory() async {
    final user = _user;
    if (user == null) {
      return Failure(AppException('Usuário não logado.'));
    }
    await signInWithUserAndPassword(user.username, user.password);

    try {
      final url = '${consts.infoUrl}${user.username}/?tab=historico';

      final response = await client.getResponse(url);

      final redirectedUrl = response.headers['location'];
      final sessionUser = response.headers['user'];
      if (sessionUser != user.username || redirectedUrl == consts.loginURL) {
        return Failure(AppException('Falha ao entrar.'));
      }

      final doc = parse(response.body);

      return Success(parseHistory(doc));
    } on AppException catch (e) {
      return Failure(e);
    }
  }
}
