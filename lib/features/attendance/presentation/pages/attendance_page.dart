import 'package:altahris_mobile/core/theme/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:altahris_mobile/core/widgets/index.dart';
import 'package:intl/intl.dart';
import 'package:altahris_mobile/features/attendance/presentation/bloc/attendance_bloc.dart';
import 'package:altahris_mobile/features/attendance/presentation/bloc/attendance_event.dart';
import 'package:altahris_mobile/features/attendance/presentation/bloc/attendance_state.dart';

class AttendancePage extends StatefulWidget {
  const AttendancePage({super.key});

  @override
  State<AttendancePage> createState() => AttendancePageState();
}

class AttendancePageState extends State<AttendancePage> {
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    _fetchHistory();
  }

  void _fetchHistory() {
    context.read<AttendanceBloc>().add(FetchAttendanceHistory());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Attendance',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textPrimary,
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: AppColors.primary),
            onPressed: _fetchHistory,
          ),
        ],
      ),
      body: Column(
        children: [
          _buildDateFilter(),
          Expanded(
            child: BlocBuilder<AttendanceBloc, AttendanceState>(
              builder: (context, state) {
                if (state is AttendanceLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is AttendanceLoaded) {
                  // Client-side filtering logic
                  final filteredHistory = state.attendanceHistory.where((attendance) {
                    if (attendance.date.isEmpty) return true;
                    try {
                      final date = DateTime.parse(attendance.date);
                      // Start Date Filter: if selected, attendance must be on or after start date
                      if (_startDate != null) {
                        final normalizedDate = DateTime(date.year, date.month, date.day);
                        if (normalizedDate.isBefore(_startDate!)) return false;
                      }
                      // End Date Filter: if selected, attendance must be on or before end date
                      if (_endDate != null) {
                        final normalizedDate = DateTime(date.year, date.month, date.day);
                        if (normalizedDate.isAfter(_endDate!)) return false;
                      }
                    } catch (_) {}
                    return true;
                  }).toList();

                  if (filteredHistory.isEmpty) {
                    return RefreshIndicator(
                      onRefresh: () async => _fetchHistory(),
                      child: Stack(
                        children: [
                          ListView(physics: const AlwaysScrollableScrollPhysics()),
                          const Center(child: Text('No Attendance Data Found')),
                        ],
                      ),
                    );
                  }
                  return RefreshIndicator(
                    onRefresh: () async => _fetchHistory(),
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: filteredHistory.length,
                      itemBuilder: (context, index) {
                        final attendance = filteredHistory[index];
                        return AttendanceListTile(attendance: attendance);
                      },
                    ),
                  );
                } else if (state is AttendanceFailure) {
                  return CustomErrorWidget(
                    message: state.message,
                    onRetry: _fetchHistory,
                  );
                }
                return const Center(child: Text('Belum ada riwayat'));
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateFilter() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildDateButton(
              label: 'Start Date',
              date: _startDate,
              onTap: () => _selectDate(true),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildDateButton(
              label: 'End Date',
              date: _endDate,
              onTap: () => _selectDate(false),
            ),
          ),
          if (_startDate != null || _endDate != null) ...[
            const SizedBox(width: 8),
            Container(
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(10),
              ),
              child: IconButton(
                onPressed: () {
                  setState(() {
                    _startDate = null;
                    _endDate = null;
                  });
                },
                icon: const Icon(Icons.filter_list_off, color: Colors.red, size: 20),
                tooltip: 'Clear Filters',
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDateButton({
    required String label,
    required DateTime? date,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            const Icon(Icons.calendar_month_rounded, size: 18, color: AppColors.primary),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    date != null ? DateFormat('dd MMM yyyy').format(date) : 'Select',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _selectDate(bool isStartDate) {
    CustomDatePicker.show(
      context,
      initialDate: (isStartDate ? _startDate : _endDate) ?? DateTime.now(),
      onDateSelected: (date) {
        setState(() {
          final normalizedDate = DateTime(date.year, date.month, date.day);
          if (isStartDate) {
            _startDate = normalizedDate;
            // Ensure end date is not before start date
            if (_endDate != null && _endDate!.isBefore(_startDate!)) {
              _endDate = null;
            }
          } else {
            _endDate = normalizedDate;
            // Ensure start date is not after end date
            if (_startDate != null && _startDate!.isAfter(_endDate!)) {
              _startDate = null;
            }
          }
        });
      },
    );
  }
}
