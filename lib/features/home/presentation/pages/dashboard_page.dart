import 'package:flutter/material.dart';
import '../../../../core/widgets/success_dialog.dart';

class DashboardPage extends StatelessWidget {
  final String userName;

  const DashboardPage({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Altahris HRIS'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Company Info & User Welcome
            _buildHeader(context),
            const SizedBox(height: 24),
            
            // Attendance Card
            _buildAttendanceCard(context),
            const SizedBox(height: 24),
            
            // Menu Grid
            Text(
              'Layanan Mandiri',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildMenuGrid(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.orange[800],
            child: Text(
              userName.isNotEmpty ? userName.substring(0, 1).toUpperCase() : '?',
              style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Halo, $userName',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Text(
                  'PT. Altahris Solusi Teknologi',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttendanceCard(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Text(
              '13 April 2026',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const Text(
              '09:00 AM',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      SuccessDialog.show(
                        context,
                        title: 'Berhasil Clock In',
                        message: 'Selamat bekerja! Jangan lupa istirahat.',
                      );
                    },
                    icon: const Icon(Icons.login),
                    label: const Text('CLOCK IN'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      SuccessDialog.show(
                        context,
                        title: 'Berhasil Clock Out',
                        message: 'Hati-hati di jalan pulang!',
                      );
                    },
                    icon: const Icon(Icons.logout),
                    label: const Text('CLOCK OUT'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuGrid() {
    final menus = [
      {'icon': Icons.calendar_month, 'label': 'Cuti', 'color': Colors.blue},
      {'icon': Icons.timer, 'label': 'Lembur', 'color': Colors.purple},
      {'icon': Icons.receipt_long, 'label': 'Reimbursement', 'color': Colors.teal},
      {'icon': Icons.description, 'label': 'Dokumen', 'color': Colors.amber},
      {'icon': Icons.info_outline, 'label': 'Pengumuman', 'color': Colors.indigo},
      {'icon': Icons.help_outline, 'label': 'Bantuan', 'color': Colors.blueGrey},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.9,
      ),
      itemCount: menus.length,
      itemBuilder: (context, index) {
        return Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: (menus[index]['color'] as Color).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                menus[index]['icon'] as IconData,
                color: menus[index]['color'] as Color,
                size: 30,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              menus[index]['label'] as String,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            ),
          ],
        );
      },
    );
  }
}
