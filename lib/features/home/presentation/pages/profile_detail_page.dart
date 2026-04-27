import 'package:altahris_mobile/core/theme/app_colors.dart';
import 'package:altahris_mobile/features/home/domain/entities/Employee.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

enum ProfileSection { personal, employment, financial }

class ProfileDetailPage extends StatelessWidget {
  final Employee employee;
  final ProfileSection section;

  const ProfileDetailPage({
    super.key,
    required this.employee,
    required this.section,
  });

  String _getTitle() {
    switch (section) {
      case ProfileSection.personal:
        return 'Personal Information';
      case ProfileSection.employment:
        return 'Employment Info';
      case ProfileSection.financial:
        return 'Financial & Insurance';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          _getTitle(),
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (section == ProfileSection.employment)
              _buildInfoSection(
                title: 'Employment Information',
                icon: Icons.work_outline,
                children: [
                  _buildInfoRow('NIK', employee.nik),
                  _buildInfoRow('Employee No', employee.employeeNumber),
                  _buildInfoRow('Status', employee.employeeStatus),
                  _buildInfoRow('Department', employee.department.name),
                  _buildInfoRow('Position', employee.position.name),
                  _buildInfoRow('Job Level', employee.jobLevel.name),
                  _buildInfoRow('Grade', employee.grade.name),
                  _buildInfoRow('Join Date', _formatDate(employee.joinDate)),
                  _buildInfoRow('Contract Start', _formatDate(employee.contractStartDate)),
                  _buildInfoRow('Contract End', _formatDate(employee.contractEndDate)),
                ],
              ),
            if (section == ProfileSection.personal)
              _buildInfoSection(
                title: 'Personal Information',
                icon: Icons.person_outline,
                children: [
                  _buildInfoRow('Place of Birth', employee.birthPlace),
                  _buildInfoRow('Date of Birth', _formatDate(employee.birthDate)),
                  _buildInfoRow('Gender', employee.gender),
                  _buildInfoRow('Religion', employee.religion),
                  _buildInfoRow('Blood Type', employee.bloodType),
                  _buildInfoRow('Marital Status', employee.maritalStatus),
                  _buildInfoRow('Last Education', employee.lastEducation),
                ],
              ),
            if (section == ProfileSection.financial)
              _buildInfoSection(
                title: 'Financial & Insurance',
                icon: Icons.account_balance_wallet_outlined,
                children: [
                  _buildInfoRow('Bank Name', employee.bankName),
                  _buildInfoRow('Bank Account', employee.bankAccount),
                  _buildInfoRow('NPWP', employee.npwp),
                  _buildInfoRow('BPJS TK', employee.bpjsTkNo),
                  _buildInfoRow('BPJS Kesehatan', employee.bpjsKesNo),
                ],
              ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: AppColors.primary, size: 20),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    final displayValue = (value.isEmpty || value == 'null') ? '-' : value;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              displayValue,
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty || dateStr == 'null') return '-';
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('dd MMM yyyy').format(date);
    } catch (_) {
      return dateStr;
    }
  }
}
