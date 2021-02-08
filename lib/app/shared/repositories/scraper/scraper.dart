import 'package:aluno_uepb/app/shared/auth/auth_controller.dart';
import 'package:aluno_uepb/app/shared/models/course_model.dart';
import 'package:aluno_uepb/app/shared/models/history_entry_model.dart';
import 'package:aluno_uepb/app/shared/models/profile_model.dart';
import 'package:aluno_uepb/app/shared/models/user_model.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:html/dom.dart';

import 'data_parser.dart';
import 'session.dart';

class Scraper {
  static const BASE_URL = 'https://academico.uepb.edu.br/ca/index.php/alunos';

  // static const BASE_URL = 'http://localhost:8000';

  bool updatingCourses = false;
  bool updatingProfile = false;
  bool updatingHistory = false;
  bool updatingAllData = false;

  String user;
  String password;

  DataParser _parser;

  final String baseURL = "https://academico.uepb.edu.br/ca/index.php/alunos";

  final String loginURL =
      "https://academico.uepb.edu.br/ca/index.php/usuario/autenticar";

  Scraper(this.user, this.password) {
    _parser = DataParser();
  }

  Map<String, String> get formData {
    UserModel _user;

    if (user == null || password == null) {
      _user = Modular.get<AuthController>().user;
      this.user = _user.id;
      this.password = _user.password;
    }

    return {'nome_usuario': user, 'senha_usuario': password};
  }

  Future<Map<String, dynamic>> getAllData() async {
    Map<String, Document> _dom;

    updatingCourses = true;
    updatingProfile = true;
    updatingHistory = true;
    updatingAllData = true;

    try {
      _dom = await _requestDOM();
    } catch (e) {
      updatingCourses = false;
      updatingProfile = false;
      updatingHistory = false;
      updatingAllData = false;
      rethrow;
    }

    if (_dom == null) return null;

    final coursesData = _parser.sanitizeCourses(_dom['courses']);
    final profileData = _parser.sanitizeProfile(_dom);

    final data = {
      'profile': ProfileModel.fromMap(profileData),
      'courses': coursesData.map((map) => CourseModel.fromMap(map)).toList(),
    };

    updatingCourses = false;
    updatingProfile = false;
    updatingHistory = false;
    updatingAllData = false;

    return data;
  }

  Future<List<CourseModel>> getCourses() async {
    if (updatingCourses) {
      print('> Scraper: already updating');
      return null;
    }
    updatingCourses = true;

    Document _dom;

    try {
      _dom = await _requestDOMCourses();
    } catch (e) {
      updatingCourses = false;

      rethrow;
    }

    if (_dom == null) return null;

    final data = _parser.sanitizeCourses(_dom);

    final courses = data.map((map) => CourseModel.fromMap(map)).toList();

    updatingCourses = false;

    return courses;
  }

  Future<List<HistoryEntryModel>> getHistory() async {
    if (updatingHistory) {
      print('> Scraper: already updating');
      return null;
    }
    updatingHistory = true;

    Document _dom;

    try {
      _dom = await _requestDOMHistory();
    } catch (e) {
      updatingHistory = false;
      rethrow;
    }

    if (_dom == null) return null;

    final data = _parser.sanitizeHistory(_dom);

    final history = data.map((map) => HistoryEntryModel.fromMap(map)).toList();

    updatingHistory = false;

    return history;
  }

  Future<ProfileModel> getProfile() async {
    if (updatingProfile) {
      print('> Scraper: already updating');
      return null;
    }

    updatingProfile = true;

    Map<String, Document> _dom;

    try {
      _dom = await _requestDOMProfile();
    } catch (e) {
      updatingProfile = false;
      rethrow;
    }

    if (_dom == null) return null;

    final data = _parser.sanitizeProfile(_dom);

    final profile = ProfileModel.fromMap(data);

    updatingProfile = false;

    return profile;
  }

  Future<Map<String, Document>> _requestDOM() async {
    Session client = Session();

    Document home;
    Document profile;
    Document courses;

    home = await client.get(baseURL + '/index');

    try {
      await client.post(loginURL, formData);
      profile = await client.get(baseURL + '/cadastro');
      home = await client.get(baseURL + '/index');
      courses = await client.get(baseURL + '/rdm');
      client.clean();
    } catch (e) {
      rethrow;
    }

    final data = {
      'home': home,
      'profile': profile,
      'courses': courses,
    };

    return data;
  }

  Future<Document> _requestDOMCourses() async {
    print('> _requestDOMCourses');

    Session client = Session();

    Document rdm;

    // Start cookies
    await client.get(baseURL + '/index');

    try {
      await client.post(loginURL, formData);
      rdm = await client.get(baseURL + '/rdm');
      client.clean();
    } catch (e) {
      rethrow;
    }

    return rdm;
  }

  Future<Document> _requestDOMHistory() async {
    Session client = Session();

    Document history;

    // Start cookies
    await client.get(baseURL + '/index');

    try {
      await client.post(loginURL, formData);
      history = await client.get(baseURL + '/historico');
      client.clean();
    } catch (e) {
      rethrow;
    }

    return history;
  }

  Future<Map<String, Document>> _requestDOMProfile() async {
    Session client = Session();

    Document profile;
    Document home;

    // Start cookies
    await client.get(baseURL + '/index');

    try {
      await client.post(loginURL, formData);

      home = await client.get(BASE_URL + '/index');
      profile = await client.get(BASE_URL + '/cadastro');

      client.clean();
    } catch (e) {
      rethrow;
    }

    final data = {
      'home': home,
      'profile': profile,
    };

    return data;
  }
}
