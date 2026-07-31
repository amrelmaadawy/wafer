import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';


import '../../../../../core/error/failures.dart';
import '../../domain/entities/technician_form_data_entity.dart';
import '../../domain/entities/technicians_list_response_entity.dart';
import '../../domain/entities/technician_entity.dart';
import '../../domain/repositories/technicians_repository.dart';
import '../../domain/usecases/add_technician_use_case.dart';
import '../datasources/technicians_remote_data_source.dart';

class TechniciansRepositoryImpl implements TechniciansRepository {
  final TechniciansRemoteDataSource remoteDataSource;

  TechniciansRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, TechnicianFormDataEntity>> getTechnicianFormData() async {
    try {
      final result = await remoteDataSource.getTechnicianFormData();
      return Right(result);
    } catch (e) {
      if (e is DioException) {
        return Left(ServerFailure.fromDioException(e));
      }
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, TechniciansListResponseEntity>> getTechniciansList({
    required int page,
    Map<String, dynamic>? filters,
  }) async {
    try {
      final result = await remoteDataSource.getTechniciansList(
        page: page,
        filters: filters,
      );
      return Right(result);
    } catch (e) {
      if (e is DioException) {
        return Left(ServerFailure.fromDioException(e));
      }
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, TechnicianEntity>> addTechnician(AddTechnicianParams params) async {
    try {
      final result = await remoteDataSource.addTechnician(params);
      return Right(result);
    } catch (e) {
      if (e is DioException) {
        return Left(ServerFailure.fromDioException(e));
      }
      return Left(ServerFailure(e.toString()));
    }
  }
}
