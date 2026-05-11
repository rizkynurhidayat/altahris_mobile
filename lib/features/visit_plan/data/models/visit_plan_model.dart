import '../../domain/entities/visit_plan_entity.dart';
import 'visit_plan_item_model.dart';

class VisitPlanModel extends VisitPlanEntity {
  const VisitPlanModel({
    required super.id,
    required super.employeeId,
    required super.companyId,
    required super.planDate,
    required super.notes,
    required super.status,
    required List<VisitPlanItemModel> super.items,
    required super.createdBy,
    required super.createdAt,
    required super.updatedAt,
  });

  factory VisitPlanModel.fromJson(Map<String, dynamic> json) {
    return VisitPlanModel(
      id: json['id'],
      employeeId: json['employee_id'],
      companyId: json['company_id'],
      planDate: json['plan_date'],
      notes: json['notes'] ?? '',
      status: json['status'],
      items: (json['items'] as List)
          .map((item) => VisitPlanItemModel.fromJson(item))
          .toList(),
      createdBy: json['created_by'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'employee_id': employeeId,
      'company_id': companyId,
      'plan_date': planDate,
      'notes': notes,
      'status': status,
      'items': items.map((item) => (item as VisitPlanItemModel).toJson()).toList(),
      'created_by': createdBy,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
