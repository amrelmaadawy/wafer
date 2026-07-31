import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../../core/error/exceptions.dart';
import '../../../../../core/error/failures.dart';
import '../../domain/entities/negotiation_form_data_entity.dart';
import '../../domain/entities/negotiations_list_response_entity.dart';
import '../../domain/repositories/maintenance_negotiation_repository.dart';
import '../datasources/maintenance_negotiation_remote_data_source.dart';

class MaintenanceNegotiationRepositoryImpl implements MaintenanceNegotiationRepository {
  final MaintenanceNegotiationRemoteDataSource remoteDataSource;

  MaintenanceNegotiationRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, NegotiationFormDataEntity>> getFormData() async {
    try {
      final remoteData = await remoteDataSource.getFormData();
      return Right(remoteData);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on DioException catch (e) {
      return Left(ServerFailure(e.response?.data?['message'] ?? e.message ?? 'Unknown error occurred'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, NegotiationsListResponseEntity>> getNegotiationsList({
    int page = 1,
    int perPage = 15,
  }) async {
    try {
      final remoteData = await remoteDataSource.getNegotiationsList(
        page: page,
        perPage: perPage,
      );
      return Right(remoteData);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on DioException catch (e) {
      return Left(ServerFailure(e.response?.data?['message'] ?? e.message ?? 'Unknown error occurred'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, NegotiationEntity>> createNegotiation({
    required num approvalLimit,
    required bool isActive,
  }) async {
    try {
      final remoteData = await remoteDataSource.createNegotiation(
        approvalLimit: approvalLimit,
        isActive: isActive,
      );
      return Right(remoteData);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on DioException catch (e) {
      return Left(ServerFailure(e.response?.data?['message'] ?? e.message ?? 'Unknown error occurred'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
