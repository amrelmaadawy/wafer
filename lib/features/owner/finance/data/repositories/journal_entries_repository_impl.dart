import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../core/error/exceptions.dart';
import '../../../../../core/error/failures.dart';
import '../../../../../core/localization/locale_keys.dart';
import '../../../../../core/network/connectivity/network_info.dart';
import '../../domain/entities/journal_entries_response_entity.dart';
import '../../domain/entities/journal_entry_entity.dart';
import '../../domain/entities/create_journal_entry_request_entity.dart';
import '../../domain/entities/update_journal_entry_request_entity.dart';
import '../../domain/repositories/journal_entries_repository.dart';
import '../datasources/journal_entries_remote_data_source.dart';

class JournalEntriesRepositoryImpl implements JournalEntriesRepository {
  final JournalEntriesRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  JournalEntriesRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, JournalEntriesResponseEntity>> getJournalEntries({
    required int page,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.getJournalEntries(page: page);
        return Right(result);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on DioException catch (e) {
        return Left(ServerFailure.fromDioException(e));
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure(LocaleKeys.errors_no_internet_title.tr()));
    }
  }

  @override
  Future<Either<Failure, JournalEntryEntity>> createJournalEntry(CreateJournalEntryRequestEntity request) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.createJournalEntry(request);
        return Right(result);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on DioException catch (e) {
        return Left(ServerFailure.fromDioException(e));
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure(LocaleKeys.errors_no_internet_title.tr()));
    }
  }

  @override
  Future<Either<Failure, JournalEntryEntity>> updateJournalEntry(UpdateJournalEntryRequestEntity request) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.updateJournalEntry(request);
        return Right(result);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on DioException catch (e) {
        return Left(ServerFailure.fromDioException(e));
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure(LocaleKeys.errors_no_internet_title.tr()));
    }
  }
}
