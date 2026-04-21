import 'package:equatable/equatable.dart';

abstract class PayslipEvent extends Equatable {
  const PayslipEvent();

  @override
  List<Object> get props => [];
}

class GetPayslipsMeEvent extends PayslipEvent {}
