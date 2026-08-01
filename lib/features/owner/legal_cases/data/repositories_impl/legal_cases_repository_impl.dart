import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../../core/error/exceptions.dart';
import '../../../../../core/error/failures.dart';
import '../../domain/entities/legal_case_form_data_entity.dart';
import '../../domain/entities/legal_cases_list_response_entity.dart';
import '../../domain/entities/legal_case_item_entity.dart';
import '../../domain/repositories/legal_cases_repository.dart';
import '../data_sources/legal_cases_remote_data_source.dart';

class LegalCasesRepositoryImpl implements LegalCasesRepository {
  final LegalCasesRemoteDataSource remoteDataSource;

  LegalCasesRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, LegalCaseFormDataEntity>> getLegalCaseFormData() async {
    try {
      final formData = await remoteDataSource.getLegalCaseFormData();
      return Right(formData);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on DioException catch (e) {
      return Left(ServerFailure(e.response?.data?['message'] ?? e.message ?? 'Unknown error occurred'));
    } catch (e) {
      return Left(ServerFailure('حدث خطأ غير متوقع'));
    }
  }

  @override
  Future<Either<Failure, LegalCasesListResponseEntity>> getLegalCasesList({
    int page = 1,
    int perPage = 15,
    String? status,
  }) async {
    try {
      final remoteData = await remoteDataSource.getLegalCasesList(
        page: page,
        perPage: perPage,
        status: status,
      );
      return Right(remoteData);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on DioException catch (e) {
      return Left(ServerFailure(
          e.response?.data?['message'] ?? e.message ?? 'Unknown error occurred'));
    } catch (e) {
      return Left(ServerFailure('حدث خطأ غير متوقع'));
    }
  }

  @override
  Future<Either<Failure, LegalCaseItemEntity>> getLegalCaseDetails(int id) async {
    try {
      final remoteData = await remoteDataSource.getLegalCaseDetails(id);
      return Right(remoteData);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on DioException catch (e) {
      return Left(ServerFailure(
          e.response?.data?['message'] ?? e.message ?? 'Unknown error occurred'));
    } catch (e) {
      return Left(ServerFailure('حدث خطأ غير متوقع'));
    }
  }
}
