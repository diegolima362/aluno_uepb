import 'dart:async';

import 'package:flutter/services.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;

class Session {
  static final Session _singleton = Session._internal();

  Map<String, String> _headers = {};

  bool waiting = false;

  factory Session() => _singleton;

  Session._internal();

  void clean() {
    _headers.clear();
  }

  Future<Document> get(String url) async {
    if (waiting) return null;

    waiting = true;
    final timer = Timer(Duration(seconds: 20), () {
      print('> Session: timeout');
      return waiting = false;
    });

    http.Response response = await http.get(url, headers: _headers);
    if (_headers.isEmpty) {
      updateCookie(response);
    }

    waiting = false;
    timer.cancel();

    return parse(response.body);
  }

  Future<Document> post(String url, Map<String, String> data) async {
    if (waiting) {
      print('> Client: waiting another request');
      return null;
    }

    waiting = true;

    final timer = Timer(Duration(seconds: 20), () {
      print('> Session: timeout');
      return waiting = false;
    });

    http.Response response = await http.post(
      url,
      body: data,
      headers: _headers,
    );

    final str = response.body.toString();

    final error1 = '<p>Usuário ou senha não conferem.</p>';
    final error2 = '<p>Matrícula ou senha não conferem.</p>';

    if (str.contains(error1) || str.contains(error2)) {
      waiting = false;

      throw PlatformException(
          message: 'Matrícula ou senha não conferem', code: 'error_login');
    }

    waiting = false;
    timer.cancel();

    return parse(response.body);
  }

  void updateCookie(http.Response response) {
    String rawCookie = response.headers['set-cookie'];
    if (rawCookie != null) {
      _headers['Cookie'] = rawCookie;
    }
  }
}
