import 'package:altahris_mobile/features/payslip/data/models/payroll_model.dart';
import 'package:dio/dio.dart';
import '../../../../core/error/failures.dart';

abstract class PayrollRemoteDataSource {
  Future<List<PayrollModel>> getPayrollMe(String token);
}

class PayrollRemoteDataSourceImpl implements PayrollRemoteDataSource {
  final Dio dio;

  PayrollRemoteDataSourceImpl(this.dio);

  @override
  Future<List<PayrollModel>> getPayrollMe(String token) async {
    try {
      final response = await dio.get(
        '/payrolls/me',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        return data.map((e) => PayrollModel.fromJson(e)).toList();
      } else {
        throw ServerFailure(response.data['message'] ?? 'Failed to get payroll');
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
