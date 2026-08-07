import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/update_journal_entry_request_entity.dart';
import '../../../domain/usecases/update_journal_entry_use_case.dart';
import 'update_journal_entry_state.dart';

class UpdateJournalEntryCubit extends Cubit<UpdateJournalEntryState> {
  final UpdateJournalEntryUseCase updateJournalEntryUseCase;

  UpdateJournalEntryCubit({required this.updateJournalEntryUseCase}) : super(UpdateJournalEntryInitial());

  Future<void> updateJournalEntry(UpdateJournalEntryRequestEntity request) async {
    emit(UpdateJournalEntryLoading());

    final result = await updateJournalEntryUseCase(request);

    result.fold(
      (failure) => emit(UpdateJournalEntryError(failure.message)),
      (journalEntry) => emit(UpdateJournalEntrySuccess(journalEntry)),
    );
  }
}
