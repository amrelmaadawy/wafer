import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/global_search_use_case.dart';
import 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  final GlobalSearchUseCase searchUseCase;
  Timer? _debounce;
  String _lastQuery = '';

  SearchCubit({required this.searchUseCase}) : super(const SearchInitial());

  void onQueryChanged(String query) {
    _debounce?.cancel();
    final trimmedQuery = query.trim();

    if (trimmedQuery.length < 2) {
      if (state is! SearchInitial) {
        emit(const SearchInitial());
      }
      _lastQuery = '';
      return;
    }

    if (trimmedQuery == _lastQuery && state is! SearchError) {
      return; // Already searched or searching for this query
    }

    _lastQuery = trimmedQuery;

    _debounce = Timer(const Duration(milliseconds: 450), () {
      _performSearch(trimmedQuery);
    });
  }

  Future<void> _performSearch(String query) async {
    emit(const SearchLoading());

    final result = await searchUseCase(query);

    if (isClosed) return;

    result.fold(
      (failure) => emit(SearchError(message: failure.message)),
      (data) {
        if (data.isEmpty) {
          emit(SearchEmpty(query: query));
        } else {
          emit(SearchLoaded(results: data, query: query));
        }
      },
    );
  }

  void clearSearch() {
    _debounce?.cancel();
    _lastQuery = '';
    emit(const SearchInitial());
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }
}
