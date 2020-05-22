import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;

class Session {
  static final Session _singleton = Session._internal();

  factory Session() {
    return _singleton;
  }

  Session._internal();

  Map<String, String> _headers = {};

  Future<Document> get(String url) async {
    http.Response response = await http.get(url, headers: _headers);

    if (_headers.isEmpty) {
      updateCookie(response);
    }

    return parse(response.body);
  }

  Future<Document> post(String url, dynamic data) async {
    http.Response response = await http.post(
      url,
      body: data,
      headers: _headers,
    );

    var str = response.body.toString();
    var error1 = '<p>Usuário ou senha não conferem.</p>';
    var error2 = '<p>Matrícula ou senha não conferem.</p>';
    if (str.contains(error1) || str.contains(error2)) {
      throw ('error login');
    }

    return parse(response.body);
  }

  void updateCookie(http.Response response) {
    String rawCookie = response.headers['set-cookie'];
    if (rawCookie != null) {
      _headers['Cookie'] = rawCookie;
    }
  }
}
