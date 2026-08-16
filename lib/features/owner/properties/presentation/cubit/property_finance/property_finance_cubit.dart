import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wafer/features/owner/finance/domain/entities/payment_entity.dart';
import 'package:wafer/features/owner/finance/domain/usecases/get_finance_payments_use_case.dart';
import 'property_finance_state.dart';

class PropertyFinanceCubit extends Cubit<PropertyFinanceState> {
  final GetFinancePaymentsUseCase getFinancePaymentsUseCase;

  PropertyFinanceCubit(this.getFinancePaymentsUseCase)
      : super(PropertyFinanceInitial());

  int _currentPage = 1;
  static const int _perPage = 15;
  List<PaymentEntity> _payments = [];
  int? _propertyId;

  Future<void> fetchPropertyPayments({
    required int propertyId,
    bool isRefresh = false,
  }) async {
    _propertyId = propertyId;
    if (isRefresh) {
      _currentPage = 1;
      emit(const PropertyFinanceLoading(isFirstFetch: true));
    } else {
      if (state is PropertyFinanceLoaded) {
        if ((state as PropertyFinanceLoaded).hasReachedMax) return;
        emit(const PropertyFinanceLoading(isFirstFetch: false));
      } else {
        emit(const PropertyFinanceLoading(isFirstFetch: true));
      }
    }

    final result = await getFinancePaymentsUseCase(
      GetFinancePaymentsParams(
        page: _currentPage,
        perPage: _perPage,
        propertyId: _propertyId,
      ),
    );

    result.fold(
      (failure) => emit(
        PropertyFinanceError(failure.message, oldPayments: _payments),
      ),
      (response) {
        if (response.payments.isEmpty && _currentPage == 1) {
          emit(PropertyFinanceEmpty());
        } else {
          final hasReachedMax =
              response.pagination.currentPage >= response.pagination.lastPage;

          if (isRefresh || _currentPage == 1) {
            _payments = response.payments;
            emit(PropertyFinanceLoaded(
              payments: _payments,
              hasReachedMax: hasReachedMax,
              currentPage: _currentPage,
            ));
          } else {
            final currentState = state;
            if (currentState is PropertyFinanceLoaded) {
              _payments = currentState.payments + response.payments;
              emit(PropertyFinanceLoaded(
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
    if (_propertyId != null) {
      await fetchPropertyPayments(propertyId: _propertyId!, isRefresh: true);
    }
  }
}
