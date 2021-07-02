import 'dart:async';
import 'dart:typed_data';

import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;

class Session {
  static final Session _singleton = Session._internal();

  Map<String, String> _headers = {};

  bool waiting = false;

  bool multipleRequest = false;

  factory Session() => _singleton;

  Session._internal();

  void clean() {
    _headers.clear();
  }

  void enableMultipleRequest(bool value) {
    multipleRequest = value;
  }

  Future<http.Response?> _get(String url) async {
    if (waiting && !multipleRequest) return null;

    waiting = true;
    final timer = Timer(Duration(seconds: 45), () {
      print('> Session: timeout');
      waiting = false;
      return null;
    });

    http.Response response =
        await http.get(Uri.parse(url), headers: _headers).timeout(
      Duration(seconds: 30),
      onTimeout: () {
        waiting = false;
        throw TimeoutException('Controle Acadêmico indisponivel');
      },
    );

    if (_headers.isEmpty) {
      updateCookie(response);
    }

    waiting = false;
    timer.cancel();

    return response;
  }

  Future<Document?> get(String url) async {
    try {
      final response = await _get(url);
      return response == null ? null : parse(response.body);
    } catch (e) {
      rethrow;
    }
  }

  Future<Uint8List?> getBytes(String url) async {
    try {
      final response = await _get(url);
      return response == null ? null : response.bodyBytes;
    } catch (e) {
      rethrow;
    }
  }

  Future<Document?> post(String url, Map<String, String> data) async {
    if (waiting) {
      print('> Client: waiting another request');
      return null;
    }

    waiting = true;

    final timer = Timer(Duration(seconds: 20), () {
      print('> Session: timeout');
      waiting = false;
      return null;
    });

    http.Response response = await http.post(
      Uri.parse(url),
      body: data,
      headers: _headers,
    );

    waiting = false;
    timer.cancel();

    return parse(response.body);
  }

  void updateCookie(http.Response response) {
    final rawCookie = response.headers['set-cookie'];
    if (rawCookie != null) {
      _headers['Cookie'] = rawCookie;
    }
  }
}
