import 'package:altahris_mobile/core/theme/app_colors.dart';
import 'package:altahris_mobile/features/home/presentation/pages/activity_page.dart';
import 'package:altahris_mobile/features/home/presentation/pages/notification_page.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import '../../../../core/widgets/success_dialog.dart';
import 'dashboard_page.dart';
import 'profile_page.dart';

class HomePage extends StatefulWidget {
  final String userName;

  const HomePage({super.key, required this.userName});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PersistentTabController _controller = PersistentTabController(initialIndex: 0);
  bool _isClockedIn = false;

  void _onClockButtonPressed(BuildContext context) {
    setState(() {
      _isClockedIn = !_isClockedIn;
    });

    if (_isClockedIn) {
      SuccessDialog.show(
        context,
        title: 'Berhasil Clock In',
        message: 'Selamat bekerja! Jangan lupa istirahat.',
      );
    } else {
      SuccessDialog.show(
        context,
        title: 'Berhasil Clock Out',
        message: 'Hati-hati di jalan pulang!',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      controller: _controller,
      navBarOverlap: NavBarOverlap.full(),
      tabs: [
        PersistentTabConfig(
          screen: DashboardPage(userName: widget.userName),
          item: ItemConfig(
            icon: const ImageIcon(AssetImage('assets/icon/home.png')),
            title: "Home",
            activeForegroundColor: AppColors.primary,
            inactiveForegroundColor: Colors.grey,
          ),
        ),
        PersistentTabConfig(
          screen: const NotificationPage(),
          item: ItemConfig(
            icon: const ImageIcon(AssetImage('assets/icon/bell.png')),
            title: "notification",
            activeForegroundColor: AppColors.primary,
            inactiveForegroundColor: Colors.grey,
          ),
        ),
        PersistentTabConfig.noScreen(
          onPressed: _onClockButtonPressed,
          item: ItemConfig(
            icon: Container(
              padding: const EdgeInsets.all(13),
              decoration: BoxDecoration(
                color: _isClockedIn ? AppColors.primary : AppColors.succesGreen,
                shape: BoxShape.circle,
              ),
              child: Icon(_isClockedIn ? Icons.logout_rounded : Icons.login_rounded, color: Colors.white)),
            // title: "Clock In",
            activeForegroundColor: _isClockedIn ? Colors.orange.shade900 : Colors.green.shade500,
            inactiveForegroundColor: Colors.grey,
            iconSize: 35
          ),
        ),
        PersistentTabConfig(
          screen: const ActivityPage(),
          item: ItemConfig(
            icon: const ImageIcon(AssetImage('assets/icon/clipboard.png')), // Placeholder icon for Activity
            title: "Activity",
            activeForegroundColor: AppColors.primary,
            inactiveForegroundColor: Colors.grey,
          ),
        ),
        PersistentTabConfig(
          screen: ProfilePage(userName: widget.userName),
          item: ItemConfig(
            icon: const ImageIcon(AssetImage('assets/icon/user.png')),
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
