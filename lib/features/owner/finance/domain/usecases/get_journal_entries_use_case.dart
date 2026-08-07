import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../entities/journal_entries_response_entity.dart';
import '../repositories/journal_entries_repository.dart';

class GetJournalEntriesUseCase {
  final JournalEntriesRepository repository;

  GetJournalEntriesUseCase(this.repository);

  Future<Either<Failure, JournalEntriesResponseEntity>> call({required int page}) async {
    return await repository.getJournalEntries(page: page);
  }
}
