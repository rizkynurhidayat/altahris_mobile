import 'package:equatable/equatable.dart';

class VisitPlanItemEntity extends Equatable {
  final String? id;
  final String? visitPlanId;
  final String location;
  final String purpose;
  final String scheduledTime;
  final int sequenceOrder;
  final String subLocation;
  final String? status;
  final String? linkedVisitId;
  final String? createdAt;
  final String? updatedAt;

  const VisitPlanItemEntity({
    this.id,
    this.visitPlanId,
    required this.location,
    required this.purpose,
    required this.scheduledTime,
    required this.sequenceOrder,
    required this.subLocation,
    this.status,
    this.linkedVisitId,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        visitPlanId,
        location,
        purpose,
        scheduledTime,
        sequenceOrder,
        subLocation,
        status,
        linkedVisitId,
        createdAt,
        updatedAt,
      ];
}
