import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/localization/locale_keys.dart';
import '../../domain/entities/contract_details_entity.dart';
import '../../domain/entities/contract_installment_entity.dart';
import '../../domain/entities/contracts_response_entity.dart';
import '../../domain/repositories/owner_contracts_repository.dart';
import '../datasources/owner_contracts_remote_data_source.dart';

class OwnerContractsRepositoryImpl implements OwnerContractsRepository {
  final OwnerContractsRemoteDataSource _remoteDataSource;

  OwnerContractsRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, ContractsResponseEntity>> getContracts({
    int page = 1,
    String? status,
    bool forceRefresh = false,
  }) async {
    try {
      final result = await _remoteDataSource.getContracts(page: page, status: status);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on DioException catch (e) {
      String? serverMsg;
      if (e.response?.data is Map<String, dynamic>) {
        serverMsg = (e.response?.data as Map<String, dynamic>)['message'] as String?;
      }
      return Left(ServerFailure(serverMsg ?? e.message ?? LocaleKeys.errorsServerError.tr()));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ContractDetailsEntity>> getContractDetails(String id) async {
    try {
      final result = await _remoteDataSource.getContractDetails(id);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on DioException catch (e) {
      String? serverMsg;
      if (e.response?.data is Map<String, dynamic>) {
        serverMsg = (e.response?.data as Map<String, dynamic>)['message'] as String?;
      }
      return Left(ServerFailure(serverMsg ?? e.message ?? LocaleKeys.errorsServerError.tr()));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ContractInstallmentEntity>>> getContractInstallments(String contractId) async {
    try {
      final result = await _remoteDataSource.getContractInstallments(contractId);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on DioException catch (e) {
      String? serverMsg;
      if (e.response?.data is Map<String, dynamic>) {
        serverMsg = (e.response?.data as Map<String, dynamic>)['message'] as String?;
      }
      return Left(ServerFailure(serverMsg ?? e.message ?? LocaleKeys.errorsServerError.tr()));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
