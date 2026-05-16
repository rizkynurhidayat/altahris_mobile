import 'package:altahris_mobile/core/theme/app_colors.dart';
import 'package:altahris_mobile/core/widgets/logout_confirm_dialog.dart';
import 'package:altahris_mobile/features/home/domain/entities/employee.dart';
import 'package:altahris_mobile/features/home/presentation/bloc/home_bloc.dart';
import 'package:altahris_mobile/features/home/presentation/bloc/home_event.dart';
import 'package:altahris_mobile/features/home/presentation/pages/profile_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';
import '../../../auth/presentation/pages/login_page.dart';

class ProfilePage extends StatelessWidget {
  final Employee? employee;

  const ProfilePage({super.key, this.employee});

  String _getInitials(String name) {
    if (name.isEmpty) return '??';
    List<String> parts = name.trim().split(' ');
    if (parts.length == 1) {
      return parts[0][0].toUpperCase();
    }
    return (parts.first[0][0] + parts.last[0][0]).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    if (employee == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background, // Light grey background like in the image
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<HomeBloc>().add(const FetchHomeData(isRefresh: true));
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              _buildHeader(context),
              const SizedBox(height: 24),
              _buildMenuList(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final String name = employee!.user.name;
    final String position = employee!.position.name;

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
        bottom: false,
        child: Column(
          children: [
            const SizedBox(height: 10),
            Text(
              'Profile',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),
            Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: CircleAvatar(
                radius: 45,
                backgroundColor: AppColors.primary,
                child: Text(
                  _getInitials(name),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              position,
              style: const TextStyle(color: Colors.white70, fontSize: 14),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuList(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          // Section 1: Account
          _buildMenuSection([
            _buildMenuItem(
              icon: Icons.person_outline,
              title: 'Personal Information',
              onTap: () {
                Navigator.of(context, rootNavigator: true).push(
                  MaterialPageRoute(
                    builder: (_) => ProfileDetailPage(
                      employee: employee!,
                      section: ProfileSection.personal,
                    ),
                  ),
                );
              },
            ),
            _buildDivider(),
            _buildMenuItem(
              icon: Icons.work_outline,
              title: 'Employment Info',
              onTap: () {
                Navigator.of(context, rootNavigator: true).push(
                  MaterialPageRoute(
                    builder: (_) => ProfileDetailPage(
                      employee: employee!,
                      section: ProfileSection.employment,
                    ),
                  ),
                );
              },
            ),
            _buildDivider(),
            _buildMenuItem(
              icon: Icons.account_balance_wallet_outlined,
              title: 'Financial & Insurance',
              onTap: () {
                Navigator.of(context, rootNavigator: true).push(
                  MaterialPageRoute(
                    builder: (_) => ProfileDetailPage(
                      employee: employee!,
                      section: ProfileSection.financial,
                    ),
                  ),
                );
              },
            ),
          ]),
          const SizedBox(height: 20),
          
          // Section 2: Settings
          // _buildMenuSection([
          //   _buildMenuItem(
          //     icon: Icons.security_outlined,
          //     title: 'Security',
          //     onTap: () {
          //       // Placeholder
          //     },
          //   ),
          //   _buildDivider(),
          //   _buildMenuItem(
          //     icon: Icons.notifications_none_outlined,
          //     title: 'Notifications',
          //     onTap: () {
          //       // Placeholder
          //     },
          //   ),
          //   _buildDivider(),
          //   _buildMenuItem(
          //     icon: Icons.help_outline,
          //     title: 'Help & Support',
          //     onTap: () {
          //       // Placeholder
          //     },
          //   ),
          // ]),
          // const SizedBox(height: 20),

          // Section 3: Logout
          _buildMenuSection([
            _buildMenuItem(
              icon: Icons.logout,
              title: 'Logout',
              titleColor: Colors.red,
              iconColor: Colors.red,
              hideChevron: true,
              onTap: () {
                _showLogoutConfirmation(context);
              },
            ),
          ]),
          const SizedBox(height: 100), // space for bottom nav
        ],
      ),
    );
  }

  Widget _buildMenuSection(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(5),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: children,
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 1,
      color: Colors.grey.shade100,
      indent: 64, // Align with text
      endIndent: 16,
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? titleColor,
    Color? iconColor,
    bool hideChevron = false,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: (iconColor ?? Colors.grey.shade600).withAlpha(15),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: iconColor ?? Colors.grey.shade700, size: 22),
      ),
      title: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: titleColor ?? AppColors.textPrimary,
        ),
      ),
      trailing: hideChevron
          ? null
          : Icon(Icons.arrow_forward_ios, color: Colors.grey.shade400, size: 16),
      onTap: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    );
  }

  void _showLogoutConfirmation(BuildContext context) {
    LogoutConfirmDialog.show(
      context,
      onConfirm: () {
        context.read<AuthBloc>().add(LogoutRequested());
        Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const LoginPage()),
          (route) => false,
        );
      },
    );
  }
}
