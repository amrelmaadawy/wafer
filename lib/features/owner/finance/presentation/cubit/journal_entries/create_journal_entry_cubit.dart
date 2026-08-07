import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/create_journal_entry_request_entity.dart';
import '../../../domain/usecases/create_journal_entry_use_case.dart';
import 'create_journal_entry_state.dart';

class CreateJournalEntryCubit extends Cubit<CreateJournalEntryState> {
  final CreateJournalEntryUseCase createJournalEntryUseCase;

  CreateJournalEntryCubit({required this.createJournalEntryUseCase}) : super(CreateJournalEntryInitial());

  Future<void> createJournalEntry(CreateJournalEntryRequestEntity request) async {
    emit(CreateJournalEntryLoading());

    final result = await createJournalEntryUseCase(request);

    result.fold(
      (failure) => emit(CreateJournalEntryError(failure.message)),
      (journalEntry) => emit(CreateJournalEntrySuccess(journalEntry)),
    );
  }
}
