import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_all_payroll_usecase.dart';
import 'payslip_event.dart';
import 'payslip_state.dart';

class PayslipBloc extends Bloc<PayslipEvent, PayslipState> {
  final GetPayrollsMeUsecase getPayrollsMeUsecase;

  PayslipBloc({required this.getPayrollsMeUsecase}) : super(PayslipInitial()) {
    on<GetPayslipsMeEvent>(_onGetPayslipsMe);
  }

  Future<void> _onGetPayslipsMe(
    GetPayslipsMeEvent event,
    Emitter<PayslipState> emit,
  ) async {
    emit(PayslipLoading());
    final result = await getPayrollsMeUsecase.execute();
    result.fold(
      (failure) => emit(PayslipError(failure.message)),
      (payrolls) => emit(PayslipLoaded(payrolls)),
    );
  }
}
