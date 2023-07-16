import 'package:html/parser.dart';
import 'package:result_dart/result_dart.dart';

import '../../../../modules/auth/models/user.dart';
import '../../../../modules/courses/models/models.dart';
import '../../../../modules/profile/models/profile.dart';
import '../../../data/datasources/remote_datasource.dart';
import '../../../data/types/types.dart';
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

  @override
  AsyncResult<User, AppException> signInWithUserAndPassword(
    String user,
    String password,
  ) async {
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

  Future<Result<User, AppException>> refreshAuth() async {
    if (_user == null) {
      return Failure(AppException('Usuário não autenticado.'));
    }

    return await signInWithUserAndPassword(
      _user!.username,
      _user!.password,
    );
  }

  @override
  AsyncResult<Profile, AppException> fetchProfile() async {
    try {
      (await refreshAuth()).fold((success) => null, (failure) => throw failure);

      final response = await client.getResponse(consts.profileURL);

      final redirectedUrl = response.headers['location'];
      if (redirectedUrl == consts.loginURL) {
        return Failure(AppException('Falha ao entrar.'));
      }

      final doc = parse(response.body);

      if (doc.body?.text.contains('Entrar') ?? true) {
        return Failure(AppException('Falha ao entrar, reinicie o app.'));
      }

      return Success(parseProfile(doc));
    } on AppException catch (e) {
      return Failure(e);
    }
  }

  @override
  AsyncResult<List<Course>, AppException> fetchCourses() async {
    try {
      (await refreshAuth()).fold((success) => null, (failure) => throw failure);

      final response = await client.getResponse(consts.rdmURL);

      final redirectedUrl = response.headers['location'];
      if (redirectedUrl == consts.loginURL) {
        return Failure(AppException('Falha ao entrar.'));
      }

      final doc = parse(response.body);

      if (doc.body?.text.contains('Entrar') ?? true) {
        return Failure(AppException('Falha ao entrar, reinicie o app.'));
      }

      if (doc.body?.text.contains(consts.errorAvaliation) ?? false) {
        throw AppException(consts.avaliationMessage);
      }

      return Success(parseCourses(doc));
    } on AppException catch (e) {
      return Failure(e);
    }
  }

  @override
  AsyncResult<List<History>, AppException> fetchHistory() async {
    try {
      final response = await client.getResponse(consts.historyURL);

      final redirectedUrl = response.headers['location'];
      if (redirectedUrl == consts.loginURL) {
        return Failure(AppException('Falha ao entrar.'));
      }

      final doc = parse(response.body);

      if (doc.body?.text.contains('Entrar') ?? true) {
        return Failure(AppException('Falha ao entrar, reinicie o app.'));
      }

      if (doc.body?.text.contains(consts.errorAvaliation) ?? false) {
        throw AppException(consts.avaliationMessage);
      }

      return Success(parseHistory(doc));
    } on AppException catch (e) {
      return Failure(e);
    }
  }
}
