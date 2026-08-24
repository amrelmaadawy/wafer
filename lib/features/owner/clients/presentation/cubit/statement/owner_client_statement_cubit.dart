import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_owner_client_statement_use_case.dart';
import 'owner_client_statement_state.dart';

class OwnerClientStatementCubit extends Cubit<OwnerClientStatementState> {
  final GetOwnerClientStatementUseCase _getOwnerClientStatementUseCase;

  OwnerClientStatementCubit(this._getOwnerClientStatementUseCase)
      : super(OwnerClientStatementInitial());

  String? _currentStartDate;
  String? _currentEndDate;
  String? _currentTransactionType;

  Future<void> getStatement({
    required int clientId,
    String? startDate,
    String? endDate,
    String? transactionType,
    bool isRefresh = false,
  }) async {
    // Save current filters
    if (!isRefresh) {
      _currentStartDate = startDate;
      _currentEndDate = endDate;
      _currentTransactionType = transactionType;
    }

    emit(OwnerClientStatementLoading());

    final result = await _getOwnerClientStatementUseCase(
      GetOwnerClientStatementParams(
        clientId: clientId,
        startDate: _currentStartDate,
        endDate: _currentEndDate,
        transactionType: _currentTransactionType,
      ),
    );

    result.fold(
      (failure) => emit(OwnerClientStatementError(failure)),
      (response) => emit(OwnerClientStatementLoaded(
        statementResponse: response,
        startDate: _currentStartDate,
        endDate: _currentEndDate,
        transactionType: _currentTransactionType,
      )),
    );
  }

  void resetFilters(int clientId) {
    _currentStartDate = null;
    _currentEndDate = null;
    _currentTransactionType = null;
    getStatement(clientId: clientId);
  }
}
