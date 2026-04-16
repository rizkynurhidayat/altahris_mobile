import 'package:altahris_mobile/features/home/domain/usecases/get_attendance.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetAttendanceUseCase getAttendanceUseCase;

  HomeBloc({required this.getAttendanceUseCase}) : super(HomeInitial()) {
    on<FetchAttendance>(_onFetchAttendance);
  }

  Future<void> _onFetchAttendance(
    FetchAttendance event,
    Emitter<HomeState> emit,
  ) async {
    emit(HomeLoading());
    final result = await getAttendanceUseCase.execute(id: '');
    result.fold(
      (failure) => emit(HomeFailure(failure.message)),
      (history) => emit(HomeLoaded(history)),
    );
  }
}
