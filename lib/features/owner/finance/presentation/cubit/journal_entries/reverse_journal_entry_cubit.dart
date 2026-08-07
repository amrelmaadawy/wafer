import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/reverse_journal_entry_use_case.dart';
import 'reverse_journal_entry_state.dart';

class ReverseJournalEntryCubit extends Cubit<ReverseJournalEntryState> {
  final ReverseJournalEntryUseCase reverseJournalEntryUseCase;

  ReverseJournalEntryCubit({required this.reverseJournalEntryUseCase})
      : super(ReverseJournalEntryInitial());

  Future<void> reverseJournalEntry(int id, String reason) async {
    emit(ReverseJournalEntryLoading(id));
    final result = await reverseJournalEntryUseCase(
        ReverseJournalEntryParams(id: id, reason: reason));
    result.fold(
      (failure) => emit(ReverseJournalEntryError(failure.message, id)),
      (journalEntry) => emit(ReverseJournalEntrySuccess(journalEntry)),
    );
  }
}
