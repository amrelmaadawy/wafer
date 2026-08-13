import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/contract_installment_entity.dart';
import '../../../domain/entities/installment_status_filter.dart';
import '../../../domain/entities/contract_installments_summary_entity.dart';
import '../../../domain/usecases/get_owner_contract_installments_use_case.dart';
import 'owner_contract_installments_state.dart';

class OwnerContractInstallmentsCubit
    extends Cubit<OwnerContractInstallmentsState> {
  final GetOwnerContractInstallmentsUseCase _getInstallmentsUseCase;

  OwnerContractInstallmentsCubit(this._getInstallmentsUseCase)
    : super(const OwnerContractInstallmentsInitial());

  Future<void> getContractInstallments(String contractId) async {
    emit(const OwnerContractInstallmentsLoading());
    final result = await _getInstallmentsUseCase(contractId);
    result.fold(
      (failure) => emit(OwnerContractInstallmentsError(failure.message)),
      (installments) => emit(
        OwnerContractInstallmentsLoaded(
          allInstallments: installments,
          filteredInstallments: installments,
          summary: ContractInstallmentsSummaryEntity.fromInstallments(
            installments,
          ),
          activeFilter: InstallmentStatusFilter.all,
        ),
      ),
    );
  }

  void filterInstallments(InstallmentStatusFilter filter) {
    if (state is! OwnerContractInstallmentsLoaded) return;
    final currentState = state as OwnerContractInstallmentsLoaded;

    List<ContractInstallmentEntity> filtered;
    if (filter == InstallmentStatusFilter.paid) {
      filtered = currentState.allInstallments
          .where((e) => e.status == 'paid' || e.paidAmount >= e.amount)
          .toList();
    } else if (filter == InstallmentStatusFilter.unpaid) {
      filtered = currentState.allInstallments
          .where((e) => e.status != 'paid' && e.paidAmount < e.amount)
          .toList();
    } else {
      filtered = currentState.allInstallments;
    }

    emit(
      OwnerContractInstallmentsLoaded(
        allInstallments: currentState.allInstallments,
        filteredInstallments: filtered,
        summary: currentState.summary,
        activeFilter: filter,
      ),
    );
  }
}
