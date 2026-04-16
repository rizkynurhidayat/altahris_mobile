import 'package:flutter/material.dart';
import 'package:altahris_mobile/features/attendance/domain/entities/attendance.dart';

/// A reusable list tile to display attendance information
/// 
/// Shows date, status, clock in, and clock out times.
class AttendanceListTile extends StatelessWidget {
  const AttendanceListTile({super.key, required this.attendance});

  final Attendance attendance;

  @override
  Widget build(BuildContext context) {
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
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  attendance.status,
                  style: TextStyle(
                    color: Colors.green.shade700,
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
                attendance.clockIn ,
                Colors.green,
              ),
              const Spacer(),
              _buildAttendanceDetailItem(
                Icons.logout,
                'Clock Out',
                attendance.clockOut ,
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
