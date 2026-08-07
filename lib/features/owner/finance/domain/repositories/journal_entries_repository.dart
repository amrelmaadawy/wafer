import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../entities/journal_entries_response_entity.dart';
import '../entities/journal_entry_entity.dart';
import '../entities/create_journal_entry_request_entity.dart';
import '../entities/update_journal_entry_request_entity.dart';

abstract class JournalEntriesRepository {
  Future<Either<Failure, JournalEntriesResponseEntity>> getJournalEntries({
    required int page,
  });

  Future<Either<Failure, JournalEntryEntity>> createJournalEntry(
      CreateJournalEntryRequestEntity request);

  Future<Either<Failure, JournalEntryEntity>> updateJournalEntry(
      UpdateJournalEntryRequestEntity request);
}
