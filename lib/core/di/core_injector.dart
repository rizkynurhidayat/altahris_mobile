import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:altahris_mobile/core/network/dio_client.dart';

/// Dependency Injection for Core Components
///
/// This file registers shared dependencies like Network Clients,
/// Shared Preferences, and other core utilities.
Future<void> initCore(GetIt sl) async {
  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  // Network
  sl.registerLazySingleton(() => DioClient().dio);
}
