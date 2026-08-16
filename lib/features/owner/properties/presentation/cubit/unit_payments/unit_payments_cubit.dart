import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wafer/features/owner/finance/domain/entities/payment_entity.dart';
import 'package:wafer/features/owner/finance/domain/usecases/get_finance_payments_use_case.dart';
import 'unit_payments_state.dart';

class UnitPaymentsCubit extends Cubit<UnitPaymentsState> {
  final GetFinancePaymentsUseCase getFinancePaymentsUseCase;

  UnitPaymentsCubit(this.getFinancePaymentsUseCase)
      : super(UnitPaymentsInitial());

  int _currentPage = 1;
  static const int _perPage = 15;
  List<PaymentEntity> _payments = [];
  int? _unitId;

  Future<void> fetchUnitPayments({
    required int unitId,
    bool isRefresh = false,
  }) async {
    _unitId = unitId;
    if (isRefresh) {
      _currentPage = 1;
      emit(const UnitPaymentsLoading(isFirstFetch: true));
    } else {
      if (state is UnitPaymentsLoaded) {
        if ((state as UnitPaymentsLoaded).hasReachedMax) return;
        emit(const UnitPaymentsLoading(isFirstFetch: false));
      } else {
        emit(const UnitPaymentsLoading(isFirstFetch: true));
      }
    }

    final result = await getFinancePaymentsUseCase(
      GetFinancePaymentsParams(
        page: _currentPage,
        perPage: _perPage,
        unitId: _unitId,
      ),
    );

    result.fold(
      (failure) => emit(
        UnitPaymentsError(failure.message, oldPayments: _payments),
      ),
      (response) {
        if (response.payments.isEmpty && _currentPage == 1) {
          emit(UnitPaymentsEmpty());
        } else {
          final hasReachedMax =
              response.pagination.currentPage >= response.pagination.lastPage;

          if (isRefresh || _currentPage == 1) {
            _payments = response.payments;
            emit(UnitPaymentsLoaded(
              payments: _payments,
              hasReachedMax: hasReachedMax,
              currentPage: _currentPage,
            ));
          } else {
            final currentState = state;
            if (currentState is UnitPaymentsLoaded) {
              _payments = currentState.payments + response.payments;
              emit(UnitPaymentsLoaded(
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
    if (_unitId != null) {
      await fetchUnitPayments(unitId: _unitId!, isRefresh: true);
    }
  }
}
