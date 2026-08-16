import 'package:dartz/dartz.dart';
import 'package:wafer/core/error/exceptions.dart';
import 'package:wafer/core/error/failures.dart';
import '../../domain/entities/search_results_grouped_entity.dart';
import '../../domain/repositories/search_repository.dart';
import '../datasources/search_remote_data_source.dart';

class SearchRepositoryImpl implements SearchRepository {
  final SearchRemoteDataSource _remoteDataSource;

  SearchRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, SearchResultsGroupedEntity>> search(
      String query) async {
    try {
      final result = await _remoteDataSource.search(query);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
