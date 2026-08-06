import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_negotiations_list_use_case.dart';
import 'negotiations_list_state.dart';

class NegotiationsListCubit extends Cubit<NegotiationsListState> {
  final GetNegotiationsListUseCase getNegotiationsListUseCase;
  int _currentPage = 1;
  final int _perPage = 15;
  bool _isFetching = false;

  NegotiationsListCubit(this.getNegotiationsListUseCase)
    : super(const NegotiationsListState());

  Future<void> fetchNegotiations({bool isRefresh = false}) async {
    if (_isFetching) return;
    if (state.hasReachedMax && !isRefresh) return;

    if (isRefresh) {
      _currentPage = 1;
      emit(
        state.copyWith(
          status: NegotiationsListStatus.loading,
          hasReachedMax: false,
        ),
      );
    } else if (state.status == NegotiationsListStatus.initial) {
      emit(state.copyWith(status: NegotiationsListStatus.loading));
    }

    _isFetching = true;

    final result = await getNegotiationsListUseCase(
      NegotiationsListParams(page: _currentPage, perPage: _perPage),
    );

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: NegotiationsListStatus.failure,
            errorMessage: failure.message,
          ),
        );
      },
      (response) {
        final newNegotiations = isRefresh
            ? response.negotiations
            : [...state.negotiations, ...response.negotiations];

        final hasReachedMax =
            response.pagination.currentPage >= response.pagination.lastPage;

        if (!hasReachedMax) {
          _currentPage++;
        }

        emit(
          state.copyWith(
            status: NegotiationsListStatus.success,
            negotiations: newNegotiations,
            hasReachedMax: hasReachedMax,
          ),
        );
      },
    );

    _isFetching = false;
  }
}
