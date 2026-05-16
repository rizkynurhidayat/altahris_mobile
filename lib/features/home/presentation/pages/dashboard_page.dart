import 'package:altahris_mobile/core/utils/permission_handler.dart';
import 'package:altahris_mobile/features/attendance/presentation/pages/attendance_page.dart';
import 'package:altahris_mobile/features/auth/domain/entities/user.dart';
import 'package:altahris_mobile/features/home/domain/entities/employee.dart';
import 'package:altahris_mobile/features/home/presentation/bloc/home_bloc.dart';
import 'package:altahris_mobile/features/home/presentation/bloc/home_event.dart';
import 'package:altahris_mobile/features/home/presentation/bloc/home_state.dart';
import 'package:altahris_mobile/features/home/presentation/pages/clock_in_page.dart';
import 'package:altahris_mobile/features/leave/presentation/pages/leave_page.dart';
import 'package:altahris_mobile/features/payslip/presentation/pages/payslip_page.dart';
import 'package:altahris_mobile/features/visit/presentation/pages/visit_page.dart';
import 'package:altahris_mobile/features/visit_plan/presentation/pages/visit_plan_page.dart';
import 'package:flutter/material.dart';
import 'package:altahris_mobile/core/theme/app_colors.dart';
import 'package:altahris_mobile/core/widgets/index.dart';
import 'package:altahris_mobile/features/attendance/presentation/widgets/attendance_list_tile.dart';
import 'package:altahris_mobile/features/attendance/domain/entities/attendance.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

class DashboardPage extends StatefulWidget {
  final User user;

  const DashboardPage({super.key, required this.user});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late HomeBloc _homeBloc;

  @override
  void initState() {
    super.initState();
    _homeBloc = context.read<HomeBloc>();
    _homeBloc.add(FetchHomeData());
    // Request all permissions on app start as requested
    AppPermissionHandler.requestAllPermissions();
  }

  Future<void> _onRefresh() async {
    // Fetch Home Data
    _homeBloc.add(FetchHomeData());
    await _homeBloc.stream.firstWhere((state) => state is! HomeLoading);
  }

  void _navigateToAttendance(bool isClockIn, Employee? employee) {
    pushScreen(
      context,
      screen: ClockInPage(isClockIn: isClockIn, employee: employee),
      withNavBar: false,
      pageTransitionAnimation: PageTransitionAnimation.fade,
    );
  }

  bool _isToday(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty || dateStr == '--:--') return false;
    try {
      final date = DateTime.parse(dateStr);
      final now = DateTime.now();
      return date.year == now.year &&
          date.month == now.month &&
          date.day == now.day;
    } catch (_) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeBloc, HomeState>(
      listener: (context, state) {
        if (state is ClockInLoading || state is ClockOutLoading) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) =>
                const Center(child: CircularProgressIndicator()),
          );
        } else if (state is ClockInSuccess || state is ClockOutSuccess) {
          Navigator.of(context).pop(); // Pop loading
          showDialog(
            context: context,
            builder: (context) => SuccessDialog(
              title: 'Success',
              message: state is ClockInSuccess
                  ? 'Clock-in successful!'
                  : 'Clock-out successful!',
            ),
          );
        } else if (state is ClockInFailure || state is ClockOutFailure) {
          Navigator.of(context).pop(); // Pop loading
          final message = state is ClockInFailure
              ? state.message
              : (state as ClockOutFailure).message;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message), backgroundColor: Colors.red),
          );
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: RefreshIndicator(
          onRefresh: _onRefresh,
          color: AppColors.primary,
          child: Stack(
            children: [
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: BlocBuilder<HomeBloc, HomeState>(
                  buildWhen: (previous, current) => current is HomeLoaded,
                  builder: (context, state) {
                    if (state is HomeLoaded) {
                      return _buildHeader(context, state);
                    }
                    return _buildHeader(context, null);
                  },
                ),
              ),
              Positioned.fill(
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      Visibility(
                        maintainSize: true,
                        maintainAnimation: true,
                        maintainState: true,
                        visible: false,
                        child: _buildHeader(context, null),
                      ),
                      _buildScroll(context),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScroll(BuildContext context) {
    return Transform.translate(
      offset: const Offset(0, -30),
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 32),
            decoration: const BoxDecoration(color: Colors.white),
            child: Column(
              children: [
                const SizedBox(height: 120), // Space for bottom nav
                _buildQuickActions(context),
                const SizedBox(height: 24),
                _buildAttendanceList(context),
                const SizedBox(height: 100), // Space for bottom nav
              ],
            ),
          ),
          Transform.translate(
            offset: const Offset(0, -70),
            child: BlocBuilder<HomeBloc, HomeState>(
              buildWhen: (previous, current) =>
                  current is HomeLoaded || current is HomeLoading,
              builder: (context, state) {
                Attendance? latest;
                Employee? employee;
                if (state is HomeLoaded) {
                  employee = state.employee;
                  if (state.attendance.isNotEmpty) {
                    final first = state.attendance.first;
                    if (_isToday(first.clockIn)) {
                      latest = first;
                    }
                  }
                }
                return _buildAttendanceSummaryCard(context, latest, employee);
              },
            ),
          ),
        ],
      ),
    );
  }

  String _getInitials(String name) {
    if (name.isEmpty) return '??';
    List<String> parts = name.trim().split(' ');
    if (parts.length == 1) {
      return parts[0][0].toUpperCase();
    }
    return (parts.first[0][0] + parts.last[0][0]).toUpperCase();
  }

  Widget _buildHeader(BuildContext context, HomeLoaded? state) {
    final String name = state?.employee.user.name ?? widget.user.name;
    final String role =
        state?.employee.position.name ?? widget.user.role ?? '-';
    final String company =
        state?.employee.company.name ?? 'PT Tekadkan Mimpi Indonesia';

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/img/header_bg.png'),
          fit: BoxFit.cover,
          alignment: Alignment.bottomLeft,
        ),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFFF9800), Color(0xFFFF6D00)],
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 30),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                company,
                style: const TextStyle(
                  color: Color(0xFFFF6D00),
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(3),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: CircleAvatar(
                radius: 40,
                backgroundColor: AppColors.primary,
                // backgroundImage: NetworkImage(
                //   'https://cdn-icons-png.flaticon.com/512/6069/6069202.png',
                // ), // Placeholder
                child: Text(
                  _getInitials(name),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15),
            Text(
              name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              role,
              style: const TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

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

  Widget _buildAttendanceSummaryCard(
    BuildContext context,
    Attendance? latest,
    Employee? employee,
  ) {
    final today = DateFormat('EEEE, d MMMM yyyy').format(DateTime.now());
    final shift = employee?.shift;
    final shiftInfo = shift != null
        ? '${shift.name} (${shift.startTime}-${shift.endTime})'
        : 'Regular Shift (08:00-17:00)';

    final isClockedIn = latest != null && latest.clockIn.isNotEmpty;
    final isClockedOut =
        latest != null &&
        latest.clockOut.isNotEmpty &&
        latest.clockOut != '--:--' &&
        latest.clockOut != 'null';

    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        children: [
          Text(
            today,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.orange.shade50,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.primaryLight),
            ),
            child: Text(
              shiftInfo,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: isClockedIn
                      ? null
                      : () => _navigateToAttendance(true, employee),
                  child: _buildTimeBox(
                    'Clock In',
                    _formatTime(latest?.clockIn),
                    Colors.green,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: GestureDetector(
                  onTap: (!isClockedIn || isClockedOut)
                      ? null
                      : () => _navigateToAttendance(false, employee),
                  child: _buildTimeBox(
                    'Clock Out',
                    _formatTime(latest?.clockOut),
                    Colors.red,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimeBox(String label, String time, Color color) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 70,
            decoration: BoxDecoration(
              color: color,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(color: Colors.grey, fontSize: 11),
              ),
              const SizedBox(height: 4),
              Text(
                time,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: 20,
        runSpacing: 20,
        children: [
          _buildActionItem(
            'assets/icon/attandance.png',
            null,
            null,
            'Attendance',
            () {
              Navigator.of(
                context,
                rootNavigator: true,
              ).push(MaterialPageRoute(builder: (_) => const AttendancePage()));
            },
          ),
          _buildActionItem('assets/icon/leave.png', null, null, 'Leave', () {
            Navigator.of(
              context,
              rootNavigator: true,
            ).push(MaterialPageRoute(builder: (_) => const LeavePage()));
          }),
          _buildActionItem(
            'assets/icon/payslip.png',
            null,
            null,
            'Payslip',
            () {
              Navigator.of(
                context,
                rootNavigator: true,
              ).push(MaterialPageRoute(builder: (_) => const PayslipPage()));
            },
          ),
          _buildActionItem(
            'assets/icon/visit-plan.png',
            null,
            8,
            'Visit Plan',
            () {
              Navigator.of(
                context,
                rootNavigator: true,
              ).push(MaterialPageRoute(builder: (_) => const VisitPlanPage()));
            },
          ),
          _buildActionItem('assets/icon/visit.png', null, 8, 'Visit', () {
            Navigator.of(
              context,
              rootNavigator: true,
            ).push(MaterialPageRoute(builder: (_) => const VisitPage()));
          }),
        ],
      ),
    );
  }

  Widget _buildActionItem(
    String? iconPath,
    IconData? iconData,
    double? scale,
    String label,
    VoidCallback? onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade100),
            ),
            child: iconPath != null
                ? Image.asset(iconPath, scale: scale ?? 4)
                : Icon(iconData, size: 32, color: AppColors.primary),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildAttendanceList(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Attendance',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).push(
                    MaterialPageRoute(builder: (_) => const AttendancePage()),
                  );
                },
                child: const Row(
                  children: [
                    Text('See More', style: TextStyle(color: Colors.orange)),
                    Icon(Icons.chevron_right, color: Colors.orange, size: 18),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          BlocBuilder<HomeBloc, HomeState>(
            buildWhen: (previous, current) =>
                current is HomeLoaded ||
                current is HomeLoading ||
                current is HomeFailure,
            builder: (context, state) {
              if (state is HomeLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is HomeLoaded) {
                if (state.attendance.isEmpty) {
                  return const Center(child: Text('No attendance data'));
                }
                return Column(
                  children: state.attendance
                      .take(5)
                      .map((e) => AttendanceListTile(attendance: e))
                      .toList(),
                );
              } else if (state is HomeFailure) {
                return CustomErrorWidget(
                  message: state.message,
                  onRetry: () {
                    _homeBloc.add(FetchHomeData());
                  },
                );
              }
              return const SizedBox();
            },
          ),
        ],
      ),
    );
  }
}
