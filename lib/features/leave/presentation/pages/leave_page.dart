import 'package:altahris_mobile/features/leave/domain/entities/leave.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:altahris_mobile/core/theme/app_colors.dart';
import '../bloc/leave_bloc.dart';
import '../bloc/leave_event.dart';
import '../bloc/leave_state.dart';
import '../../../../core/widgets/index.dart';
import 'request_leave_page.dart';

class LeavePage extends StatefulWidget {
  const LeavePage({super.key});

  @override
  State<LeavePage> createState() => _LeavePageState();
}

class _LeavePageState extends State<LeavePage> {
  int _selectedTab = 0; // 0 for Annual, 1 for Types

  @override
  void initState() {
    super.initState();
    _fetchHistory();
  }

  void _fetchHistory() {
    context.read<LeaveBloc>().add(const FetchLeaveHistory());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Leave',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textPrimary,
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          _buildToggleMenu(),
          Expanded(
            child: BlocBuilder<LeaveBloc, LeaveState>(
              builder: (context, state) {
                if (state is LeaveLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is LeaveLoaded) {
                  return RefreshIndicator(
                    onRefresh: () async => _fetchHistory(),
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _selectedTab == 0
                              ? _buildAnnualView(state.leaves)
                              : _buildTypesView(state.leaves),
                          const SizedBox(height: 24),
                          const Text(
                            'History',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 12),
                          if (state.leaves.isEmpty)
                            _buildEmptyState()
                          else
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: state.leaves.length,
                              itemBuilder: (context, index) {
                                return LeaveListTile(
                                  leave: state.leaves[index],
                                );
                              },
                            ),
                          const SizedBox(height: 80), // Space for bottom button
                        ],
                      ),
                    ),
                  );
                } else if (state is LeaveFailure) {
                  return CustomErrorWidget(
                    message: state.message,
                    onRetry: _fetchHistory,
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
      bottomSheet: _buildBottomButton(),
    );
  }

  Widget _buildToggleMenu() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildTabItem(0, 'assets/icon/calendar-clock.png', 'Annual'),
          ),
          Expanded(
            child: _buildTabItem(1, 'assets/icon/type_menu.png', 'Types'),
          ),
        ],
      ),
    );
  }

  Widget _buildTabItem(int index, String icon, String label) {
    bool isSelected = _selectedTab == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedTab = index),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ImageIcon(
              AssetImage(icon),
              size: 18,
              color: isSelected ? Colors.white : Colors.grey,
            ),

            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  int _calculateDays(List<Leave> leaves, String type) {
    return leaves
        .where((l) =>
            l.leaveType == type && l.status.toLowerCase() == 'approved')
        .fold(0, (sum, l) => sum + l.totalDays);
  }

  Widget _buildAnnualView(List<Leave> leaves) {
    final usedDays = _calculateDays(leaves, 'cuti_tahunan');
    const maxDays = 12;
    final remainingDays = (maxDays - usedDays).clamp(0, maxDays);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            'Annual Leave',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          const Divider(),
          const SizedBox(height: 16),
          RichText(
            text: TextSpan(
              style: const TextStyle(color: AppColors.textPrimary, fontSize: 18),
              children: [
                TextSpan(
                  text: '$usedDays',
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
                const TextSpan(
                  text: '/$maxDays',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                ),
                const TextSpan(
                  text: ' Days used',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: usedDays / maxDays,
              minHeight: 12,
              backgroundColor: Colors.grey.shade200,
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppColors.primary,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            '*$remainingDays Days Remaining',
            style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildTypesView(List<Leave> leaves) {
    final types = [
      {
        'id': 'cuti_tahunan',
        'name': 'Annual Leave',
        'icon': 'assets/icon/period_leave.png',
        'color': Colors.red,
      },
      {
        'id': 'cuti_sakit',
        'name': 'Sick Leave',
        'icon': 'assets/icon/Sick_leave.png',
        'color': Colors.red,
      },
      {
        'id': 'cuti_melahirkan',
        'name': 'Maternity Leave',
        'icon': 'assets/icon/maternity_leave.png',
        'color': Colors.orange,
      },
      {
        'id': 'cuti_besar',
        'name': 'Special Leave',
        'icon': 'assets/icon/special_leave.png',
        'color': Colors.deepOrange,
      },
      {
        'id': 'izin',
        'name': 'Permission',
        'icon': 'assets/icon/unpaid_leave.png',
        'color': Colors.orange,
      },
      {
        'id': 'dinas_luar',
        'name': 'Business Trip',
        'icon': 'assets/icon/hajj_leave.png',
        'color': Colors.orange,
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2.2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: types.length,
      itemBuilder: (context, index) {
        final type = types[index];
        final takenDays = _calculateDays(leaves, type['id'] as String);

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade100),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                child: Image.asset(
                  type['icon'] as String,
                  scale: 4,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      type['name'] as String,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      '$takenDays Days Taken',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey.shade400,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBottomButton() {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 16, ),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.white12)),
      ),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const RequestLeavePage()),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(0),
            elevation: 0,
          ),
          child: const Text(
            'Request Leave',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 40),
          Icon(Icons.history_edu, size: 60, color: Colors.grey.shade200),
          const SizedBox(height: 16),
          const Text(
            'No leave history found',
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
