import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../core/error/failures.dart';
import '../../../domain/entities/receipt_entity.dart';
import '../../../domain/usecases/get_finance_receipts_use_case.dart';
import 'finance_receipts_state.dart';

class FinanceReceiptsCubit extends Cubit<FinanceReceiptsState> {
  final GetFinanceReceiptsUseCase getFinanceReceiptsUseCase;

  FinanceReceiptsCubit(this.getFinanceReceiptsUseCase)
      : super(FinanceReceiptsInitial());

  int _currentPage = 1;
  final int _perPage = 15;
  String _currentSearchQuery = '';
  List<ReceiptEntity> _receipts = [];

  Future<void> fetchReceipts({
    bool isRefresh = false,
    String? search,
  }) async {
    if (search != null) {
      _currentSearchQuery = search;
    }

    if (isRefresh) {
      _currentPage = 1;
      _receipts = [];
      emit(FinanceReceiptsLoading());
    } else if (state is FinanceReceiptsSuccess) {
      emit(FinanceReceiptsPaginationLoading(_receipts));
    } else {
      emit(FinanceReceiptsLoading());
    }

    final params = GetFinanceReceiptsParams(
      page: _currentPage,
      perPage: _perPage,
      search: _currentSearchQuery.isNotEmpty ? _currentSearchQuery : null,
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
        emit(FinanceReceiptsError(message));
      },
      (response) {
        if (isRefresh) {
          _receipts = response.receipts;
        } else {
          _receipts.addAll(response.receipts);
        }

        _currentPage++;
        final hasReachedMax = _receipts.length >= response.pagination.total;

        emit(FinanceReceiptsSuccess(
          receipts: _receipts,
          hasReachedMax: hasReachedMax,
        ));
      },
    );
  }
}
