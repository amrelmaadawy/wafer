import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/search_owner_clients_use_case.dart';
import 'search_owner_clients_state.dart';

class SearchOwnerClientsCubit extends Cubit<SearchOwnerClientsState> {
  final SearchOwnerClientsUseCase searchUseCase;
  String _lastKeyword = '';

  SearchOwnerClientsCubit({
    required this.searchUseCase,
  }) : super(SearchOwnerClientsInitial());

  void search(String keyword) {
    if (keyword.trim().isEmpty) {
      emit(SearchOwnerClientsInitial());
      return;
    }

    if (keyword == _lastKeyword && state is SearchOwnerClientsLoaded) {
      return;
    }

    _executeSearch(keyword);
  }

  void retry() {
    if (state is SearchOwnerClientsError) {
      final keyword = (state as SearchOwnerClientsError).keyword;
      _executeSearch(keyword);
    }
  }

  Future<void> _executeSearch(String keyword) async {
    _lastKeyword = keyword;
    emit(SearchOwnerClientsLoading());

    final result = await searchUseCase(keyword);

    result.fold(
      (failure) => emit(SearchOwnerClientsError(
        message: failure.message,
        keyword: keyword,
      )),
      (clients) => emit(SearchOwnerClientsLoaded(clients: clients)),
    );
  }

}
