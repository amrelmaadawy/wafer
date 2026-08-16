import 'package:equatable/equatable.dart';

class PayableEntity extends Equatable {
  final int id;
  final String partyName;
  final num totalAmount;
  final num paidAmount;
  final num remainingAmount;
  final String? propertyName;
  final String? unitName;
  final String dueDate;
  final String status; // 'pending', 'overdue', 'partial', 'paid'
  final String? notes;

  const PayableEntity({
    required this.id,
    required this.partyName,
    required this.totalAmount,
    required this.paidAmount,
    required this.remainingAmount,
    this.propertyName,
    this.unitName,
    required this.dueDate,
    required this.status,
    this.notes,
  });

  @override
  List<Object?> get props => [
        id,
        partyName,
        totalAmount,
        paidAmount,
        remainingAmount,
        propertyName,
        unitName,
        dueDate,
        status,
        notes,
      ];
}
