import 'dart:async';
import 'dart:typed_data';

import 'package:aluno_uepb/app/utils/session.dart';
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

      if (!debugMode) await client.post(loginURL, _formData);

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

      client.clean();
    } catch (e) {
      client.clean();
      _setAllWaiting(false);
      rethrow;
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

    print('> _requestFile');
    final client = Session();
    Uint8List? data;

    try {
      // Start cookies
      await client.get(loginURL);

      await client.post(loginURL, _formData);

      data = await client.getBytes(url);

      client.clean();
    } catch (e) {
      client.clean();
      _setAllWaiting(false);
      rethrow;
    }

    return data;
  }

  Future<Document?> _requestDOMCourses() async {
    print('> _requestDOMCourses');
    final client = Session();
    Document? rdm;

    try {
      // Start cookies
      await client.get(_baseURL + '/index');

      if (!debugMode) await client.post(loginURL, _formData);
      rdm = await client.get(_baseURL + '/rdm');
      client.clean();
    } catch (e) {
      client.clean();
      _setAllWaiting(false);
      rethrow;
    }

    return rdm;
  }

  Future<Document?> _requestDOMHistory() async {
    final client = Session();

    Document? history;

    try {
      // Start cookies
      await client.get(_baseURL + '/index');

      if (!debugMode) await client.post(loginURL, _formData);
      history = await client.get(_baseURL + '/historico');
      client.clean();
    } catch (e) {
      client.clean();
      _setAllWaiting(false);
      rethrow;
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

      if (!debugMode) await client.post(loginURL, _formData);

      home = await client.get(_baseURL + '/index');
      profile = await client.get(_baseURL + '/cadastro');

      client.clean();
    } catch (e) {
      client.clean();
      _setAllWaiting(false);
      rethrow;
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
}
