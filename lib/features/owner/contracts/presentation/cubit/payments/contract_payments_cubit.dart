import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wafer/features/owner/finance/domain/entities/payment_entity.dart';
import 'package:wafer/features/owner/finance/domain/usecases/get_finance_payments_use_case.dart';
import 'contract_payments_state.dart';

class ContractPaymentsCubit extends Cubit<ContractPaymentsState> {
  final GetFinancePaymentsUseCase getFinancePaymentsUseCase;

  ContractPaymentsCubit(this.getFinancePaymentsUseCase)
      : super(ContractPaymentsInitial());

  int _currentPage = 1;
  static const int _perPage = 15;
  List<PaymentEntity> _payments = [];
  int? _contractId;

  Future<void> fetchContractPayments({
    required int contractId,
    bool isRefresh = false,
  }) async {
    _contractId = contractId;
    if (isRefresh) {
      _currentPage = 1;
      emit(const ContractPaymentsLoading(isFirstFetch: true));
    } else {
      if (state is ContractPaymentsLoaded) {
        if ((state as ContractPaymentsLoaded).hasReachedMax) return;
        emit(const ContractPaymentsLoading(isFirstFetch: false));
      } else {
        emit(const ContractPaymentsLoading(isFirstFetch: true));
      }
    }

    final result = await getFinancePaymentsUseCase(
      GetFinancePaymentsParams(
        page: _currentPage,
        perPage: _perPage,
        contractId: _contractId,
      ),
    );

    result.fold(
      (failure) => emit(
        ContractPaymentsError(failure.message, oldPayments: _payments),
      ),
      (response) {
        if (response.payments.isEmpty && _currentPage == 1) {
          emit(ContractPaymentsEmpty());
        } else {
          final hasReachedMax =
              response.pagination.currentPage >= response.pagination.lastPage;

          if (isRefresh || _currentPage == 1) {
            _payments = response.payments;
            emit(ContractPaymentsLoaded(
              payments: _payments,
              hasReachedMax: hasReachedMax,
              currentPage: _currentPage,
            ));
          } else {
            final currentState = state;
            if (currentState is ContractPaymentsLoaded) {
              _payments = currentState.payments + response.payments;
              emit(ContractPaymentsLoaded(
                payments: _payments,
                hasReachedMax: hasReachedMax,
                currentPage: _currentPage,
              ));
            }
          }

          if (!hasReachedMax) {
            _currentPage++;
          }
        }
      },
    );
  }

  Future<void> retry() async {
    if (_contractId != null) {
      await fetchContractPayments(contractId: _contractId!, isRefresh: true);
    }
  }
}
