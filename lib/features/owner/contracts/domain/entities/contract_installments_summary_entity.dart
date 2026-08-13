import 'package:equatable/equatable.dart';
import 'contract_installment_entity.dart';

class ContractInstallmentsSummaryEntity extends Equatable {
  final double totalAmount;
  final double paidAmount;
  final double remainingAmount;
  final int installmentsCount;
  final int paidCount;
  final double paidProgress;

  const ContractInstallmentsSummaryEntity({
    required this.totalAmount,
    required this.paidAmount,
    required this.remainingAmount,
    required this.installmentsCount,
    required this.paidCount,
    required this.paidProgress,
  });

  factory ContractInstallmentsSummaryEntity.fromInstallments(
    List<ContractInstallmentEntity> installments,
  ) {
    final total = installments.fold<double>(
      0,
      (sum, item) => sum + item.amount,
    );
    final paid = installments.fold<double>(
      0,
      (sum, item) => sum + item.paidAmount,
    );
    return ContractInstallmentsSummaryEntity(
      totalAmount: total,
      paidAmount: paid,
      remainingAmount: installments.fold<double>(
        0,
        (sum, item) => sum + item.remaining,
      ),
      installmentsCount: installments.length,
      paidCount: installments.where((item) => item.status == 'paid').length,
      paidProgress: total == 0 ? 0 : (paid / total).clamp(0, 1),
    );
  }

  @override
  List<Object?> get props => [
    totalAmount,
    paidAmount,
    remainingAmount,
    installmentsCount,
    paidCount,
    paidProgress,
  ];
}
