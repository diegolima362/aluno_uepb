import 'dart:convert';

import 'package:dson_adapter/dson_adapter.dart';
import 'package:result_dart/result_dart.dart';

import '../../../../modules/auth/models/user.dart';
import '../../../../modules/courses/models/models.dart';
import '../../../../modules/profile/models/profile.dart';
import '../../../data/datasources/remote_datasource.dart';
import '../../../data/types/open_protocol.dart';
import '../../../data/types/types.dart';
import '../../drivers/http_client.dart';

class OpenProtocolRemoteDataSource implements AcademicRemoteDataSource {
  final OpenProtocolSpec protocol;
  final AppHttpClient client;

  User? _user;
  final dson = const DSON();

  OpenProtocolRemoteDataSource(this.client, this.protocol);

  @override
  void setUser(User? user) {
    _user = user;
    if (user == null) {
      client.clearCache();
    }
  }

  @override
  AsyncResult<User, AppException> signInWithUserAndPassword(
    String user,
    String password,
  ) async {
    if (_user != null && await _checkAuth()) {
      return Success(_user!);
    }

    final data = {
      'username': user,
      'password': password,
    };

    final result = await client.post(protocol.authUrl, data);
    final body = jsonDecode(result.body);

    if (result.statusCode != 200) {
      final errorMessage =
          body['message'] ?? body['detail'] ?? 'Falha ao fazer login';
      return Failure(AppException(errorMessage));
    }

    final token = body['access_token'] as String?;
    if (token == null) {
      return Failure(AppException('Falha ao fazer login'));
    }

    client.setHeader('Authorization', 'Bearer $token');

    _user = User(username: user, password: password);

    return Success(_user!);
  }

  Future<bool> _checkAuth() async {
    try {
      final response = await client.getResponse(protocol.profileUrl);

      return response.statusCode == 200;
    } on AppException {
      return false;
    }
  }

  @override
  AsyncResult<Profile, AppException> fetchProfile() async {
    final user = _user;
    if (user == null) {
      return Failure(AppException('Usuário não logado.'));
    }

    try {
      await signInWithUserAndPassword(user.username, user.password);

      final response = await client.getResponse(protocol.profileUrl);

      if (response.statusCode != 200) {
        final body = jsonDecode(response.body);
        final errorMessage =
            body['message'] ?? body['detail'] ?? 'Falha ao fazer login';
        return Failure(AppException(errorMessage));
      }

      final data = jsonDecode(response.body) as Map<String, dynamic>;

      final profile = dson.fromJson(
        data,
        Profile.new,
        inner: {
          'academicIndexes': ListParam<AcademicIndex>(AcademicIndex.new),
        },
      );

      return Success(profile);
    } on DSONException catch (e) {
      return Failure(AppException('Erro ao formatar dados: ${e.message}'));
    } on AppException catch (e) {
      return Failure(e);
    }
  }

  @override
  AsyncResult<List<Course>, AppException> fetchCourses() async {
    final user = _user;
    if (user == null) {
      return Failure(AppException('Usuário não logado.'));
    }

    try {
      await signInWithUserAndPassword(user.username, user.password);

      final response = await client.getResponse(protocol.coursesUrl);

      if (response.statusCode != 200) {
        final body = jsonDecode(response.body);
        final errorMessage =
            body['message'] ?? body['detail'] ?? 'Falha ao fazer login';
        return Failure(AppException(errorMessage));
      }

      final list = jsonDecode(response.body) as List;
      final data = <Course>[];
      for (final item in list) {
        item['professors'] =
            ((item['professors'] ?? []) as List).cast<String>();

        final course = dson.fromJson(
          item,
          Course.new,
          inner: {
            'schedule': ListParam<Schedule>(Schedule.new),
            'grades': ListParam<Grade>(Grade.new),
          },
        );
        data.add(course);
      }

      return Success(data);
    } on DSONException catch (e) {
      return Failure(AppException('Erro ao formatar dados: ${e.message}'));
    } on AppException catch (e) {
      return Failure(e);
    }
  }

  @override
  AsyncResult<List<History>, AppException> fetchHistory() async {
    final user = _user;
    if (user == null) {
      return Failure(AppException('Usuário não logado.'));
    }

    try {
      await signInWithUserAndPassword(user.username, user.password);

      final response = await client.getResponse(protocol.historyUrl);

      if (response.statusCode != 200) {
        final body = jsonDecode(response.body);
        final errorMessage =
            body['message'] ?? body['detail'] ?? 'Falha ao fazer login';
        return Failure(AppException(errorMessage));
      }

      final list = jsonDecode(response.body) as List;
      final data = <History>[];
      for (final item in list) {
        item['professors'] =
            ((item['professors'] ?? []) as List).cast<String>();

        final entry = dson.fromJson(
          item,
          History.new,
        );
        data.add(entry);
      }

      return Success(data);
    } on DSONException catch (e) {
      return Failure(AppException('Erro ao formatar dados: ${e.message}'));
    } on AppException catch (e) {
      return Failure(e);
    }
  }
}
