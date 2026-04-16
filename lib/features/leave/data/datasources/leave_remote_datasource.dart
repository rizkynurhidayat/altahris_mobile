import 'package:dio/dio.dart';
import '../models/leave_model.dart';

abstract class LeaveRemoteDataSource {
  Future<List<LeaveModel>> getLeaveHistory(String employeeId);
}

class LeaveRemoteDataSourceImpl implements LeaveRemoteDataSource {
  final Dio dio;

  LeaveRemoteDataSourceImpl(this.dio);

  @override
  Future<List<LeaveModel>> getLeaveHistory(String employeeId) async {
    // In a real app, this would be:
    // final response = await dio.get('/leaves', queryParameters: {'employee_id': employeeId});
    
    // Simulating API response based on provided response.json
    await Future.delayed(const Duration(seconds: 1));
    
    // This is a placeholder for the actual API call
    final Map<String, dynamic> mockJson = {
      "data": [
        {
          "id": "1",
          "employee_id": employeeId,
          "employee": {
            "id": employeeId,
            "employee_number": "EMP001",
            "user": {
              "id": "u1",
              "name": "Budi Santoso",
              "email": "budi@mail.com"
            },
            "company": { "name": "PT Tekadkan Mimpi Indonesia" },
            "department": { "name": "IT" },
            "position": { "name": "Fullstack Developer" },
            "shift": { "name": "Regular Shift" }
          },
          "leave_type": "cuti_tahunan",
          "start_date": "2026-04-20",
          "end_date": "2026-04-22",
          "total_days": 3,
          "reason": "Acara keluarga",
          "status": "pending",
          "created_at": "2026-04-16T10:00:00Z",
          "updated_at": "2026-04-16T10:00:00Z"
        }
      ]
    };

    final List data = mockJson['data'];
    return data.map((json) => LeaveModel.fromJson(json)).toList();
  }
}
