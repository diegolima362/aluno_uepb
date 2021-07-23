import 'dart:async';
import 'dart:typed_data';

import 'package:aluno_uepb/app/utils/session.dart';
import 'package:flutter/services.dart';
import 'package:html/dom.dart';

import '../interfaces/remote_data_interface.dart';
import 'data_parser.dart';

class Scraper implements IRemoteData {
  bool debugMode = false;

  bool _updatingCourses = false;
  bool _updatingProfile = false;
  bool _updatingHistory = false;
  bool _updatingAllData = false;

  String user;
  String password;

  final DataParser _parser = DataParser();

  String _baseURL = '';

  final String loginURL =
      'https://academico.uepb.edu.br/ca/index.php/usuario/autenticar';

  Scraper({this.user = '', this.password = '', this.debugMode = false}) {
    _baseURL = debugMode
        ? 'http://192.168.0.111:8000'
        : 'https://academico.uepb.edu.br/ca/index.php/alunos';
  }

  void setAuth(String id, String password) {
    this.user = id;
    this.password = password;
  }

  Map<String, String> get _formData {
    return {'nome_usuario': user, 'senha_usuario': password};
  }

  Future<Map<String, dynamic>> getAllData() async {
    Map<String, Document?> _dom;
    _setAllWaiting(true);

    try {
      _dom = await _requestDOM();
    } catch (e) {
      _setAllWaiting(false);
      rethrow;
    }

    final data = <String, dynamic>{};

    if (_dom['courses'] != null) {
      final courses = _parser.sanitizeCourses(_dom['courses']!);
      data['courses'] = courses;
    }

    if (_dom['profile'] != null && _dom['home'] != null) {
      final profile = _parser.sanitizeProfile(_dom);
      data['profile'] = profile;
    }

    _setAllWaiting(false);
    return data;
  }

  Future<List<Map<String, dynamic>>?> getCourses() async {
    if (_updatingCourses) {
      print('> Scraper: already updating');
      _startTimer();
      return null;
    }
    _updatingCourses = true;

    Document? _dom;

    try {
      _dom = await _requestDOMCourses();
    } catch (e) {
      _setAllWaiting(false);
      rethrow;
    }

    try {
      if (_dom == null) return null;
      final data = _parser.sanitizeCourses(_dom);
      _updatingCourses = false;
      return data;
    } catch (e) {
      _setAllWaiting(false);
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>?> getHistory() async {
    if (_updatingHistory) {
      print('> Scraper: already updating');
      _startTimer();
      return null;
    }
    _updatingHistory = true;

    Document? _dom;

    try {
      _dom = await _requestDOMHistory();
    } catch (e) {
      _setAllWaiting(false);
      rethrow;
    }

    if (_dom == null) return null;

    final data = _parser.sanitizeHistory(_dom);

    _updatingHistory = false;

    return data;
  }

  Future<Map<String, dynamic>?> getProfile() async {
    if (_updatingProfile) {
      print('> Scraper: already updating');
      _startTimer();
      return null;
    }

    _updatingProfile = true;

    Map<String, Document?>? _dom;

    try {
      _dom = await _requestDOMProfile();
    } catch (e) {
      _setAllWaiting(false);
      rethrow;
    }

    if (_dom.isEmpty) return null;

    final data = _parser.sanitizeProfile(_dom);

    _updatingProfile = false;

    return data;
  }

  Future<Map<String, Document?>> _requestDOM() async {
    final client = Session();

    Document? home;
    Document? profile;
    Document? courses;

    try {
      home = await client.get(_baseURL + '/index');

      if (!debugMode) {
        final response = await client.post(loginURL, _formData);
        if (response != null) _checkAuth(response.body.toString());
      }

      client.enableMultipleRequest(true);
      final data = await Future.wait([
        client.get(_baseURL + '/cadastro'),
        client.get(_baseURL + '/index'),
        client.get(_baseURL + '/rdm'),
      ]);
      client.enableMultipleRequest(true);

      profile = data[0];
      home = data[1];
      courses = data[2];
    } catch (e) {
      rethrow;
    } finally {
      client.clean();
      _setAllWaiting(false);
    }

    final data = <String, Document?>{
      if (home != null) 'home': home,
      if (profile != null) 'profile': profile,
      if (courses != null) 'courses': courses,
    };

    return data;
  }

  Future<Uint8List?> downloadRDM() async {
    final url = 'https://academico.uepb.edu.br/ca/index.php/alunos/imprimirRDM';

    // final url = _baseURL + '/print/rdm.pdf';

    final client = Session();
    Uint8List? data;

    try {
      // Start cookies
      await client.get(loginURL);
      if (!debugMode) {
        final response = await client.post(loginURL, _formData);
        if (response != null) _checkAuth(response.body.toString());
      }

      data = await client.getBytes(url);
    } catch (e) {
      rethrow;
    } finally {
      client.clean();
      _setAllWaiting(false);
    }

    return data;
  }

  Future<Document?> _requestDOMCourses() async {
    final client = Session();
    Document? rdm;

    try {
      // Start cookies
      await client.get(_baseURL + '/index');
      if (!debugMode) {
        final response = await client.post(loginURL, _formData);
        if (response != null) _checkAuth(response.body.toString());
      }

      rdm = await client.get(_baseURL + '/rdm');
    } catch (e) {
      rethrow;
    } finally {
      client.clean();
      _setAllWaiting(false);
    }

    return rdm;
  }

  Future<Document?> _requestDOMHistory() async {
    final client = Session();

    Document? history;

    try {
      // Start cookies
      await client.get(loginURL);
      if (!debugMode) {
        final response = await client.post(loginURL, _formData);
        if (response != null) _checkAuth(response.body.toString());
      }

      history = await client.get(_baseURL + '/historico');
    } catch (e) {
      rethrow;
    } finally {
      client.clean();
      _setAllWaiting(false);
    }

    return history;
  }

  Future<Map<String, Document?>> _requestDOMProfile() async {
    final client = Session();

    Document? profile;
    Document? home;

    try {
      // Start cookies
      await client.get(_baseURL + '/index');

      if (!debugMode) {
        final response = await client.post(loginURL, _formData);
        if (response != null) _checkAuth(response.body.toString());
      }

      home = await client.get(_baseURL + '/index');
      profile = await client.get(_baseURL + '/cadastro');
    } catch (e) {
      rethrow;
    } finally {
      client.clean();
      _setAllWaiting(false);
    }

    final data = {
      'home': home,
      'profile': profile,
    };

    return data;
  }

  void _setAllWaiting(bool val) {
    _updatingCourses = val;
    _updatingProfile = val;
    _updatingHistory = val;
    _updatingAllData = val;
  }

  bool get updatingAllData => _updatingAllData;

  bool get updatingCourses => _updatingCourses;

  bool get updatingHistory => _updatingHistory;

  bool get updatingProfile => _updatingProfile;

  void _startTimer() {
    print('Scraper > starting timer to avoid lock scraper');
    Timer(Duration(seconds: 20), () {
      print('> Session: timeout');
      _setAllWaiting(false);
      return null;
    });
  }

  Future<void> _checkAuth(String str) async {
    final error1 = '<p>Usuário ou senha não conferem.</p>';
    final error2 = '<p>Matrícula ou senha não conferem.</p>';
    final error3 = '<p>Erro inesperado na autenticação do aluno.</p>';

    if (str.contains(error1) || str.contains(error2) || str.contains(error3)) {
      throw PlatformException(
          message: 'Matrícula ou senha não conferem', code: 'error_login');
    }
  }
}
