import 'package:equatable/equatable.dart';
import 'visit_plan_item_entity.dart';

class VisitPlanEntity extends Equatable {
  final String id;
  final String employeeId;
  final String companyId;
  final String planDate;
  final String notes;
  final String status;
  final List<VisitPlanItemEntity> items;
  final String createdBy;
  final String createdAt;
  final String updatedAt;

  const VisitPlanEntity({
    required this.id,
    required this.employeeId,
    required this.companyId,
    required this.planDate,
    required this.notes,
    required this.status,
    required this.items,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        employeeId,
        companyId,
        planDate,
        notes,
        status,
        items,
        createdBy,
        createdAt,
        updatedAt,
      ];
}
