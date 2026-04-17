import 'package:altahris_mobile/core/theme/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:altahris_mobile/core/widgets/index.dart';
// import 'package:altahris_mobile/features/attendance/domain/entities/attendance.dart';
import 'package:altahris_mobile/features/attendance/presentation/bloc/attendance_bloc.dart';
import 'package:altahris_mobile/features/attendance/presentation/bloc/attendance_event.dart';
import 'package:altahris_mobile/features/attendance/presentation/bloc/attendance_state.dart';

class AttendancePage extends StatefulWidget {
  const AttendancePage({super.key});

  @override
  State<AttendancePage> createState() => AttendancePageState();
}

class AttendancePageState extends State<AttendancePage> {
  @override
  void initState() {
    super.initState();
    // Fetch data when page is opened if it's the initial state
    final state = context.read<AttendanceBloc>().state;
    if (state is AttendanceInitial) {
      context.read<AttendanceBloc>().add(FetchAttendanceHistory());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textPrimary,
        centerTitle: true,
       leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: BlocBuilder<AttendanceBloc, AttendanceState>(
        builder: (context, state) {
          if (state is AttendanceLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is AttendanceLoaded) {
            if (state.attendanceHistory.isEmpty) {
              return RefreshIndicator(
                onRefresh: () async {
                  context.read<AttendanceBloc>().add(FetchAttendanceHistory());
                },
                child: const Stack(
                  children: [
                    Center(child: Text('Belum ada riwayat')),
                  ],
                ),
              );
            }
            return RefreshIndicator(
              onRefresh: () async {
                context.read<AttendanceBloc>().add(FetchAttendanceHistory());
              },
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: state.attendanceHistory.length,
                itemBuilder: (context, index) {
                  final attendance = state.attendanceHistory[index];
                  return AttendanceListTile(attendance: attendance);
                },
              ),
            );
          } else if (state is AttendanceFailure) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${state.message}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<AttendanceBloc>().add(FetchAttendanceHistory());
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
}
