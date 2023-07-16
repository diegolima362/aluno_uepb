import 'package:dson_adapter/dson_adapter.dart';
import 'package:result_dart/result_dart.dart';

import '../../../../shared/data/types/open_protocol.dart';
import '../../../../shared/data/types/types.dart';
import '../../data/datasources/preferences_local_datasource.dart';

// const _baseUrl = 'http://10.0.2.2:8000';
// const _baseUrl = 'http://192.168.0.106:8000';
const _baseUrl = 'https://hub.362devs.com';

final _mock = <Map<String, dynamic>>[
  {
    'title': 'Mock',
    'authUrl': '$_baseUrl/login',
    'coursesUrl': '$_baseUrl/courses',
    'profileUrl': '$_baseUrl/profile',
    'historyUrl': '$_baseUrl/history',
  },
];

class PreferencesMockRemoteDataSource implements PreferencesRemoteDataSource {
  @override
  AsyncResult<List<OpenProtocolSpec>, AppException> fetchProtocols() async {
    try {
      final data = _mock
          .map((e) =>
              const DSON().fromJson<OpenProtocolSpec>(e, OpenProtocolSpec.new))
          .toList();

      return Success(data);
    } on DSONException catch (e) {
      return Failure(AppException(e.message));
    }
  }
}
