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

const String CACHED_USER = 'CACHED_USER';
const String REFRESH_TOKEN = 'REFRESH_TOKEN';

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences sharedPreferences;

  AuthLocalDataSourceImpl(this.sharedPreferences);

  @override
  Future<void> cacheUser(UserModel user) async {
    try {
      final userJson = user.toJson();
      final jsonString = json.encode(userJson);
      await sharedPreferences.setString(CACHED_USER, jsonString);
    } catch (e) {
      throw Exception('Failed to cache user: $e');
    }
  }

  @override
  Future<UserModel?> getCachedUser() async {
    try {
      final jsonString = sharedPreferences.getString(CACHED_USER);
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
    await sharedPreferences.remove(CACHED_USER);
    await sharedPreferences.remove(REFRESH_TOKEN);
  }

  @override
  Future<void> cacheRefreshToken(String token) async {
    await sharedPreferences.setString(REFRESH_TOKEN, token);
  }

  @override
  Future<String?> getRefreshToken() async {
    return sharedPreferences.getString(REFRESH_TOKEN);
  }
}
