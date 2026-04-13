import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/attendance.dart';
import '../bloc/history_bloc.dart';
import '../bloc/history_event.dart';
import '../bloc/history_state.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  void initState() {
    super.initState();
    // Fetch data when page is opened if it's the initial state
    final state = context.read<HistoryBloc>().state;
    if (state is HistoryInitial) {
      context.read<HistoryBloc>().add(FetchAttendanceHistory());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {},
          ),
        ],
      ),
      body: BlocBuilder<HistoryBloc, HistoryState>(
        builder: (context, state) {
          if (state is HistoryLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is HistoryLoaded) {
            if (state.attendanceHistory.isEmpty) {
              return RefreshIndicator(
                onRefresh: () async {
                  context.read<HistoryBloc>().add(FetchAttendanceHistory());
                },
                child: const Stack(
                  children: [
                    Center(child: Text('Belum ada riwayat')),
                    // ListView(), // Required for RefreshIndicator to work on empty list
                  ],
                ),
              );
            }
            return RefreshIndicator(
              onRefresh: () async {
                context.read<HistoryBloc>().add(FetchAttendanceHistory());
              },
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: state.attendanceHistory.length,
                itemBuilder: (context, index) {
                  final attendance = state.attendanceHistory[index];
                  return _buildHistoryCard(attendance);
                },
              ),
            );
          } else if (state is HistoryFailure) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${state.message}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<HistoryBloc>().add(FetchAttendanceHistory());
                    },
                    child: const Text('Coba Lagi'),
                  ),
                ],
              ),
            );
          }
          return const Center(child: Text('Belum ada riwayat'));
        },
      ),
    );
  }

  Widget _buildHistoryCard(Attendance attendance) {
    Color statusColor;
    switch (attendance.status?.toLowerCase()) {
      case 'hadir':
        statusColor = Colors.green;
        break;
      case 'sakit':
        statusColor = Colors.blue;
        break;
      case 'izin':
        statusColor = Colors.orange;
        break;
      default:
        statusColor = Colors.red;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  attendance.date ?? '-',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    attendance.status?.toUpperCase() ?? '-',
                    style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Clock In', style: TextStyle(color: Colors.grey, fontSize: 12)),
                      Text(attendance.clockIn ?? '--:--', style: const TextStyle(fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Clock Out', style: TextStyle(color: Colors.grey, fontSize: 12)),
                      Text(attendance.clockOut ?? '--:--', style: const TextStyle(fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Lembur', style: TextStyle(color: Colors.grey, fontSize: 12)),
                      Text('${attendance.overtimeHours ?? 0} Jam', style: const TextStyle(fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

