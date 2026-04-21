import 'package:flutter/material.dart';
import 'package:altahris_mobile/features/attendance/domain/entities/attendance.dart';
import 'package:intl/intl.dart';

/// A reusable list tile to display attendance information
/// 
/// Shows date, status, clock in, and clock out times.
class AttendanceListTile extends StatelessWidget {
  const AttendanceListTile({super.key, required this.attendance});

  final Attendance attendance;

  String _formatTime(String? timeStr) {
    if (timeStr == null || timeStr.isEmpty || timeStr == '--:--') {
      return '--:--';
    }
    try {
      // Try parsing as ISO8601 first
      // The API provides UTC, so we convert it to local time
      final dateTime = DateTime.parse(timeStr).toLocal();
      return DateFormat('HH:mm').format(dateTime);
    } catch (e) {
      // If it's already HH:mm:ss or similar, try parsing that
      try {
        final parts = timeStr.split(':');
        if (parts.length >= 2) {
          return '${parts[0].padLeft(2, '0')}:${parts[1].padLeft(2, '0')}';
        }
      } catch (_) {}
      return timeStr;
    }
  }

  String _getStatusLabel(String status) {
    switch (status.toLowerCase()) {
      case 'late_in':
        return 'Late';
      case 'early_in':
        return 'Early';
      case 'on_time':
        return 'On Time';
      case 'absent':
        return 'Absent';
      case 'leave':
        return 'Leave';
      default:
        // Capitalize first letter of each word as fallback
        if (status.isEmpty) return 'Unknown';
        return status.split('_').map((word) {
          if (word.isEmpty) return '';
          return word[0].toUpperCase() + word.substring(1).toLowerCase();
        }).join(' ');
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'late_in':
        return Colors.red;
      case 'early_in':
        return Colors.blue;
      case 'on_time':
        return Colors.green;
      case 'absent':
        return Colors.grey;
      case 'leave':
        return Colors.orange;
      default:
        return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusLabel = _getStatusLabel(attendance.status);
    final statusColor = _getStatusColor(attendance.status);

    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                attendance.date ,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  statusLabel,
                  style: TextStyle(
                    color: statusColor.withOpacity(0.8),
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          Divider(
            height: 20,
            thickness: 1,
            color: Colors.grey.shade200,
          ),
          Row(
            children: [
              _buildAttendanceDetailItem(
                Icons.login,
                'Clock In',
                _formatTime(attendance.clockIn),
                Colors.green,
              ),
              const Spacer(),
              _buildAttendanceDetailItem(
                Icons.logout,
                'Clock Out',
                _formatTime(attendance.clockOut),
                Colors.red,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAttendanceDetailItem(
    IconData icon,
    String label,
    String time,
    Color color,
  ) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
            Text(
              time,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
