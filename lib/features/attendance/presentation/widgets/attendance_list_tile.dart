import 'dart:convert';
import 'package:altahris_mobile/core/theme/index.dart';
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
        return status
            .split('_')
            .map((word) {
              if (word.isEmpty) return '';
              return word[0].toUpperCase() + word.substring(1).toLowerCase();
            })
            .join(' ');
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

  void _showPhotoDialog(
    BuildContext context,
    String? photoBase64,
    String title,
  ) {
    if (photoBase64 == null || photoBase64.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('No photo available')));
      return;
    }

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.6,
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(16),
                ),
                child: photoBase64.startsWith('http')
                    ? Image.network(photoBase64, fit: BoxFit.contain)
                    : Image.memory(
                        base64Decode(
                          photoBase64.replaceFirst(
                            RegExp(r'data:image/[^;]+;base64,'),
                            '',
                          ),
                        ),
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) =>
                            const Padding(
                              padding: EdgeInsets.all(32.0),
                              child: Text('Invalid image data'),
                            ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
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
                attendance.date,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  statusLabel,
                  style: TextStyle(
                    color: statusColor.withValues(alpha: 0.8),
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          Divider(height: 20, thickness: 1, color: Colors.grey.shade200),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _buildAttendanceDetailItem(
                  context,
                  Icons.login,
                  'Clock In',
                  _formatTime(attendance.clockIn),
                  Colors.green,
                  attendance.clockInLat,
                  attendance.clockInLng,
                  attendance.clockInDistanceM,
                  attendance.clockInPhoto,
                  attendance.clockInDistanceStatus,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildAttendanceDetailItem(
                  context,
                  Icons.logout,
                  'Clock Out',
                  _formatTime(attendance.clockOut),
                  Colors.red,
                  attendance.clockOutLat,
                  attendance.clockOutLng,
                  attendance.clockOutDistanceM,
                  attendance.clockOutPhoto,
                  attendance.clockOutDistanceStatus,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAttendanceDetailItem(
    BuildContext context,
    IconData icon,
    String label,
    String time,
    Color color,
    double? lat,
    double? lng,
    double? distance,
    String? photo,
    String? distanceStatus,
  ) {
    String _buildDistanceStatus(String? distanceStatus) {
      if (distanceStatus!.isEmpty) {
        return "";
      } else if (distanceStatus.contains('outside_area')) {
        return "Outside Area";
      } else {
        return "Inside Area";
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(color: Colors.grey, fontSize: 10),
                  ),
                  Text(
                    time,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        if (lat != null && lng != null && lat != 0 && lng != 0) ...[
          const SizedBox(height: 8),
          Text(
            'Loc: ${lat.toStringAsFixed(4)}, ${lng.toStringAsFixed(4)}',
            style: const TextStyle(fontSize: 10, color: Colors.grey),
          ),
          if (distance != null)
            Text(
              '${_buildDistanceStatus(distanceStatus)}\nDist: ${distance}m',
              style: TextStyle(
                fontSize: 10,
                color: distance > 100 ? Colors.red : AppColors.primary,
                fontWeight: distance > 100
                    ? FontWeight.bold
                    : FontWeight.normal,
              ),
            ),
        ],
        if (photo != null && photo.isNotEmpty && photo != 'string') ...[
          const SizedBox(height: 4),
          InkWell(
            onTap: () => _showPhotoDialog(context, photo, 'Photo $label'),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.image, size: 14, color: color),
                const SizedBox(width: 4),
                Text(
                  'Lihat Foto',
                  style: TextStyle(
                    fontSize: 10,
                    color: color,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
