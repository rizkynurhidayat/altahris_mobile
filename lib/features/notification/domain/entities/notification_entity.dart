import 'package:equatable/equatable.dart';

class NotificationEntity extends Equatable {
  final String id;
  final String title;
  final String message;
  final String type;
  final bool isRead;
  final String? createdAt;
  final String? readAt;
  final String? refId;
  final String? refType;

  const NotificationEntity({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.isRead,
    this.createdAt,
    this.readAt,
    this.refId,
    this.refType,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        message,
        type,
        isRead,
        createdAt,
        readAt,
        refId,
        refType,
      ];
}
