import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import 'package:wafer/core/error/failures.dart';
import 'package:wafer/core/network/connectivity/network_info.dart';
import '../../../domain/entities/suppliers/supplier_entity.dart';
import '../../../domain/entities/suppliers/create_owner_supplier_params.dart';
import '../../../domain/entities/suppliers/update_owner_supplier_params.dart';
import '../../../domain/repositories/owner_suppliers_repository.dart';
import '../../datasources/suppliers/owner_suppliers_remote_data_source.dart';

class OwnerSuppliersRepositoryImpl implements OwnerSuppliersRepository {
  final OwnerSuppliersRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  OwnerSuppliersRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, PaginatedSuppliersEntity>> getSuppliers(int page) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.getSuppliers(page);
        return Right(result);
      } on DioException catch (e) {
        return Left(ServerFailure.fromDioException(e));
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return const Left(NetworkFailure('لا يوجد اتصال بالإنترنت'));
    }
  }

  @override
  Future<Either<Failure, SupplierEntity>> createSupplier(CreateOwnerSupplierParams params) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.createSupplier(params);
        return Right(result);
      } on DioException catch (e) {
        if (e.response?.statusCode == 422) {
          final data = e.response?.data;
          final errors = data?['errors'] as Map<String, dynamic>?;
          return Left(ServerFailure(data?['message'] ?? 'Validation Error', validationErrors: errors));
        }
        return Left(ServerFailure.fromDioException(e));
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return const Left(NetworkFailure('لا يوجد اتصال بالإنترنت'));
    }
  }

  @override
  Future<Either<Failure, SupplierEntity>> updateSupplier(int supplierId, UpdateOwnerSupplierParams params) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.updateSupplier(supplierId, params);
        return Right(result);
      } on DioException catch (e) {
        if (e.response?.statusCode == 422) {
          final data = e.response?.data;
          final errors = data?['errors'] as Map<String, dynamic>?;
          return Left(ServerFailure(data?['message'] ?? 'Validation Error', validationErrors: errors));
        }
        return Left(ServerFailure.fromDioException(e));
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return const Left(NetworkFailure('لا يوجد اتصال بالإنترنت'));
    }
  }

  @override
  Future<Either<Failure, SupplierEntity>> getSupplierDetails(int supplierId) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.getSupplierDetails(supplierId);
        return Right(result);
      } on DioException catch (e) {
        return Left(ServerFailure.fromDioException(e));
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return const Left(NetworkFailure('لا يوجد اتصال بالإنترنت'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteSupplier(int supplierId) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.deleteSupplier(supplierId);
        return const Right(null);
      } on DioException catch (e) {
        return Left(ServerFailure.fromDioException(e));
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return const Left(NetworkFailure('لا يوجد اتصال بالإنترنت'));
    }
  }
}

