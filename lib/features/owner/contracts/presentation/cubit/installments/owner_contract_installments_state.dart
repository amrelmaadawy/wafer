import 'package:equatable/equatable.dart';
import '../../../domain/entities/contract_installment_entity.dart';
import '../../../domain/entities/installment_status_filter.dart';
import '../../../domain/entities/contract_installments_summary_entity.dart';

abstract class OwnerContractInstallmentsState extends Equatable {
  const OwnerContractInstallmentsState();

  @override
  List<Object?> get props => [];
}

class OwnerContractInstallmentsInitial extends OwnerContractInstallmentsState {
  const OwnerContractInstallmentsInitial();
}

class OwnerContractInstallmentsLoading extends OwnerContractInstallmentsState {
  const OwnerContractInstallmentsLoading();
}

class OwnerContractInstallmentsLoaded extends OwnerContractInstallmentsState {
  final List<ContractInstallmentEntity> allInstallments;
  final List<ContractInstallmentEntity> filteredInstallments;
  final InstallmentStatusFilter activeFilter;
  final ContractInstallmentsSummaryEntity summary;

  const OwnerContractInstallmentsLoaded({
    required this.allInstallments,
    required this.filteredInstallments,
    required this.summary,
    this.activeFilter = InstallmentStatusFilter.all,
  });

  @override
  List<Object?> get props => [
    allInstallments,
    filteredInstallments,
    activeFilter,
    summary,
  ];
}

class OwnerContractInstallmentsError extends OwnerContractInstallmentsState {
  final String message;

  const OwnerContractInstallmentsError(this.message);

  @override
  List<Object?> get props => [message];
}
