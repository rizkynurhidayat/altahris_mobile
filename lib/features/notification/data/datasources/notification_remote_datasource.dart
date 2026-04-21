import 'package:dio/dio.dart';
import '../../../../core/error/failures.dart';
import '../models/notification_model.dart';

abstract class NotificationRemoteDataSource {
  Future<List<NotificationModel>> getNotifications(String token, {int? limit});
}

class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  final Dio dio;

  NotificationRemoteDataSourceImpl(this.dio);

  @override
  Future<List<NotificationModel>> getNotifications(String token, {int? limit}) async {
    /*
    // Simulating API delay
    await Future.delayed(const Duration(milliseconds: 500));

    // Dummy data covering all notification types as per Notification.png
    final List<Map<String, dynamic>> dummyData = [
      {
        "id": "1",
        "title": "Payslip Available",
        "message": "Your payslip is available for viewing and download.",
        "type": "info",
        "is_read": false,
        "created_at": "Just Now",
      },
      {
        "id": "2",
        "title": "Leave Request Submitted",
        "message": "Your business trip leave request for 3 days has been successfully submitted.",
        "type": "error", // Using error for Red as per screenshot
        "is_read": true,
        "created_at": "Today, 12.35 AM",
      },
      {
        "id": "3",
        "title": "Leave Request Approved",
        "message": "Your business trip leave request for 12-14 February has been approved.",
        "type": "success", // Green
        "is_read": true,
        "created_at": "Yesterday, 08.35 AM",
      },
      {
        "id": "4",
        "title": "Leave Request Pending",
        "message": "Your business trip leave request is waiting for manager approval.",
        "type": "warning", // Yellow/Amber
        "is_read": false,
        "created_at": "Yesterday, 08.15 AM",
      },
      {
        "id": "5",
        "title": "Leave Request Submitted",
        "message": "Your business trip leave request for 3 days has been successfully submitted.",
        "type": "error", // Red
        "is_read": true,
        "created_at": "Yesterday, 08.15 AM",
      },
    ];

    return dummyData.map((e) => NotificationModel.fromJson(e)).toList();
    */

    try {
      final response = await dio.get(
        '/notifications',
        queryParameters: limit != null ? {'limit': limit} : null,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        return data.map((e) => NotificationModel.fromJson(e)).toList();
      } else {
        throw ServerFailure(
          response.data['message'] ?? 'Failed to fetch notifications',
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
      if (e is Failure) rethrow;
      throw ServerFailure(e.toString());
    }
  }
}
