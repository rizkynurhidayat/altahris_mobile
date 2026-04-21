import 'package:equatable/equatable.dart';

abstract class NotificationEvent extends Equatable {
  const NotificationEvent();

  @override
  List<Object?> get props => [];
}

class GetNotifications extends NotificationEvent {
  final int? limit;

  const GetNotifications({this.limit});

  @override
  List<Object?> get props => [limit];
}
