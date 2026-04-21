import 'package:altahris_mobile/core/theme/app_colors.dart';
import 'package:altahris_mobile/features/home/presentation/bloc/home_bloc.dart';
import 'package:altahris_mobile/features/home/presentation/bloc/home_state.dart';
import 'package:altahris_mobile/features/home/presentation/pages/activity_page.dart';
import 'package:altahris_mobile/features/home/presentation/pages/clock_in_page.dart';
import 'package:altahris_mobile/features/notification/presentation/pages/notification_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'dashboard_page.dart';
import 'profile_page.dart';
import 'package:altahris_mobile/core/di/injection_container.dart';

import 'package:altahris_mobile/features/auth/domain/entities/user.dart';

class HomePage extends StatefulWidget {
  final User user;

  const HomePage({super.key, required this.user});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PersistentTabController _controller = PersistentTabController(
    initialIndex: 0,
  );
  late HomeBloc _homeBloc;

  @override
  void initState() {
    super.initState();
    _homeBloc = sl<HomeBloc>();
  }

  bool _isClockedInToday(HomeState state) {
    if (state is HomeLoaded && state.attendance.isNotEmpty) {
      final latest = state.attendance.first;
      final now = DateTime.now();
      try {
        final clockInDate = DateTime.parse(latest.clockIn);
        final isToday = clockInDate.year == now.year &&
            clockInDate.month == now.month &&
            clockInDate.day == now.day;
        
        // Check if clocked in but NOT clocked out yet
        return isToday && (latest.clockOut == null || latest.clockOut!.isEmpty || latest.clockOut == '--:--');
      } catch (_) {}
    }
    return false;
  }

  void _onClockButtonPressed(BuildContext context, bool isClockIn) {
    pushScreen(
      context,
      screen: ClockInPage(isClockIn: isClockIn),
      withNavBar: false,
      pageTransitionAnimation: PageTransitionAnimation.fade,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _homeBloc,
      child: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          final isClockedIn = _isClockedInToday(state);
          final buttonColor = isClockedIn ? AppColors.primary : Colors.green;
          final buttonBorderColor = isClockedIn ? Colors.orange.shade900 : Colors.green.shade600;
          final isClockInAction = !isClockedIn;

          return PersistentTabView(
            controller: _controller,
            navBarOverlap: NavBarOverlap.full(),
            tabs: [
              PersistentTabConfig(
                screen: DashboardPage(user: widget.user),
                item: ItemConfig(
                  icon: const ImageIcon(AssetImage('assets/icon/home.png')),
                  title: "Home",
                  activeForegroundColor: AppColors.primary,
                  inactiveForegroundColor: Colors.grey,
                ),
              ),
              PersistentTabConfig(
                screen: NotificationPage(),
                item: ItemConfig(
                  icon: const ImageIcon(AssetImage('assets/icon/bell.png')),
                  title: "Notifications",
                  activeForegroundColor: AppColors.primary,
                  inactiveForegroundColor: Colors.grey,
                ),
              ),
              PersistentTabConfig.noScreen(
                onPressed: (context) => _onClockButtonPressed(context, isClockInAction),
                item: ItemConfig(
                  icon: Container(
                    padding: const EdgeInsets.all(13),
                    decoration: BoxDecoration(
                      color: buttonColor,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isClockInAction ? Icons.login_rounded : Icons.logout_rounded,
                      color: Colors.white,
                    ),
                  ),
                  activeForegroundColor: buttonBorderColor,
                  inactiveForegroundColor: Colors.grey,
                  iconSize: 35,
                ),
              ),
              PersistentTabConfig(
                screen: const ActivityPage(),
                item: ItemConfig(
                  icon: const ImageIcon(AssetImage('assets/icon/clipboard.png')),
                  title: "Activity",
                  activeForegroundColor: AppColors.primary,
                  inactiveForegroundColor: Colors.grey,
                ),
              ),
              PersistentTabConfig(
                screen: ProfilePage(userName: widget.user.name),
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
        },
      ),
    );
  }
}
