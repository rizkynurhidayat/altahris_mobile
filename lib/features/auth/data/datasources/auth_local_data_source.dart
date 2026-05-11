import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<void> cacheUser(UserModel user);
  Future<UserModel?> getCachedUser();
  Future<void> clearCache();
  Future<void> cacheRefreshToken(String token);
  Future<String?> getRefreshToken();
}

const String cachedUser = 'CACHED_USER';
const String refreshToken = 'REFRESH_TOKEN';

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences sharedPreferences;

  AuthLocalDataSourceImpl(this.sharedPreferences);

  @override
  Future<void> cacheUser(UserModel user) async {
    try {
      final userJson = user.toJson();
      final jsonString = json.encode(userJson);
      await sharedPreferences.setString(cachedUser, jsonString);
    } catch (e) {
      throw Exception('Failed to cache user: $e');
    }
  }

  @override
  Future<UserModel?> getCachedUser() async {
    try {
      final jsonString = sharedPreferences.getString(cachedUser);
      if (jsonString != null && jsonString.isNotEmpty) {
        final Map<String, dynamic> userMap = json.decode(jsonString);
        return UserModel.fromJson(userMap);
      }
      return null;
    } catch (e) {
      // If data is corrupted, it's better to return null so user can login again
      return null;
    }
  }

  @override
  Future<void> clearCache() async {
    await sharedPreferences.remove(cachedUser);
    await sharedPreferences.remove(refreshToken);
  }

  @override
  Future<void> cacheRefreshToken(String token) async {
    await sharedPreferences.setString(refreshToken, token);
  }

  @override
  Future<String?> getRefreshToken() async {
    return sharedPreferences.getString(refreshToken);
  }
}
