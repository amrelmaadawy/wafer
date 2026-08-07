import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/journal_entry_entity.dart';
import '../../../domain/usecases/get_journal_entries_use_case.dart';
import 'journal_entries_state.dart';

class JournalEntriesCubit extends Cubit<JournalEntriesState> {
  final GetJournalEntriesUseCase getJournalEntriesUseCase;

  int _currentPage = 1;
  bool _hasReachedMax = false;
  List<JournalEntryEntity> _entries = [];

  JournalEntriesCubit(this.getJournalEntriesUseCase)
      : super(JournalEntriesInitial());

  Future<void> fetchJournalEntries({bool forceRefresh = false}) async {
    if (forceRefresh) {
      _currentPage = 1;
      _hasReachedMax = false;
      _entries = [];
      emit(JournalEntriesLoading());
    } else {
      if (_hasReachedMax || state is JournalEntriesLoading || state is JournalEntriesLoadingMore) {
        return;
      }
      emit(JournalEntriesLoadingMore(
        entries: _entries,
        hasReachedMax: _hasReachedMax,
      ));
    }

    final result = await getJournalEntriesUseCase(page: _currentPage);

    result.fold(
      (failure) {
        emit(JournalEntriesError(
          message: failure.message,
          entries: _entries,
        ));
      },
      (response) {
        _currentPage++;
        _entries.addAll(response.data);
        _hasReachedMax = response.currentPage >= response.lastPage;

        if (_entries.isEmpty) {
          emit(JournalEntriesEmpty());
        } else {
          emit(JournalEntriesLoaded(
            entries: List.from(_entries),
            hasReachedMax: _hasReachedMax,
          ));
        }
      },
    );
  }
}
