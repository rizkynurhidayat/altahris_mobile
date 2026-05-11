import 'package:altahris_mobile/core/theme/app_colors.dart';
import 'package:altahris_mobile/core/widgets/index.dart';
import 'package:flutter/material.dart';

class VisitPlanItemCard extends StatelessWidget {
  final int index;
  final TextEditingController locationController;
  final TextEditingController subLocationController;
  final TextEditingController purposeController;
  final TextEditingController timeController;
  final VoidCallback onRemove;
  final VoidCallback onSelectTime;

  const VisitPlanItemCard({
    super.key,
    required this.index,
    required this.locationController,
    required this.subLocationController,
    required this.purposeController,
    required this.timeController,
    required this.onRemove,
    required this.onSelectTime,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Visit Item #${index + 1}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              if (index > 0)
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: AppColors.error),
                  onPressed: onRemove,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
            ],
          ),
          const SizedBox(height: 12),
          CustomTextField(
            label: 'Location *',
            placeholder: 'Enter location',
            controller: locationController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Location is required';
              }
              return null;
            },
          ),
          const SizedBox(height: 12),
          CustomTextField(
            label: 'Sub Location *',
            placeholder: 'Enter sub location',
            controller: subLocationController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Sub location is required';
              }
              return null;
            },
          ),
          const SizedBox(height: 12),
          CustomTextField(
            label: 'Purpose *',
            placeholder: 'Enter purpose',
            controller: purposeController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Purpose is required';
              }
              return null;
            },
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: onSelectTime,
            child: AbsorbPointer(
              child: CustomTextField(
                label: 'Scheduled Time *',
                placeholder: 'HH:mm',
                controller: timeController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Time is required';
                  }
                  return null;
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
