import 'package:equatable/equatable.dart';

class InstallmentStatsEntity extends Equatable {
  final int paid;
  final int partiallyPaid;
  final int unpaid;
  final int overdue;

  const InstallmentStatsEntity({
    required this.paid,
    required this.partiallyPaid,
    required this.unpaid,
    required this.overdue,
  });

  @override
  List<Object?> get props => [paid, partiallyPaid, unpaid, overdue];
}

class LatestOverdueInstallmentEntity extends Equatable {
  final int id;
  final num amount;
  final num paidAmount;
  final String status;
  final String dueDate;
  final String propertyName;
  final String unitName;
  final String tenantName;
  final String contractNumber;

  const LatestOverdueInstallmentEntity({
    required this.id,
    required this.amount,
    required this.paidAmount,
    required this.status,
    required this.dueDate,
    required this.propertyName,
    required this.unitName,
    required this.tenantName,
    required this.contractNumber,
  });

  @override
  List<Object?> get props => [
    id,
    amount,
    paidAmount,
    status,
    dueDate,
    propertyName,
    unitName,
    tenantName,
    contractNumber,
  ];
}
