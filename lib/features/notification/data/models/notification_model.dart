import '../../domain/entities/notification_entity.dart';

class NotificationModel extends NotificationEntity {
  const NotificationModel({
    required super.id,
    required super.title,
    required super.message,
    required super.type,
    required super.isRead,
    required super.createdAt,
    required super.readAt,
    required super.refId,
    required super.refType,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? '',
      message: json['message'] ?? '',
      type: json['type'] ?? 'info',
      isRead: json['is_read'] ?? false,
      createdAt: json['created_at'],
      readAt: json['read_at'],
      refId: json['ref_id'],
      refType: json['ref_type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'type': type,
      'is_read': isRead,
      'created_at': createdAt,
      'read_at': readAt,
      'ref_id': refId,
      'ref_type': refType,
    };
  }
}
