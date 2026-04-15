import 'package:flutter/material.dart';

import '../../features/history/domain/entities/attendance.dart';

class AttedanceListTile extends StatelessWidget {
  const AttedanceListTile({super.key, required this.attandance});

  final Attendance attandance;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(vertical: 5,),
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
                attandance.date ?? 'Monday, 13 April 2026',
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
                  attandance.status ?? 'Present',
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
          // const SizedBox(height: 16),
          Row(
            children: [
              _buildAttendanceDetailItem(
                Icons.login,
                'Clock In',
                attandance.clockIn ?? '08.00 WIB',
                Colors.green,
              ),
              const Spacer(),
              _buildAttendanceDetailItem(
                Icons.logout,
                'Clock Out',
                attandance.clockOut ?? '17.00 WIB',
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
