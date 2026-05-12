import 'package:dio/dio.dart';
import '../../../../core/error/failures.dart';
import '../models/visit_model.dart';

abstract class VisitRemoteDataSource {
  Future<VisitModel> startVisit(Map<String, dynamic> data);
}

class VisitRemoteDataSourceImpl implements VisitRemoteDataSource {
  final Dio dio;

  VisitRemoteDataSourceImpl(this.dio);

  @override
  Future<VisitModel> startVisit(Map<String, dynamic> data) async {
    try {
      final response = await dio.post(
        '/visit/start',
        data: data,
        options: Options(contentType: 'application/json'),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return VisitModel.fromJson(response.data['data']);
      } else {
        throw ServerFailure(
          response.data['message'] ?? 'Failed to start visit',
        );
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw const ConnectionFailure('Connection timed out');
      }

      final message =
          e.response?.data['message'] ?? e.message ?? 'Server error';
      throw ServerFailure(message);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }
}