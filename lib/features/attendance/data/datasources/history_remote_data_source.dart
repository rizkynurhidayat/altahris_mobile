// import 'package:dio/dio.dart';

// import '../models/attendance_model.dart';

// abstract class HistoryRemoteDataSource {
//   Future<List<AttendanceModel>> getAttendanceHistory(String id);
// }

// class HistoryRemoteDataSourceImpl implements HistoryRemoteDataSource {
//   final Dio dio;
  
//   HistoryRemoteDataSourceImpl( this.dio);

//   @override
//   Future<List<AttendanceModel>> getAttendanceHistory(String id) async {
//     // Simulated network delay
//     await Future.delayed(const Duration(seconds: 1));

//     // Dummy data based on response.json structure
//     final dummyData = [
//       {
//         "id": "1",
//         "date": "2026-04-13",
//         "clock_in": "08:00:00",
//         "clock_out": "17:00:00",
//         "status": "hadir",
//         "notes": "Ontime",
//         "overtime_hours": 0,
//         "created_at": "2026-04-13T08:00:00Z",
//         "updated_at": "2026-04-13T17:00:00Z"
//       },
//       {
//         "id": "2",
//         "date": "2026-04-12",
//         "clock_in": "08:15:00",
//         "clock_out": "17:30:00",
//         "status": "hadir",
//         "notes": "Late but worked extra",
//         "overtime_hours": 0,
//         "created_at": "2026-04-12T08:15:00Z",
//         "updated_at": "2026-04-12T17:30:00Z"
//       },
//       {
//         "id": "3",
//         "date": "2026-04-11",
//         "clock_in": null,
//         "clock_out": null,
//         "status": "alfa",
//         "notes": "No information",
//         "overtime_hours": 0,
//         "created_at": "2026-04-11T00:00:00Z",
//         "updated_at": "2026-04-11T00:00:00Z"
//       },
//       {
//         "id": "4",
//         "date": "2026-04-10",
//         "clock_in": "07:50:00",
//         "clock_out": "19:00:00",
//         "status": "hadir",
//         "notes": "Overtime",
//         "overtime_hours": 2,
//         "created_at": "2026-04-10T07:50:00Z",
//         "updated_at": "2026-04-10T19:00:00Z"
//       },
//       {
//         "id": "5",
//         "date": "2026-04-09",
//         "clock_in": null,
//         "clock_out": null,
//         "status": "sakit",
//         "notes": "Medical certificate provided",
//         "overtime_hours": 0,
//         "created_at": "2026-04-09T00:00:00Z",
//         "updated_at": "2026-04-09T00:00:00Z"
//       }
//     ];

//     return dummyData.map((e) => AttendanceModel.fromJson(e)).toList();

//     /* 
//     // Implementasi API sesungguhnya (dimatikan sementara)
//     try {
//       final response = await dio.post(
//         '/attendances/$id',
//         data: {
//           'email': email,
//           'password': password,
//         },
//       );

//       if (response.statusCode == 200) {
//         final loginResponse = response.data['data'];
//         final token = loginResponse['access_token'];
      

//         return UserModel.fromJson(userData);
//       } else {
//         throw ServerFailure(response.data['message'] ?? 'Login failed');
//       }
//     } on DioException catch (e) {
//       if (e.type == DioExceptionType.connectionTimeout || 
//           e.type == DioExceptionType.receiveTimeout) {
//         throw const ConnectionFailure('Connection timed out');
//       }
      
//       final message = e.response?.data['message'] ?? e.message ?? 'Server error';
//       throw ServerFailure(message);
//     } catch (e) {
//       throw ServerFailure(e.toString());
//     }
//     */
//   }
// }
