import 'package:flutter/foundation.dart';
import 'package:html/parser.dart';

import '../../../../core/exceptions/app_exception.dart';
import '../../../../interactor/datasources/academic_datasource.dart';
import '../../../../interactor/models/models.dart';
import '../../../services/http_client.dart';
import 'constants.dart' as consts;
import 'parser.dart';

class UepbRemoteDatasource implements AppRemoteDataSource {
  final AppHttpClient client;
  User? _user;

  UepbRemoteDatasource(this.client);

  Future<User> get currentUser async {
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
      var homePage = await client.getResponse(consts.baseURL);
      String? sessionUser = homePage.headers['user'];
      return sessionUser != null && sessionUser == _user?.username;
    } catch (e) {
      debugPrint(e.toString());
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
      return _user!;
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
      return throw AppException(errorNote.first.text.trim());
    }

    sessionUser = result.headers['user'];
    if (sessionUser == null || sessionUser != user) {
      throw AppException('Falha ao entrar.');
    }

    homePage = await client.getResponse(consts.baseURL);
    sessionUser = homePage.headers['user'];
    if (sessionUser == null || sessionUser != user) {
      throw AppException('Falha ao entrar.');
    }

    _user = User(username: user, password: password);

    return _user!;
  }

  @override
  Future<Profile> fetchProfile() async {
    final user = await currentUser;

    final url = '${consts.infoUrl}${user.username}/?tab=requisitos';
    final response = await client.get(url);
    return parseProfile(response);
  }

  @override
  Future<List<Course>> fetchCourses() async {
    final user = await currentUser;

    final urlCoursesInfo = '${consts.infoUrl}${user.username}/?tab=boletim';
    final urlSchedule =
        '${consts.infoUrl}${user.username}/?tab=locais_aula_aluno';

    final infoResponse = await client.getResponse(urlCoursesInfo);
    final scheduleResponse = await client.getResponse(urlSchedule);

    final courses = parseCourses(parse(infoResponse.body));
    final scheduleDoc = parseScheduleAndProfessor(parse(scheduleResponse.body));

    final formated = <Course>[];
    for (final course in courses) {
      final data = scheduleDoc[course.code];
      if (data != null) {
        formated.add(course.copyWith(
          professors: data.$1,
          schedule: data.$2,
        ));
      }
    }

    return formated;
  }

  @override
  Future<List<HistoryEntry>> fetchHistory() async {
    final user = await currentUser;

    final url = '${consts.infoUrl}${user.username}/?tab=historico';
    final response = await client.get(url);
    return parseHistory(response);
  }
}
