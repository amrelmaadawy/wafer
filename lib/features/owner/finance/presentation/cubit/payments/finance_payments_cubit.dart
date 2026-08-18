import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/finance_query_filter_entity.dart';
import '../../../domain/entities/payment_entity.dart';
import '../../../domain/usecases/get_finance_payments_use_case.dart';
import 'finance_payments_state.dart';

class FinancePaymentsCubit extends Cubit<FinancePaymentsState> {
  final GetFinancePaymentsUseCase getFinancePaymentsUseCase;

  FinancePaymentsCubit(this.getFinancePaymentsUseCase)
      : super(FinancePaymentsInitial());

  int _currentPage = 1;
  static const int _perPage = 15;
  List<PaymentEntity> _allFetchedPayments = [];
  FinanceQueryFilterEntity _currentFilter = const FinanceQueryFilterEntity();

  FinanceQueryFilterEntity get currentFilter => _currentFilter;

  Future<void> fetchPayments({
    bool isRefresh = false,
    String? search,
  }) async {
    if (search != null) {
      _currentFilter = _currentFilter.copyWith(
        search: () => search.isNotEmpty ? search : null,
      );
    }

    if (isRefresh) {
      _currentPage = 1;
      _allFetchedPayments = [];
      emit(const FinancePaymentsLoading(isFirstFetch: true));
    } else {
      if (state is FinancePaymentsLoaded) {
        if ((state as FinancePaymentsLoaded).hasReachedMax) return;
        emit(const FinancePaymentsLoading(isFirstFetch: false));
      } else {
        emit(const FinancePaymentsLoading(isFirstFetch: true));
      }
    }

    final result = await getFinancePaymentsUseCase(
      GetFinancePaymentsParams(page: _currentPage, perPage: _perPage),
    );

    result.fold(
      (failure) => emit(
        FinancePaymentsError(failure.message, oldPayments: _getFilteredPayments()),
      ),
      (response) {
        if (response.payments.isEmpty && _currentPage == 1) {
          emit(FinancePaymentsEmpty());
        } else {
          final hasReachedMax =
              response.pagination.currentPage >= response.pagination.lastPage;

          if (isRefresh || _currentPage == 1) {
            _allFetchedPayments = response.payments;
          } else {
            final newItems = response.payments
                .where((n) => !_allFetchedPayments.any((e) => e.id == n.id))
                .toList();
            _allFetchedPayments.addAll(newItems);
          }

          if (!hasReachedMax) {
            _currentPage++;
          }

          _emitFiltered(hasReachedMax: hasReachedMax);
        }
      },
    );
  }

  void applyFilter(FinanceQueryFilterEntity filter) {
    _currentFilter = filter;
    _emitFiltered();
  }

  void _emitFiltered({bool? hasReachedMax}) {
    final filtered = _getFilteredPayments();
    final reachedMax = hasReachedMax ??
        (state is FinancePaymentsLoaded
            ? (state as FinancePaymentsLoaded).hasReachedMax
            : true);

    if (filtered.isEmpty) {
      emit(FinancePaymentsEmpty());
    } else {
      emit(FinancePaymentsLoaded(
        payments: filtered,
        hasReachedMax: reachedMax,
        currentPage: _currentPage,
      ));
    }
  }

  List<PaymentEntity> _getFilteredPayments() {
    List<PaymentEntity> filtered = List.from(_allFetchedPayments);

    if (_currentFilter.search != null &&
        _currentFilter.search!.trim().isNotEmpty) {
      final query = _currentFilter.search!.trim().toLowerCase();
      filtered = filtered.where((p) {
        return p.paymentNumber.toLowerCase().contains(query) ||
            p.payee.name.toLowerCase().contains(query) ||
            p.paymentMethod.label.toLowerCase().contains(query) ||
            (p.propertyName?.toLowerCase().contains(query) ?? false);
      }).toList();
    }

    if (_currentFilter.accountName != null &&
        _currentFilter.accountName!.isNotEmpty) {
      final accLower = _currentFilter.accountName!.toLowerCase();
      filtered = filtered.where((p) {
        return (p.debitAccount?.nameAr.toLowerCase().contains(accLower) ?? false) ||
            (p.debitAccount?.nameEn.toLowerCase().contains(accLower) ?? false) ||
            (p.creditAccount?.nameAr.toLowerCase().contains(accLower) ?? false) ||
            (p.creditAccount?.nameEn.toLowerCase().contains(accLower) ?? false) ||
            p.payee.name.toLowerCase().contains(accLower);
      }).toList();
    }

    if (_currentFilter.propertyName != null &&
        _currentFilter.propertyName!.isNotEmpty) {
      final propLower = _currentFilter.propertyName!.toLowerCase();
      filtered = filtered
          .where((p) => p.propertyName?.toLowerCase().contains(propLower) ?? false)
          .toList();
    }

    if (_currentFilter.fromDate != null &&
        _currentFilter.fromDate!.isNotEmpty) {
      filtered = filtered
          .where((p) => p.paymentDate.compareTo(_currentFilter.fromDate!) >= 0)
          .toList();
    }

    if (_currentFilter.toDate != null && _currentFilter.toDate!.isNotEmpty) {
      filtered = filtered
          .where((p) => p.paymentDate.compareTo(_currentFilter.toDate!) <= 0)
          .toList();
    }

    if (_currentFilter.sortBy != null) {
      filtered.sort((a, b) {
        int cmp = 0;
        switch (_currentFilter.sortBy!) {
          case FinanceSortField.date:
            cmp = a.paymentDate.compareTo(b.paymentDate);
            break;
          case FinanceSortField.amount:
            cmp = a.amount.compareTo(b.amount);
            break;
        }
        return _currentFilter.sortAscending ? cmp : -cmp;
      });
    }

    return filtered;
  }
}
