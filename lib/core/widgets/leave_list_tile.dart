import 'package:flutter/material.dart';
import 'package:altahris_mobile/core/theme/app_colors.dart';
import '../../features/leave/domain/entities/leave.dart';

class LeaveListTile extends StatelessWidget {
  final Leave leave;

  const LeaveListTile({super.key, required this.leave});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Section
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _formatLeaveType(leave.leaveType),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Requested on: ${_formatDate(leave.createdAt)}',
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                _buildStatusBadge(leave.status),
              ],
            ),
          ),
          Divider(height: 1, color: Colors.grey.shade200),
          // Detail Section
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: ImageIcon(
                        AssetImage('assets/icon/edit.png'),
                        color: AppColors.background,
                        size: 14,
                      ),
                      // child: const Icon(Icons.edit_note, color: AppColors.primary, size: 16),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        leave.reason,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: ImageIcon(
                        AssetImage('assets/icon/calendar.png'),
                        color: AppColors.background,
                        size: 14,
                      ),
                      // child: const Icon(Icons.calendar_today, color: AppColors.primary, size: 14),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      '${leave.startDate} - ${leave.endDate}',
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                          child: ImageIcon(
                            AssetImage('assets/icon/clock.png'),
                            color: AppColors.background,
                            size: 14,
                          ),
                          // child: const Icon(Icons.calendar_today, color: AppColors.primary, size: 14),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${leave.totalDays} Days',
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String dateStr) {
    try {
      if (dateStr.contains('T')) {
        return dateStr.split('T')[0];
      }
      return dateStr;
    } catch (e) {
      return dateStr;
    }
  }

  String _formatLeaveType(String type) {
    switch (type) {
      case 'cuti_tahunan':
        return 'Annual Leave';
      case 'sakit':
        return 'Sick Leave';
      default:
        return type
            .split('_')
            .map((word) => word[0].toUpperCase() + word.substring(1))
            .join(' ');
    }
  }

  Widget _buildStatusBadge(String status) {
    Color color;
    Color bgColor;

    switch (status.toLowerCase()) {
      case 'approved':
        color = const Color(0xFF2ECC71);
        bgColor = const Color(0xFFE8F8F0);
        break;
      case 'rejected':
        color = Colors.red.shade700;
        bgColor = Colors.red.shade50;
        break;
      case 'pending':
      default:
        color = Colors.orange.shade700;
        bgColor = Colors.orange.shade50;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status[0].toUpperCase() + status.substring(1).toLowerCase(),
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
