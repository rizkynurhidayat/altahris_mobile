import '../../domain/entities/visit_plan_item_entity.dart';

class VisitPlanItemModel extends VisitPlanItemEntity {
  const VisitPlanItemModel({
    super.id,
    super.visitPlanId,
    required super.location,
    required super.purpose,
    required super.scheduledTime,
    required super.sequenceOrder,
    required super.subLocation,
    super.status,
    super.linkedVisitId,
    super.createdAt,
    super.updatedAt,
  });

  factory VisitPlanItemModel.fromJson(Map<String, dynamic> json) {
    return VisitPlanItemModel(
      id: json['id'],
      visitPlanId: json['visit_plan_id'],
      location: json['location'] ?? '',
      purpose: json['purpose'] ?? '',
      scheduledTime: json['scheduled_time'] ?? '',
      sequenceOrder: json['sequence_order'] ?? 0,
      subLocation: json['sub_location'] ?? '',
      status: json['status'],
      linkedVisitId: json['linked_visit_id'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (visitPlanId != null) 'visit_plan_id': visitPlanId,
      'location': location,
      'purpose': purpose,
      'scheduled_time': scheduledTime,
      'sequence_order': sequenceOrder,
      'sub_location': subLocation,
      if (status != null) 'status': status,
      if (linkedVisitId != null) 'linked_visit_id': linkedVisitId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    };
  }
}
