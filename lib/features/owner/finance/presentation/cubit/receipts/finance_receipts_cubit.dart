import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../core/error/failures.dart';
import '../../../domain/entities/finance_query_filter_entity.dart';
import '../../../domain/entities/receipt_entity.dart';
import '../../../domain/usecases/get_finance_receipts_use_case.dart';
import 'finance_receipts_state.dart';

class FinanceReceiptsCubit extends Cubit<FinanceReceiptsState> {
  final GetFinanceReceiptsUseCase getFinanceReceiptsUseCase;

  FinanceReceiptsCubit(this.getFinanceReceiptsUseCase)
      : super(FinanceReceiptsInitial());

  int _currentPage = 1;
  final int _perPage = 15;
  List<ReceiptEntity> _allFetchedReceipts = [];
  FinanceQueryFilterEntity _currentFilter = const FinanceQueryFilterEntity();

  FinanceQueryFilterEntity get currentFilter => _currentFilter;

  Future<void> fetchReceipts({
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
      _allFetchedReceipts = [];
      emit(FinanceReceiptsLoading());
    } else if (state is FinanceReceiptsSuccess) {
      emit(FinanceReceiptsPaginationLoading(_getFilteredReceipts()));
    } else {
      emit(FinanceReceiptsLoading());
    }

    final params = GetFinanceReceiptsParams(
      page: _currentPage,
      perPage: _perPage,
      search: _currentFilter.search,
    );

    final result = await getFinanceReceiptsUseCase(params);

    result.fold(
      (failure) {
        String message = 'Unexpected Error';
        if (failure is ServerFailure) {
          message = failure.message;
        } else if (failure is NetworkFailure) {
          message = failure.message;
        }
        emit(FinanceReceiptsError(message, oldReceipts: _getFilteredReceipts()));
      },
      (response) {
        if (isRefresh) {
          _allFetchedReceipts = response.receipts;
        } else {
          final newItems = response.receipts
              .where((n) => !_allFetchedReceipts.any((e) => e.id == n.id))
              .toList();
          _allFetchedReceipts.addAll(newItems);
        }

        _currentPage++;
        final hasReachedMax = _allFetchedReceipts.length >= response.pagination.total;

        _emitFiltered(hasReachedMax: hasReachedMax);
      },
    );
  }

  void applyFilter(FinanceQueryFilterEntity filter) {
    _currentFilter = filter;
    _emitFiltered();
  }

  void _emitFiltered({bool? hasReachedMax}) {
    final filtered = _getFilteredReceipts();
    final reachedMax = hasReachedMax ??
        (state is FinanceReceiptsSuccess
            ? (state as FinanceReceiptsSuccess).hasReachedMax
            : true);

    emit(FinanceReceiptsSuccess(
      receipts: filtered,
      hasReachedMax: reachedMax,
    ));
  }

  List<ReceiptEntity> _getFilteredReceipts() {
    List<ReceiptEntity> filtered = List.from(_allFetchedReceipts);

    if (_currentFilter.search != null &&
        _currentFilter.search!.trim().isNotEmpty) {
      final query = _currentFilter.search!.trim().toLowerCase();
      filtered = filtered.where((r) {
        return r.receiptNumber.toLowerCase().contains(query) ||
            r.owner.name.toLowerCase().contains(query) ||
            r.paymentMethod.label.toLowerCase().contains(query);
      }).toList();
    }

    if (_currentFilter.accountName != null &&
        _currentFilter.accountName!.isNotEmpty) {
      final accLower = _currentFilter.accountName!.toLowerCase();
      filtered = filtered.where((r) {
        return (r.debitAccount?.nameAr.toLowerCase().contains(accLower) ?? false) ||
            (r.debitAccount?.nameEn.toLowerCase().contains(accLower) ?? false) ||
            (r.creditAccount?.nameAr.toLowerCase().contains(accLower) ?? false) ||
            (r.creditAccount?.nameEn.toLowerCase().contains(accLower) ?? false) ||
            r.owner.name.toLowerCase().contains(accLower);
      }).toList();
    }

    if (_currentFilter.propertyName != null &&
        _currentFilter.propertyName!.isNotEmpty) {
      final propLower = _currentFilter.propertyName!.toLowerCase();
      filtered = filtered
          .where((r) => r.receiptNumber.toLowerCase().contains(propLower))
          .toList();
    }

    if (_currentFilter.fromDate != null &&
        _currentFilter.fromDate!.isNotEmpty) {
      filtered = filtered
          .where((r) => r.receiptDate.compareTo(_currentFilter.fromDate!) >= 0)
          .toList();
    }

    if (_currentFilter.toDate != null && _currentFilter.toDate!.isNotEmpty) {
      filtered = filtered
          .where((r) => r.receiptDate.compareTo(_currentFilter.toDate!) <= 0)
          .toList();
    }

    if (_currentFilter.sortBy != null) {
      filtered.sort((a, b) {
        int cmp = 0;
        switch (_currentFilter.sortBy!) {
          case FinanceSortField.date:
            cmp = a.receiptDate.compareTo(b.receiptDate);
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
