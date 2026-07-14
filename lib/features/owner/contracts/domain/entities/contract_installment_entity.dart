import 'package:equatable/equatable.dart';

class ContractInstallmentEntity extends Equatable {
  final int id;
  final int installmentNumber;
  final String dueDate;
  final double amount;
  final double paidAmount;
  final double remaining;
  final String status;
  final String statusLabel;

  const ContractInstallmentEntity({
    required this.id,
    required this.installmentNumber,
    required this.dueDate,
    required this.amount,
    required this.paidAmount,
    required this.remaining,
    required this.status,
    required this.statusLabel,
  });

  @override
  List<Object?> get props => [
        id,
        installmentNumber,
        dueDate,
        amount,
        paidAmount,
        remaining,
        status,
        statusLabel,
      ];
}
