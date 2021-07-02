import 'dart:typed_data';

abstract class IRemoteData {
  bool get updatingCourses;

  bool get updatingProfile;

  bool get updatingHistory;

  bool get updatingAllData;

  Future<Map<String, dynamic>?> getAllData();

  Future<Map<String, dynamic>?> getProfile();

  Future<List<Map<String, dynamic>>?> getCourses();

  Future<List<Map<String, dynamic>>?> getHistory();

  Future<Uint8List?> downloadRDM();

  void setAuth(String id, String password);
}
