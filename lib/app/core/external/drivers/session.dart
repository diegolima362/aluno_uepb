import 'dart:async';
import 'dart:typed_data';

import 'package:fpdart/fpdart.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;

class Session {
  final http.Client client;

  Session(this.client);

  final _headers = <String, String>{};

  bool waiting = false;

  bool _multipleRequest = true;

  void clean() {
    _headers.clear();
  }

  void enableMultipleRequest(bool value) {
    _multipleRequest = value;
  }

  Future<http.Response?> _get(String url) async {
    if (waiting && !_multipleRequest) return null;

    waiting = true;
    final timer = Timer(const Duration(seconds: 45), () => waiting = false);

    final response =
        await client.get(Uri.parse(url), headers: _headers).timeout(
      const Duration(seconds: 30),
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
      return response?.bodyBytes;
    } catch (e) {
      rethrow;
    }
  }

  Future<Option<http.Response>> post(
      String url, Map<String, String> data) async {
    if (waiting) {
      return none();
    }

    waiting = true;

    final timer = Timer(const Duration(seconds: 20), () => waiting = false);

    http.Response response = await client.post(
      Uri.parse(url),
      body: data,
      headers: _headers,
    );

    waiting = false;
    timer.cancel();

    return some(response);
  }

  void updateCookie(http.Response response) {
    final rawCookie = response.headers['set-cookie'];
    if (rawCookie != null) {
      _headers['Cookie'] = rawCookie;
    }
  }
}
