import 'package:get_it/get_it.dart';
import 'package:altahris_mobile/core/di/core_injector.dart';
import 'package:altahris_mobile/features/auth/auth_injector.dart';
import 'package:altahris_mobile/features/attendance/attendance_injector.dart';
import 'package:altahris_mobile/features/home/home_injector.dart';
import 'package:altahris_mobile/features/payslip/payslip_injector.dart';
import 'package:altahris_mobile/features/leave/leave_injector.dart';
import 'package:altahris_mobile/features/notification/notification_injector.dart';
import 'package:altahris_mobile/features/visit_plan/visit_plan_injector.dart';
import 'package:altahris_mobile/features/visit/visit_injector.dart';

final sl = GetIt.instance;

/// Main Dependency Injection Initialization
///
/// This function initializes all the core and feature-specific
/// dependencies. It is called at the start of the application.
Future<void> init() async {
  // Core dependencies (Shared)
  await initCore(sl);

  // Feature dependencies
  initAuth(sl);
  initHistory(sl);
  initHome(sl);
  initPayslip(sl);
  initLeave(sl);
initNotification(sl);
   initVisitPlanInjector(sl);
   initVisit(sl);
 }
