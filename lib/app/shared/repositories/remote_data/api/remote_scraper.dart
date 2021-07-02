import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;

import '../interfaces/remote_data_interface.dart';

class RemoteScraper implements IRemoteData {
  bool debugMode = false;

  bool _updatingCourses = false;
  bool _updatingProfile = false;
  bool _updatingHistory = false;
  bool _updatingAllData = false;

  String user;
  String password;

  String _baseURL = '';

  RemoteScraper(this.user, this.password) {
    _baseURL = 'http://localhost:8080/$user+$password';
  }

  Future<Map<String, dynamic>?> getAllData() async {
    if (_updatingCourses ||
        _updatingProfile ||
        _updatingHistory ||
        _updatingAllData) {
      print('> Scraper: already updating');
      return null;
    }

    _updatingCourses = true;
    _updatingProfile = true;
    _updatingHistory = true;
    _updatingAllData = true;

    final result = await http.get(Uri.parse(_baseURL + '/all'));
    final data = json.decode(result.body);

    _updatingCourses = false;

    _updatingCourses = false;
    _updatingProfile = false;
    _updatingHistory = false;
    _updatingAllData = false;

    return data;
  }

  Future<List<Map<String, dynamic>>?> getCourses() async {
    if (_updatingCourses) {
      print('> Scraper: already updating');
      return null;
    }
    _updatingCourses = true;
    final result = await http.get(Uri.parse(_baseURL + '/courses'));

    if (result.statusCode != 200) {
      _updatingCourses = false;
      throw ArgumentError(result.body);
    }

    final List<dynamic> data = json.decode(result.body);

    final parsedData = data.map((e) => e as Map<String, dynamic>).toList();

    _updatingCourses = false;

    return parsedData;
  }

  Future<List<Map<String, dynamic>>?> getHistory() async {
    if (_updatingHistory) {
      print('> Scraper: already updating');
      return null;
    }
    _updatingHistory = true;

    final result = await http.get(Uri.parse(_baseURL + '/history'));

    if (result.statusCode != 200) {
      _updatingHistory = false;
      throw ArgumentError(result.body);
    }

    final List<dynamic> data = json.decode(result.body);

    final parsedData = data.map((e) => e as Map<String, dynamic>).toList();

    _updatingHistory = false;

    return parsedData;
  }

  Future<Map<String, dynamic>?> getProfile() async {
    if (_updatingHistory) {
      print('> Scraper: already updating');
      return null;
    }

    _updatingProfile = true;

    final result = await http.get(Uri.parse(_baseURL + '/profile'));

    if (result.statusCode != 200) {
      _updatingProfile = false;
      throw ArgumentError(result.body);
    }

    final data = json.decode(result.body);

    _updatingProfile = false;

    return data;
  }

  bool get updatingAllData => _updatingAllData;

  bool get updatingCourses => _updatingCourses;

  bool get updatingHistory => _updatingHistory;

  bool get updatingProfile => _updatingProfile;

  Future<Uint8List?> downloadRDM() {
    throw UnimplementedError();
  }

  void setAuth(String id, String password) {
    this.user = id;
    this.password = password;
  }
}
