import 'package:aluno_uepb/app/shared/auth/auth_controller.dart';
import 'package:aluno_uepb/app/shared/models/models.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'interfaces/data_repository_interface.dart';
import 'session.dart';

class DataRepository implements IDataRepository {
  static const BASE_URL = 'http://10.0.2.2:8000';

  UserModel _user;

  DataRepository() {
    _user = Modular.get<AuthController>().user;
  }

  Future<void> printData() async {
    Session client = Session();
    final result = await client.get(BASE_URL + '/home');

    print(result);
  }

  getData(UserModel user, String dataType) {
    final id = user.id;
    final password = user.password;

    String data;

    if (dataType == 'profile')
      data = _getProfileData(id, password);
    else if (dataType == 'courses')
      data = _getCoursesData(id, password);
    else
      data = _getAllData(id, password);

    if (data != null) {
      final response = {'Message': data, 'Status Code': 200};
      return response;
    } else {
      final response = {
        'Message': 'Matrícula ou senha não conferem',
        'Status Code': 401
      };
      return response;
    }
  }

  String _getProfileData(String id, String password) {
    return 'a';
  }

  String _getCoursesData(String id, String password) {
    return 'b';
  }

  String _getAllData(String id, String password) {
    return 'c';
  }

  @override
  Future<List<CourseModel>> getCourses() {
    throw UnimplementedError();
  }

  @override
  Future<ProfileModel> getProfile() async {
    print('DataRepository: get profile data');
    return ProfileModel('name', 'register');
  }

  @override
  void dispose() {}
}
