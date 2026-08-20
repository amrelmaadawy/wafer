import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_owner_clients_use_case.dart';
import 'owner_clients_list_state.dart';

class OwnerClientsListCubit extends Cubit<OwnerClientsListState> {
  final GetOwnerClientsUseCase getOwnerClientsUseCase;
  int _currentPage = 1;
  Map<String, dynamic>? _currentFilters;

  OwnerClientsListCubit({required this.getOwnerClientsUseCase})
      : super(const OwnerClientsListState());

  Future<void> loadClients({
    bool forceRefresh = false,
    Map<String, dynamic>? filters,
  }) async {
    if (forceRefresh) {
      _currentPage = 1;
      _currentFilters = filters ?? _currentFilters;
      emit(
        state.copyWith(
          status: OwnerClientsListStatus.loading,
          hasReachedMax: false,
        ),
      );
    } else {
      if (state.hasReachedMax) return;
      emit(state.copyWith(status: OwnerClientsListStatus.loadingMore));
    }

    final params = GetOwnerClientsParams(
      page: _currentPage,
      filters: _currentFilters,
    );

    final result = await getOwnerClientsUseCase(params);

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: OwnerClientsListStatus.failure,
            errorMessage: failure.message,
          ),
        );
      },
      (response) {
        final newClients = forceRefresh
            ? response.clients
            : [...state.clients, ...response.clients];

        final hasReachedMax =
            response.pagination.currentPage >= response.pagination.lastPage;

        if (!hasReachedMax) {
          _currentPage++;
        }

        emit(
          state.copyWith(
            status: OwnerClientsListStatus.success,
            clients: newClients,
            pagination: response.pagination,
            hasReachedMax: hasReachedMax,
          ),
        );
      },
    );
  }

  void updateFilters(Map<String, dynamic> filters) {
    loadClients(forceRefresh: true, filters: filters);
  }
}
