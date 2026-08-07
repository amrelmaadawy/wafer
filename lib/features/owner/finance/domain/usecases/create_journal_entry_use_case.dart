import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../entities/create_journal_entry_request_entity.dart';
import '../entities/journal_entry_entity.dart';
import '../repositories/journal_entries_repository.dart';

class CreateJournalEntryUseCase {
  final JournalEntriesRepository repository;

  CreateJournalEntryUseCase(this.repository);

  Future<Either<Failure, JournalEntryEntity>> call(CreateJournalEntryRequestEntity request) {
    return repository.createJournalEntry(request);
  }
}
