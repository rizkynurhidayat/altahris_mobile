import 'package:altahris_mobile/features/payslip/presentation/pages/payslip_page.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/attandance_list_tile.dart';
import '../../../history/domain/entities/attendance.dart';
// import '../../../../core/widgets/success_dialog.dart';

class DashboardPage extends StatelessWidget {
  final String userName;

  const DashboardPage({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(top: 0, left: 0, right: 0, child: _buildHeader(context)),
          Positioned.fill(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Visibility(
                    maintainSize: true,
                    maintainAnimation: true,
                    maintainState: true,
                    visible: false,
                    child: _buildHeader(context),
                  ),
                  _buildScroll(context),
                ],
              ),
            ),
          ),
        ],
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
            decoration: const BoxDecoration(
              color: Colors.white,
              // borderRadius: BorderRadius.only(
              //   topLeft: Radius.circular(15),
              //   topRight: Radius.circular(15),
              // ),
            ),
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

            child: _buildAttendanceSummaryCard(context),
          ),
        ],
      ),

      // child: Column(
      //   children: [
      //     _buildAttendanceSummaryCard(context),
      //     SizedBox(height: 20),
      //     Container(
      //       padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      //       decoration: const BoxDecoration(
      //         color: Colors.white,
      //         borderRadius: BorderRadius.only(
      //           topLeft: Radius.circular(32),
      //           topRight: Radius.circular(32),
      //         ),
      //       ),
      //       child: Column(
      //         children: [
      //           _buildQuickActions(),
      //           const SizedBox(height: 24),
      //           _buildAttendanceList(context),
      //           const SizedBox(height: 100), // Space for bottom nav
      //         ],
      //       ),
      //     ),
      //   ],
      // ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      // height: 380,
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
              child: const Text(
                'PT Tekadkan Mimpi Indonesia',
                style: TextStyle(
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
              child: const CircleAvatar(
                radius: 40,
                backgroundImage: NetworkImage(
                  'https://i.pravatar.cc/150?u=budi',
                ), // Placeholder
              ),
            ),
            const SizedBox(height: 15),
            Text(
              userName,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              'Fullstack Developer',
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttendanceSummaryCard(BuildContext context) {
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
          const Text(
            'Monday, 13 April 2026',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 14,
              fontWeight: FontWeight.w500,
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
              'Regular Shift (08:00-17:00)',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(child: _buildTimeBox('Clock In', '08:00', Colors.green)),
              const SizedBox(width: 16),
              Expanded(child: _buildTimeBox('Clock Out', '17:00', Colors.red)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimeBox(String label, String time, Color color) {
    return Container(
      // padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 4,
                height: 70,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    bottomLeft: Radius.circular(12),
                  ),
                ),
              ),

              const SizedBox(width: 10),
              Column(
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
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildActionItem('assets/icon/attandance.png', 'Attendance', null),
          _buildActionItem('assets/icon/leave.png', 'Leave', null),
          _buildActionItem('assets/icon/payslip.png', 'Payslip', () {
            Navigator.of(
              context,
              rootNavigator: true,
            ).push(MaterialPageRoute(builder: (_) => const PayslipPage()));
          }),
        ],
      ),
    );
  }

  Widget _buildActionItem(String icon, String label, VoidCallback? onTap) {
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
            child: Image.asset(icon, scale: 4),
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
    final list = List<Attendance>.generate(
      5,
      (index) => Attendance(
        id: "$index",
        clockIn: "${DateTime.now().hour}:${DateTime.now().minute}",
        clockOut: "${DateTime.now().hour + 8}:${DateTime.now().minute}",
        date: "Monday, 13 April 2026",
        status: "Present",
      ),
    ).toList(); // Placeholder for attendance data
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
                onPressed: () {},
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
          Column(
            children: list
                .map((e) => AttedanceListTile(attandance: e))
                .toList(),
          ),
        ],
      ),
    );
  }
}
