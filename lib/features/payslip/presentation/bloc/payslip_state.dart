import 'package:equatable/equatable.dart';
import '../../domain/entities/payroll.dart';

abstract class PayslipState extends Equatable {
  const PayslipState();

  @override
  List<Object> get props => [];
}

class PayslipInitial extends PayslipState {}

class PayslipLoading extends PayslipState {}

class PayslipLoaded extends PayslipState {
  final List<Payroll> payrolls;

  const PayslipLoaded(this.payrolls);

  @override
  List<Object> get props => [payrolls];
}

class PayslipError extends PayslipState {
  final String message;

  const PayslipError(this.message);

  @override
  List<Object> get props => [message];
}
