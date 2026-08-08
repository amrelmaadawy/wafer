import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/payment_entity.dart';
import '../../../domain/usecases/get_finance_payments_use_case.dart';
import 'finance_payments_state.dart';

class FinancePaymentsCubit extends Cubit<FinancePaymentsState> {
  final GetFinancePaymentsUseCase getFinancePaymentsUseCase;

  FinancePaymentsCubit(this.getFinancePaymentsUseCase)
      : super(FinancePaymentsInitial());

  int _currentPage = 1;
  static const int _perPage = 15;
  List<PaymentEntity> _payments = [];

  Future<void> fetchPayments({bool isRefresh = false}) async {
    if (isRefresh) {
      _currentPage = 1;
      emit(const FinancePaymentsLoading(isFirstFetch: true));
    } else {
      if (state is FinancePaymentsLoaded) {
        if ((state as FinancePaymentsLoaded).hasReachedMax) return;
        emit(FinancePaymentsLoading(isFirstFetch: false));
      } else {
        emit(const FinancePaymentsLoading(isFirstFetch: true));
      }
    }

    final result = await getFinancePaymentsUseCase(
      GetFinancePaymentsParams(page: _currentPage, perPage: _perPage),
    );

    result.fold(
      (failure) => emit(FinancePaymentsError(failure.message, oldPayments: _payments)),
      (response) {
        if (response.payments.isEmpty && _currentPage == 1) {
          emit(FinancePaymentsEmpty());
        } else {
          final hasReachedMax = response.pagination.currentPage >= response.pagination.lastPage;

          if (isRefresh || _currentPage == 1) {
            _payments = response.payments;
            emit(FinancePaymentsLoaded(
              payments: _payments,
              hasReachedMax: hasReachedMax,
              currentPage: _currentPage,
            ));
          } else {
            final currentState = state;
            if (currentState is FinancePaymentsLoaded) {
              _payments = currentState.payments + response.payments;
              emit(FinancePaymentsLoaded(
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
}
