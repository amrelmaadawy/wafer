import 'package:equatable/equatable.dart';

class PropertySummaryEntity extends Equatable {
  final num required;
  final num due;
  final num collected;
  final num expenses;
  final num commissions;
  final num payments;
  final num insurances;
  final num balance;

  const PropertySummaryEntity({
    this.required = 0,
    this.due = 0,
    this.collected = 0,
    this.expenses = 0,
    this.commissions = 0,
    this.payments = 0,
    this.insurances = 0,
    this.balance = 0,
  });

  @override
  List<Object?> get props => [
    required,
    due,
    collected,
    expenses,
    commissions,
    payments,
    insurances,
    balance,
  ];
}
