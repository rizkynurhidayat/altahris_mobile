import 'package:altahris_mobile/features/home/domain/usecases/clock_in.dart';
import 'package:altahris_mobile/features/home/domain/usecases/clock_out.dart';
import 'package:altahris_mobile/features/home/domain/usecases/get_employee.dart';
import 'package:altahris_mobile/features/home/domain/usecases/get_attendance.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetAttendanceUseCase getAttendanceUseCase;
  final GetEmployeeMeUseCase getEmployeeMeUseCase;
  final ClockInUseCase clockInUseCase;
  final ClockOutUseCase clockOutUseCase;

  HomeBloc({
    required this.getAttendanceUseCase,
    required this.getEmployeeMeUseCase,
    required this.clockInUseCase,
    required this.clockOutUseCase,
  }) : super(HomeInitial()) {
    on<FetchHomeData>(_onFetchHomeData);
    on<PerformClockIn>(_onPerformClockIn);
    on<PerformClockOut>(_onPerformClockOut);
    // Keep FetchAttendance for backward compatibility if needed,
    // but ideally use FetchHomeData
    on<FetchAttendance>((event, emit) => add(FetchHomeData()));
  }

  Future<void> _onFetchHomeData(
    FetchHomeData event,
    Emitter<HomeState> emit,
  ) async {
    emit(HomeLoading());

    // 1. Get Employee first
    final employeeResult = await getEmployeeMeUseCase.execute();

    await employeeResult.fold(
      (failure) async {
        // If getting employee fails (e.g. invalid token), we still try to show
        // whatever state is appropriate, but here we emit HomeFailure
        emit(HomeFailure(failure.message));
      },
      (employee) async {
        // 2. Then Get Attendance
        final attendanceResult = await getAttendanceUseCase.execute();

        attendanceResult.fold((failure) => emit(HomeFailure(failure.message)), (
          attendance,
        ) {
          /*
          else if (attendance.length > 3) {
            final limit = attendance.getRange(0, 3).toList();
            emit(HomeLoaded(limit, employee));
          }
          */

          if (attendance.isEmpty) {
            emit(HomeLoaded([], employee));
          } else if (attendance.length > 3) {
            final limit = attendance.getRange(0, 3).toList();
            emit(HomeLoaded(limit, employee));
          } else {
            emit(HomeLoaded(attendance, employee));
          }
        });
      },
    );
  }

  Future<void> _onPerformClockIn(
    PerformClockIn event,
    Emitter<HomeState> emit,
  ) async {
    emit(ClockInLoading());

    final result = await clockInUseCase.execute(
      imagePath: event.imagePath,
      latitude: event.latitude,
      longitude: event.longitude,
      notes: event.notes,
    );

    await result.fold(
      (failure) async => emit(ClockInFailure(failure.message)),
      (success) async {
        emit(ClockInSuccess());
        // Auto refresh home data after successful clock in
        add(FetchHomeData());
      },
    );
  }

  Future<void> _onPerformClockOut(
    PerformClockOut event,
    Emitter<HomeState> emit,
  ) async {
    emit(ClockOutLoading());

    final result = await clockOutUseCase.execute(
      imagePath: event.imagePath,
      latitude: event.latitude,
      longitude: event.longitude,
      notes: event.notes,
    );

    await result.fold(
      (failure) async => emit(ClockOutFailure(failure.message)),
      (success) async {
        emit(ClockOutSuccess());
        // Auto refresh home data after successful clock out
        add(FetchHomeData());
      },
    );
  }
}
