import 'package:dio/dio.dart';

abstract class HomeRemoteDataSource {
  Future<void> clockIn();
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final Dio dio;
  HomeRemoteDataSourceImpl(this.dio);

  @override
  Future<void> clockIn() async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
    // Simulate successful clock-in response
    // return;


  }
}