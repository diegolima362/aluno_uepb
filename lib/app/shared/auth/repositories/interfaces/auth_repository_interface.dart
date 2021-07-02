abstract class IAuthRepository {
  Future<Map<String, dynamic>?> getCurrentUser();

  Future<void> clearAuthData();

  Future<void> storeAuthData(Map<String, dynamic> data);
}
