import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/entities/transfer_entity.dart';
import '../../../domain/usecases/get_transfers_use_case.dart';

part 'transfers_state.dart';

class TransfersCubit extends Cubit<TransfersState> {
  final GetTransfersUseCase getTransfersUseCase;

  int _currentPage = 1;
  bool _isLastPage = false;
  final List<TransferEntity> _transfers = [];

  TransfersCubit(this.getTransfersUseCase) : super(TransfersInitial());

  Future<void> fetchTransfers({bool forceRefresh = false}) async {
    if (forceRefresh) {
      _currentPage = 1;
      _isLastPage = false;
      _transfers.clear();
      emit(TransfersLoading());
    } else {
      if (_isLastPage || state is TransfersLoadingMore) return;
      if (_transfers.isNotEmpty) {
        emit(TransfersLoadingMore(
            transfers: List.from(_transfers), hasReachedMax: _isLastPage));
      } else {
        emit(TransfersLoading());
      }
    }

    final result = await getTransfersUseCase(page: _currentPage);
    result.fold(
      (failure) {
        emit(TransfersError(message: failure.message, transfers: _transfers));
      },
      (newTransfers) {
        if (newTransfers.isEmpty) {
          _isLastPage = true;
          if (_transfers.isEmpty) {
            emit(TransfersEmpty());
          } else {
            emit(TransfersLoaded(
                transfers: List.from(_transfers), hasReachedMax: _isLastPage));
          }
        } else {
          _currentPage++;
          _transfers.addAll(newTransfers);
          emit(TransfersLoaded(
              transfers: List.from(_transfers), hasReachedMax: _isLastPage));
        }
      },
    );
  }
}
