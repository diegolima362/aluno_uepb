import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:http/io_client.dart';

import '../../data/types/types.dart';

class AppHttpClient {
  final IOClient _client;
  final FlutterSecureStorage _storage;
  Function(String? setCookieHeader)? _parseCookie;

  AppHttpClient(this._client, this._storage) {
    loadCookie();
  }

  final _headers = <String, String>{};

  Map<String, String> get headers => _headers;

  Future<http.Response> _get(String url) async {
    try {
      final response = await _client
          .get(
        Uri.parse(url),
        headers: _headers,
      )
          .timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw AppException('Tempo esgotado');
        },
      );

      updateCookie(response);

      return response;
    } on ClientException catch (e) {
      throw AppException(e.message);
    }
  }

  Future<Document> get(String url) async {
    final response = await _get(url);
    return parse(response.body);
  }

  Future<http.Response> getResponse(String url) async {
    return await _get(url);
  }

  Future<Uint8List> getBytes(String url) async {
    final response = await _get(url);
    return response.bodyBytes;
  }

  Future<http.Response> post(String url, Map<String, String> data) async {
    http.Response response = await _client.post(
      Uri.parse(url),
      body: data,
      headers: _headers,
    );

    updateCookie(response);

    return response;
  }

  void updateCookie(http.Response response) {
    final rawCookie = response.headers['set-cookie'];
    final cookie = _parseCookie != null ? _parseCookie!(rawCookie) : rawCookie;
    if (rawCookie != null) {
      _headers['Cookie'] = cookie;
      _saveCookie(cookie);
    }
  }

  void clearCache() {
    _headers.clear();
  }

  void addToHeader(Map<String, String> data) {
    _headers.addAll(data);
  }

  void removeHeader(String key) {
    _headers.remove(key);
  }

  void _saveCookie(String cookie) async {
    await _storage.write(key: 'cookie', value: cookie);
  }

  Future<void> loadCookie() async {
    final cookie = await _storage.read(key: 'cookie');
    if (cookie != null) {
      if (_parseCookie != null) {
        _headers['Cookie'] = _parseCookie!(cookie);
      } else {
        _headers['Cookie'] = cookie;
      }
    }
  }

  void setCookieParser(String Function(String? setCookieHeader) parseCookie) {
    _parseCookie = parseCookie;
  }

  void setHeader(String header, String value) {
    _headers[header] = value;
    if (header == 'Cookie') {
      _saveCookie(value);
    }
  }
}
