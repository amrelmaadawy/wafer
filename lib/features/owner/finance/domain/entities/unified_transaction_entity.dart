import 'package:equatable/equatable.dart';

enum UnifiedTransactionType { receipt, payment, transfer, adjustment }

class UnifiedTransactionEntity extends Equatable {
  final int id;
  final String referenceNumber;
  final UnifiedTransactionType type;
  final String date;
  final num amount;
  final bool isPositive;
  final String? propertyName;
  final String? unitName;
  final String? contractNumber;
  final String status;
  final String? partyName;
  final String? notes;

  const UnifiedTransactionEntity({
    required this.id,
    required this.referenceNumber,
    required this.type,
    required this.date,
    required this.amount,
    required this.isPositive,
    this.propertyName,
    this.unitName,
    this.contractNumber,
    required this.status,
    this.partyName,
    this.notes,
  });

  @override
  List<Object?> get props => [
        id,
        referenceNumber,
        type,
        date,
        amount,
        isPositive,
        propertyName,
        unitName,
        contractNumber,
        status,
        partyName,
        notes,
      ];
}
