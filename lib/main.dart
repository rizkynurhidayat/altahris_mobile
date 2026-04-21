import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:altahris_mobile/core/di/injection_container.dart' as di;
import 'package:altahris_mobile/core/di/injection_container.dart' show sl;
import 'package:altahris_mobile/core/theme/app_theme.dart';
import 'package:altahris_mobile/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:altahris_mobile/features/auth/presentation/bloc/auth_event.dart';
import 'package:altahris_mobile/features/auth/presentation/pages/splash_page.dart';
import 'package:altahris_mobile/features/attendance/presentation/bloc/attendance_bloc.dart';
import 'package:altahris_mobile/features/leave/presentation/bloc/leave_bloc.dart';
import 'package:altahris_mobile/features/notification/presentation/bloc/notification_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Dependency Injection
  await di.init();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => sl<AuthBloc>()..add(AppStarted()),
        ),
        BlocProvider(
          create: (context) => sl<AttendanceBloc>(),
        ),
        BlocProvider(
          create: (context) => sl<LeaveBloc>(),
        ),
        BlocProvider(
          create: (context) => sl<NotificationBloc>(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Altahris Mobile',
        theme: AppTheme.light,
        home: const SplashPage(),
      ),
    );
  }
}
