import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../../domain/entities/journal_entries_response_entity.dart';
import '../../domain/entities/journal_entry_entity.dart';
import '../../domain/entities/create_journal_entry_request_entity.dart';
import '../../domain/entities/update_journal_entry_request_entity.dart';
import '../../domain/repositories/journal_entries_repository.dart';
import '../datasources/journal_entries_remote_data_source.dart';
import '../../../../../core/data/base_repository.dart';

class JournalEntriesRepositoryImpl extends BaseRepository implements JournalEntriesRepository {
  final JournalEntriesRemoteDataSource remoteDataSource;

  JournalEntriesRepositoryImpl({
    required this.remoteDataSource,
    required super.networkInfo,
  });

  @override
  Future<Either<Failure, JournalEntriesResponseEntity>> getJournalEntries({
    required int page,
  }) async {
    return executeApiCall<JournalEntriesResponseEntity>(
      call: () => remoteDataSource.getJournalEntries(page: page),
    );
  }

  @override
  Future<Either<Failure, JournalEntryEntity>> createJournalEntry(CreateJournalEntryRequestEntity request) async {
    return executeApiCall<JournalEntryEntity>(
      call: () => remoteDataSource.createJournalEntry(request),
    );
  }

  @override
  Future<Either<Failure, JournalEntryEntity>> updateJournalEntry(UpdateJournalEntryRequestEntity request) async {
    return executeApiCall<JournalEntryEntity>(
      call: () => remoteDataSource.updateJournalEntry(request),
    );
  }

  @override
  Future<Either<Failure, JournalEntryEntity>> postJournalEntry(int id) async {
    return executeApiCall<JournalEntryEntity>(
      call: () => remoteDataSource.postJournalEntry(id),
    );
  }

  @override
  Future<Either<Failure, JournalEntryEntity>> reverseJournalEntry(int id, String reason) async {
    return executeApiCall<JournalEntryEntity>(
      call: () => remoteDataSource.reverseJournalEntry(id, reason),
    );
  }
}