import '../models/models.dart';

abstract class AppRemoteDataSource {
  void setToken(String token);

  void clearToken();

  Future<User> login(String username, String password);

  Future<List<Course>> fetchCourses();

  Future<List<HistoryEntry>> fetchHistory();

  Future<Profile> fetchProfile();
}

abstract class AppLocalDataSource {
  Future<void> cacheCourses(List<Course> data);

  Future<void> cacheHistory(List<HistoryEntry> data);

  Future<void> cacheProfile(Profile data);

  Future<void> cachePreferences(Preferences data);

  Future<List<Course>> fetchCourses();

  Future<Course?> fetchCourse(String code);

  Future<List<HistoryEntry>> fetchHistory();

  Future<Profile?> fetchProfile();

  Future<Preferences?> fetchPreferences();

  Future<void> clearData();

  Future<void> clearCourses();

  Future<void> clearHistory();

  Future<void> clearProfile();

  Future<void> clearPreferences();
}

abstract class AuthLocalDataSource {
  Future<String?> fetchToken();

  Future<void> cacheToken(String token);

  Future<void> clearToken();
}
