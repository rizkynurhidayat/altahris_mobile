import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/success_dialog.dart';
import '../../../history/presentation/bloc/history_bloc.dart';
import '../../../history/presentation/bloc/history_event.dart';
import '../../../history/presentation/pages/history_page.dart';
import 'dashboard_page.dart';
import 'gaji_page.dart';
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
            activeForegroundColor: Colors.orange[800]!,
            inactiveForegroundColor: Colors.grey,
          ),
        ),
        PersistentTabConfig(
          screen: const GajiPage(), // Placeholder for Notification
          item: ItemConfig(
            icon: const Icon(Icons.notifications_none_outlined),
            title: "Notification",
            activeForegroundColor: Colors.orange[800]!,
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
            icon: const Icon(Icons.login_rounded, size: 28, color: Colors.white),
            title: "Clock In",
            activeForegroundColor: Colors.orange[800]!,
            inactiveForegroundColor: Colors.grey,
          ),
        ),
        PersistentTabConfig(
          screen: const HistoryPage(),
          item: ItemConfig(
            icon: const Icon(Icons.notifications_none_outlined), // Placeholder icon for Activity
            title: "Activity",
            activeForegroundColor: Colors.orange[800]!,
            inactiveForegroundColor: Colors.grey,
          ),
        ),
        PersistentTabConfig(
          screen: ProfilePage(userName: widget.userName),
          item: ItemConfig(
            icon: const Icon(Icons.person_outline),
            title: "Account",
            activeForegroundColor: Colors.orange[800]!,
            inactiveForegroundColor: Colors.grey,
          ),
        ),
      ],
      navBarBuilder: (navBarConfig) => Style13BottomNavBar(
        navBarConfig: navBarConfig,
      ),
    );
  }
}
