import 'package:altahris_mobile/core/theme/app_colors.dart';
import 'package:altahris_mobile/features/visit_plan/domain/entities/visit_plan_entity.dart';
import 'package:flutter/material.dart';

class VisitPlanCard extends StatelessWidget {
  final VisitPlanEntity visitPlan;

  const VisitPlanCard({
    super.key,
    required this.visitPlan,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                visitPlan.planDate,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  visitPlan.status,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Items: ${visitPlan.items.length}',
            style: const TextStyle(fontSize: 14, color: AppColors.textSecondary),
          ),
          if (visitPlan.notes.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              visitPlan.notes,
              style: const TextStyle(fontSize: 14),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }
}
