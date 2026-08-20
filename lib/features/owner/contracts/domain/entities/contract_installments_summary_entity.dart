import 'package:equatable/equatable.dart';
import 'contract_installment_entity.dart';

class ContractInstallmentsSummaryEntity extends Equatable {
  final int installmentsCount;
  final int paidCount;
  final int unpaidCount;
  final int partialCount;
  final double totalAmount;
  final double paidAmount;
  final double remainingAmount;
  final String nextDueDate;

  const ContractInstallmentsSummaryEntity({
    required this.installmentsCount,
    required this.paidCount,
    required this.unpaidCount,
    required this.partialCount,
    required this.totalAmount,
    required this.paidAmount,
    required this.remainingAmount,
    required this.nextDueDate,
  });

  double get paidProgress => totalAmount == 0 ? 0 : (paidAmount / totalAmount).clamp(0, 1);

  factory ContractInstallmentsSummaryEntity.fromInstallments(
    List<ContractInstallmentEntity> installments,
  ) {
    final total = installments.fold<double>(0, (sum, item) => sum + item.amount);
    final paid = installments.fold<double>(0, (sum, item) => sum + item.paidAmount);
    final remaining = installments.fold<double>(0, (sum, item) => sum + item.remaining);
    
    final paidCount = installments.where((item) => item.status == 'paid').length;
    final unpaidCount = installments.where((item) => item.status == 'unpaid').length;
    final partialCount = installments.where((item) => item.status == 'partial').length;
    
    final unpaidInstallments = installments.where((item) => item.status != 'paid').toList()
      ..sort((a, b) => a.dueDate.compareTo(b.dueDate));
      
    return ContractInstallmentsSummaryEntity(
      installmentsCount: installments.length,
      paidCount: paidCount,
      unpaidCount: unpaidCount,
      partialCount: partialCount,
      totalAmount: total,
      paidAmount: paid,
      remainingAmount: remaining,
      nextDueDate: unpaidInstallments.isNotEmpty ? unpaidInstallments.first.dueDate : '',
    );
  }

  @override
  List<Object?> get props => [
    installmentsCount,
    paidCount,
    unpaidCount,
    partialCount,
    totalAmount,
    paidAmount,
    remainingAmount,
    nextDueDate,
  ];
}
