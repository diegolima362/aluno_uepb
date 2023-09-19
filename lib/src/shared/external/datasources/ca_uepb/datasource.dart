import 'package:result_dart/result_dart.dart';

import '../../../../modules/auth/models/user.dart';
import '../../../../modules/courses/models/models.dart';
import '../../../../modules/profile/domain/models/profile.dart';
import '../../../data/datasources/remote_datasource.dart';
import '../../../domain/models/app_exception.dart';
import '../../drivers/http_client.dart';
import 'constants.dart' as consts;
import 'parser.dart';

class CaUepbRemoteDataSource implements AcademicRemoteDataSource {
  //
  final AppHttpClient client;
  User? _user;

  CaUepbRemoteDataSource(this.client);

  @override
  void setUser(User? user) {
    _user = user;
  }

  Future<bool> _checkAuth() async {
    try {
      final response = await client.getResponse(consts.homeURL);
      final redirectedUrl = response.headers['location'];
      return redirectedUrl != consts.loginURL;
    } on AppException {
      return false;
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

    final data = {'nome_usuario': user, 'senha_usuario': password};

    client.clearCache();

    await client.get(consts.loginURL);

    final result = await client.post(consts.loginURL, data);

    final body = result.body;

    final redirectedUrl = result.headers['location'];
    if (redirectedUrl == consts.loginURL) {
      return Failure(AppException('Falha ao entrar.'));
    }

    if (body.contains(consts.error1) || body.contains(consts.error2)) {
      return Failure(AppException('Matrícula ou senha não conferem.'));
    }
    if (body.contains(consts.error3)) {
      return Failure(AppException('Falha ao conectar com servidor.'));
    }

    _user = User(username: user, password: password);

    return Success(_user!);
  }

  Future<Result<User, AppException>> _refreshAuth() async {
    final user = _user;
    if (user == null) {
      return Failure(AppException('Usuário não logado.'));
    }

    return await signInWithUserAndPassword(user.username, user.password);
  }

  @override
  AsyncResult<Profile, AppException> fetchProfile() async {
    return _refreshAuth().then((result) {
      return result.fold(
        (_) async {
          try {
            final response = await client.get(consts.profileURL);
            return Success(parseProfile(response));
          } on AppException catch (e) {
            return Failure(e);
          }
        },
        (err) => Failure(err),
      );
    });
  }

  @override
  AsyncResult<List<Course>, AppException> fetchCourses() async {
    return _refreshAuth().then((result) {
      return result.fold(
        (_) async {
          try {
            final response = await client.get(consts.rdmURL);
            return Success(parseCourses(response));
          } on AppException catch (e) {
            return Failure(e);
          }
        },
        (err) => Failure(err),
      );
    });
  }

  @override
  AsyncResult<List<History>, AppException> fetchHistory() async {
    return _refreshAuth().then((result) {
      return result.fold(
        (_) async {
          try {
            final response = await client.get(consts.historyURL);
            return Success(parseHistory(response));
          } on AppException catch (e) {
            return Failure(e);
          }
        },
        (err) => Failure(err),
      );
    });
  }
}
