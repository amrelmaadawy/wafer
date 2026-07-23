import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../../core/error/failures.dart';
import '../../domain/entities/deeds_query_filter_entity.dart';
import '../../domain/entities/deeds_response_entity.dart';
import '../../domain/repositories/deed_repository.dart';
import '../datasources/deeds_remote_data_source.dart';

class DeedRepositoryImpl implements DeedRepository {
  final DeedsRemoteDataSource remoteDataSource;

  DeedRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, DeedsResponseEntity>> getDeeds({
    required DeedsQueryFilterEntity filter,
  }) async {
    try {
      final result = await remoteDataSource.getDeeds(filter: filter);
      return Right(result);
    } on DioException catch (e) {
      return Left(ServerFailure(e.response?.data['message'] ?? e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
