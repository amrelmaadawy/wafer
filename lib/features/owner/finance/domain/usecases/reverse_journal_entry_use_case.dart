import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../entities/journal_entry_entity.dart';
import '../repositories/journal_entries_repository.dart';

class ReverseJournalEntryUseCase implements UseCase<JournalEntryEntity, ReverseJournalEntryParams> {
  final JournalEntriesRepository repository;

  ReverseJournalEntryUseCase(this.repository);

  @override
  Future<Either<Failure, JournalEntryEntity>> call(ReverseJournalEntryParams params) async {
    return await repository.reverseJournalEntry(params.id, params.reason);
  }
}

class ReverseJournalEntryParams {
  final int id;
  final String reason;

  ReverseJournalEntryParams({required this.id, required this.reason});
}
