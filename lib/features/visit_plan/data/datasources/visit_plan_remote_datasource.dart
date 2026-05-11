import 'package:dio/dio.dart';
import '../../../../core/error/failures.dart';
import '../models/visit_plan_model.dart';

abstract class VisitPlanRemoteDataSource {
  Future<VisitPlanModel> createVisitPlan(Map<String, dynamic> visitPlanData);
  Future<List<VisitPlanModel>> getVisitPlans(String employeeId);
}

class VisitPlanRemoteDataSourceImpl implements VisitPlanRemoteDataSource {
  final Dio dio;

  VisitPlanRemoteDataSourceImpl(this.dio);

  @override
  Future<VisitPlanModel> createVisitPlan(Map<String, dynamic> visitPlanData) async {
    try {
      final response = await dio.post(
        '/visit-plans',
        data: visitPlanData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return VisitPlanModel.fromJson(response.data['data']);
      } else {
        throw ServerFailure(
          response.data['message'] ?? 'Failed to create visit plan',
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

  @override
  Future<List<VisitPlanModel>> getVisitPlans(String employeeId) async {
    try {
      final response = await dio.get('/visit-plans/employee/$employeeId');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        return data.map((json) => VisitPlanModel.fromJson(json)).toList();
      } else {
        throw ServerFailure(
          response.data['message'] ?? 'Failed to fetch visit plans',
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
