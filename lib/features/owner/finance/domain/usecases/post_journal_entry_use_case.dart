import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../entities/journal_entry_entity.dart';
import '../repositories/journal_entries_repository.dart';

class PostJournalEntryUseCase implements UseCase<JournalEntryEntity, int> {
  final JournalEntriesRepository repository;

  PostJournalEntryUseCase(this.repository);

  @override
  Future<Either<Failure, JournalEntryEntity>> call(int id) async {
    return await repository.postJournalEntry(id);
  }
}
