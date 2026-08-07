import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../entities/update_journal_entry_request_entity.dart';
import '../entities/journal_entry_entity.dart';
import '../repositories/journal_entries_repository.dart';

class UpdateJournalEntryUseCase {
  final JournalEntriesRepository repository;

  UpdateJournalEntryUseCase(this.repository);

  Future<Either<Failure, JournalEntryEntity>> call(UpdateJournalEntryRequestEntity request) {
    return repository.updateJournalEntry(request);
  }
}
