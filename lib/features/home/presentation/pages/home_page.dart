import 'package:altahris_mobile/core/theme/app_colors.dart';
import 'package:altahris_mobile/features/home/presentation/pages/notification_page.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import '../../../../core/widgets/success_dialog.dart';
import '../../../history/presentation/pages/history_page.dart';
import 'dashboard_page.dart';
import '../../../payslip/presentation/pages/payslip_page.dart';
import 'profile_page.dart';

class HomePage extends StatefulWidget {
  final String userName;

  const HomePage({super.key, required this.userName});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PersistentTabController _controller = PersistentTabController(initialIndex: 0);

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      controller: _controller,
      navBarOverlap: NavBarOverlap.full(),
      tabs: [
        PersistentTabConfig(
          screen: DashboardPage(userName: widget.userName),
          item: ItemConfig(
            icon: const Icon(Icons.home_outlined),
            title: "Home",
            activeForegroundColor: AppColors.primary,
            inactiveForegroundColor: Colors.grey,
          ),
        ),
        PersistentTabConfig(
          screen: const NotificationPage(),
          item: ItemConfig(
            icon: const Icon(Icons.notifications_outlined),
            title: "notification",
            activeForegroundColor: AppColors.primary,
            inactiveForegroundColor: Colors.grey,
          ),
        ),
        PersistentTabConfig.noScreen(
          onPressed: (context) {
            SuccessDialog.show(
              context,
              title: 'Berhasil Clock In',
              message: 'Selamat bekerja! Jangan lupa istirahat.',
            );
          },
          item: ItemConfig(
            icon: const Icon(Icons.login_rounded, color: Colors.white),
            // title: "Clock In",
            activeForegroundColor: AppColors.primary,
            inactiveForegroundColor: Colors.grey,
            iconSize: 35
          ),
        ),
        PersistentTabConfig(
          screen: const HistoryPage(),
          item: ItemConfig(
            icon: const Icon(Icons.content_paste_rounded), // Placeholder icon for Activity
            title: "Activity",
            activeForegroundColor: AppColors.primary,
            inactiveForegroundColor: Colors.grey,
          ),
        ),
        PersistentTabConfig(
          screen: ProfilePage(userName: widget.userName),
          item: ItemConfig(
            icon: const Icon(Icons.person_outline),
            title: "Account",
            activeForegroundColor: AppColors.primary,
            inactiveForegroundColor: Colors.grey,
          ),
        ),
      ],
      navBarBuilder: (navBarConfig) => Style13BottomNavBar(
        navBarConfig: navBarConfig,
        height: 70,
        middleItemSize: 70,
       
      ),
    );
  }
}
