import 'dart:convert';
import 'package:altahris_mobile/features/home/data/models/employee_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class HomeLocalDataSources {
  Future<void> cacheEmployee(EmployeeModel employee);
  Future<EmployeeModel?> getCachedEmployee();
  Future<void> clearCache();
}

const String cachedEmployee = 'CACHED_EMPLOYEE';

class HomeLocalDataSourcesImpl implements HomeLocalDataSources {
  final SharedPreferences sharedPreferences;

  HomeLocalDataSourcesImpl(this.sharedPreferences);

  @override
  Future<void> cacheEmployee(EmployeeModel employee) async {
    try {
      final employeeJson = employee.toJson();
      final jsonString = json.encode(employeeJson);
      await sharedPreferences.setString(cachedEmployee, jsonString);
    } catch (e) {
      throw Exception('Failed to cache user: $e');
    }
  }

  @override
  Future<EmployeeModel?> getCachedEmployee() async {
    try {
      final jsonString = sharedPreferences.getString(cachedEmployee);
      if (jsonString != null && jsonString.isNotEmpty) {
        final Map<String, dynamic> userMap = json.decode(jsonString);
        return EmployeeModel.fromJson(userMap);
      }
      return null;
    } catch (e) {
      // If data is corrupted, it's better to return null so user can login again
      return null;
    }
  }

  @override
  Future<void> clearCache() async {
    await sharedPreferences.remove(cachedEmployee);
  }
}
