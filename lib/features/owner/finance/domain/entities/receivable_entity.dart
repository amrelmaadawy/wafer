import 'package:equatable/equatable.dart';

class ReceivableEntity extends Equatable {
  final int id;
  final String tenantName;
  final num totalAmount;
  final num paidAmount;
  final num remainingAmount;
  final String? contractNumber;
  final String? propertyName;
  final String? unitName;
  final String dueDate;
  final String status; // 'pending', 'overdue', 'partial', 'paid'

  const ReceivableEntity({
    required this.id,
    required this.tenantName,
    required this.totalAmount,
    required this.paidAmount,
    required this.remainingAmount,
    this.contractNumber,
    this.propertyName,
    this.unitName,
    required this.dueDate,
    required this.status,
  });

  @override
  List<Object?> get props => [
        id,
        tenantName,
        totalAmount,
        paidAmount,
        remainingAmount,
        contractNumber,
        propertyName,
        unitName,
        dueDate,
        status,
      ];
}
